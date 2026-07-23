import { Injectable, Inject, Logger } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { AxiosResponse } from 'axios';
import * as crypto from 'crypto';
import { ClassifyResponse } from './dto/classify.dto';

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);
  private readonly aiServiceUrl: string;

  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
    private readonly httpService: HttpService,
  ) {
    this.aiServiceUrl = process.env.AI_SERVICE_URL || 'http://localhost:8000';
  }

  private computeHash(data: Buffer | string): string {
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  async classifyImage(userId: string, imageBuffer: Buffer, imageUrl: string) {
    const imageHash = this.computeHash(imageBuffer);

    // Tier 1: Check PostgreSQL ai_scan_cache (durable)
    const { data: cached } = await this.supabase
      .from('ai_scan_cache')
      .select('result')
      .eq('image_hash', imageHash)
      .gt('expires_at', new Date().toISOString())
      .single();

    if (cached) {
      this.logger.log(`Cache HIT for hash ${imageHash.substring(0, 12)}...`);
      await this.recordScan(userId, imageUrl, cached.result);
      return { ...cached.result, cached: true };
    }

    this.logger.log(`Cache MISS for hash ${imageHash.substring(0, 12)}...`);

    // Tier 2: Forward to FastAPI (which has its own Redis cache)
    const formData = new FormData();
    const blob = new Blob([new Uint8Array(imageBuffer)], {
      type: 'image/jpeg',
    });
    formData.append('file', blob, 'image.jpg');

    const response = await firstValueFrom<AxiosResponse<ClassifyResponse>>(
      this.httpService.post(
        `${this.aiServiceUrl}/api/v1/ai/classify`,
        formData,
        {
          headers: { 'Content-Type': 'multipart/form-data' },
          timeout: 30000,
        },
      ),
    );
    const aiResult = response.data;

    // Persist to ai_scan_cache (30-day TTL)
    const expiresAt = new Date(
      Date.now() + 30 * 24 * 60 * 60 * 1000,
    ).toISOString();
    await this.supabase.from('ai_scan_cache').insert({
      image_hash: imageHash,
      result: aiResult,
      expires_at: expiresAt,
    });

    // Record scan in user history
    await this.recordScan(userId, imageUrl, aiResult.result);

    return { ...aiResult, cached: false };
  }

  async classifyImageByUrl(userId: string, imageUrl: string) {
    const urlHash = this.computeHash(imageUrl);

    // Tier 1: Check PostgreSQL ai_scan_cache
    const { data: cached } = await this.supabase
      .from('ai_scan_cache')
      .select('result')
      .eq('image_hash', urlHash)
      .gt('expires_at', new Date().toISOString())
      .single();

    if (cached) {
      await this.recordScan(userId, imageUrl, cached.result);
      return { ...cached.result, cached: true };
    }

    // Forward URL to FastAPI
    const formData = new FormData();
    formData.append('image_url', imageUrl);

    const response = await firstValueFrom<AxiosResponse<ClassifyResponse>>(
      this.httpService.post(
        `${this.aiServiceUrl}/api/v1/ai/classify`,
        formData,
        {
          headers: { 'Content-Type': 'multipart/form-data' },
          timeout: 30000,
        },
      ),
    );
    const aiResult = response.data;

    // Cache by URL hash
    const expiresAt = new Date(
      Date.now() + 30 * 24 * 60 * 60 * 1000,
    ).toISOString();
    await this.supabase.from('ai_scan_cache').insert({
      image_hash: urlHash,
      result: aiResult,
      expires_at: expiresAt,
    });

    await this.recordScan(userId, imageUrl, aiResult.result);

    return { ...aiResult, cached: false };
  }

  private async recordScan(userId: string, imageUrl: string, result: any) {
    await this.supabase.from('ai_scans').insert({
      user_id: userId,
      image_url: imageUrl,
      classification: result.category,
      confidence: result.confidence,
      disposal_tips: result.disposal_tips,
    });
  }

  async getScanHistory(userId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    const { data, error, count } = await this.supabase
      .from('ai_scans')
      .select('*', { count: 'exact' })
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) throw new Error(error.message);

    return {
      success: true,
      data,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit),
      },
    };
  }

  async checkCache(imageHash: string) {
    const { data } = await this.supabase
      .from('ai_scan_cache')
      .select('result, expires_at')
      .eq('image_hash', imageHash)
      .gt('expires_at', new Date().toISOString())
      .single();

    return data || null;
  }
}
