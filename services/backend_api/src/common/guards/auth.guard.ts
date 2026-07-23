import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  Inject,
} from '@nestjs/common';
import { getAuth } from 'firebase-admin/auth';
import { FIREBASE_ADMIN } from '../../config/firebase.module';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    @Inject(FIREBASE_ADMIN)
    private readonly firebaseApp: Record<string, unknown>,
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
        // TODO: Remove 'uid' once all controllers use 'id'
        uid: decodedToken.uid,
        email: decodedToken.email,
      };
      return true;
    } catch (error) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }
}
