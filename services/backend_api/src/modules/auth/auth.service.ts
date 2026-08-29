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
      let uid: string;
      let email = dto.email || '';
      let name = dto.full_name || '';

      if (dto.id_token) {
        const decodedToken = await this.auth.verifyIdToken(dto.id_token);
        uid = decodedToken.uid;
        email = decodedToken.email || email;
        name = decodedToken.name || name;
      } else if (dto.access_token) {
        const tokenResp = await fetch(
          `https://oauth2.googleapis.com/tokeninfo?access_token=${encodeURIComponent(dto.access_token)}`,
        );
        if (!tokenResp.ok) {
          throw new UnauthorizedException('Invalid Google token');
        }
        const tokenInfo = (await tokenResp.json()) as Record<string, string>;
        uid = `google_${tokenInfo.sub}`;
        email = tokenInfo.email || email;
        name = tokenInfo.name || name;
      } else {
        throw new UnauthorizedException('Invalid Google token');
      }

      try {
        const { data: existingUser } = await this.supabase
          .from('users')
          .select('*')
          .eq('id', uid)
          .single();

        if (!existingUser) {
          await this.supabase.from('users').insert({
            id: uid,
            email,
            full_name: name,
            college: '',
            role: 'student',
          });
        }
      } catch (dbErr) {
        this.logger.warn(`Supabase sync warning: ${(dbErr as Error).message}`);
      }

      const customToken = await this.auth.createCustomToken(uid);

      return {
        success: true,
        data: {
          uid,
          email,
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
