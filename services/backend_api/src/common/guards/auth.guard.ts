import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  Inject,
} from '@nestjs/common';
import { getAuth } from 'firebase-admin/auth';
import { FIREBASE_ADMIN } from '../../config/firebase.module';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    @Inject(FIREBASE_ADMIN)
    private readonly firebaseApp: Record<string, unknown>,
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedException(
        'Missing or invalid authorization header',
      );
    }

    const token = authHeader.split('Bearer ')[1];

    try {
      const auth = getAuth(this.firebaseApp as any);
      const decodedToken = await auth.verifyIdToken(token);
      request.user = {
        id: decodedToken.uid,
        uid: decodedToken.uid,
        email: decodedToken.email,
      };

      const { data: profile } = await this.supabase
        .from('users')
        .select('role')
        .eq('id', decodedToken.uid)
        .single();

      request.user.role = profile?.role || 'student';

      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }
}
