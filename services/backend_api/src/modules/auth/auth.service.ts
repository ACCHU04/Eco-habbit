import {
  Injectable,
  Inject,
  UnauthorizedException,
  ConflictException,
  Logger,
} from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { FIREBASE_ADMIN } from '../../config/firebase.module';
import { CreateRegisterDto } from './dto/register.dto';
import { CreateLoginDto } from './dto/login.dto';
import { CreateGoogleDto } from './dto/google.dto';
import { getAuth } from 'firebase-admin/auth';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
    @Inject(FIREBASE_ADMIN)
    private readonly firebaseApp: Record<string, unknown>,
  ) {}

  private get auth() {
    return getAuth(this.firebaseApp as any);
  }

  async register(dto: CreateRegisterDto) {
    const { data: existingUser } = await this.supabase
      .from('users')
      .select('id')
      .eq('email', dto.email)
      .single();

    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    let userRecord;
    try {
      userRecord = await this.auth.createUser({
        email: dto.email,
        password: dto.password,
        displayName: dto.full_name,
      });
    } catch (fbErr) {
      this.logger.error(`Firebase createUser error: ${(fbErr as Error).message}`, (fbErr as Error).stack);
      throw new Error(`Auth creation failed: ${(fbErr as Error).message}`);
    }

    const { error } = await this.supabase.from('users').insert({
      id: userRecord.uid,
      email: dto.email,
      full_name: dto.full_name,
      college: dto.college,
      role: dto.role,
    });

    if (error) {
      this.logger.error(`Supabase insert error: ${error.message}`);
      throw new Error(error.message);
    }

    const customToken = await this.auth.createCustomToken(userRecord.uid);

    return {
      success: true,
      data: {
        uid: userRecord.uid,
        email: dto.email,
        full_name: dto.full_name,
        custom_token: customToken,
      },
    };
  }

  async login(dto: CreateLoginDto) {
    try {
      const userRecord = await this.auth.getUserByEmail(dto.email);

      const { data: user } = await this.supabase
        .from('users')
        .select('*')
        .eq('id', userRecord.uid)
        .single();

      const customToken = await this.auth.createCustomToken(userRecord.uid);

      return {
        success: true,
        data: {
          uid: userRecord.uid,
          email: userRecord.email,
          full_name: user?.full_name,
          custom_token: customToken,
        },
      };
    } catch (error) {
      throw new UnauthorizedException('Invalid credentials');
    }
  }

  async googleLogin(dto: CreateGoogleDto) {
    try {
      const decodedToken = await this.auth.verifyIdToken(dto.id_token);

      try {
        const { data: existingUser } = await this.supabase
          .from('users')
          .select('*')
          .eq('id', decodedToken.uid)
          .single();

        if (!existingUser) {
          await this.supabase.from('users').insert({
            id: decodedToken.uid,
            email: decodedToken.email,
            full_name: decodedToken.name || '',
            college: '',
            role: 'student',
          });
        }
      } catch (dbErr) {
        this.logger.warn(`Supabase sync warning: ${(dbErr as Error).message}`);
      }

      const customToken = await this.auth.createCustomToken(decodedToken.uid);

      return {
        success: true,
        data: {
          uid: decodedToken.uid,
          email: decodedToken.email,
          custom_token: customToken,
        },
      };
    } catch (error) {
      this.logger.error(`googleLogin error: ${(error as Error).message}`, (error as Error).stack);
      throw new UnauthorizedException('Invalid Google token');
    }
  }

  async logout() {
    return {
      success: true,
      message: 'Logged out successfully',
    };
  }
}
