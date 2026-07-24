import { Module, Global } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { initializeApp, cert, getApps, App } from 'firebase-admin/app';

export const FIREBASE_ADMIN = 'FIREBASE_ADMIN';

@Global()
@Module({
  providers: [
    {
      provide: FIREBASE_ADMIN,
      inject: [ConfigService],
      useFactory: (config: ConfigService): App => {
        const apps = getApps();
        if (apps.length > 0) {
          return apps[0];
        }

        const projectId = config.get<string>('FIREBASE_PROJECT_ID');
        const privateKey = config
          .get<string>('FIREBASE_PRIVATE_KEY')
          ?.replace(/\\n/g, '\n');
        const clientEmail = config.get<string>('FIREBASE_CLIENT_EMAIL');

        try {
          if (privateKey && clientEmail && !privateKey.includes('dummy')) {
            return initializeApp({
              credential: cert({
                projectId,
                privateKey,
                clientEmail,
              }),
            });
          }
        } catch (_) {}

        return initializeApp({ projectId: projectId || 'echo-habbit' });
      },
    },
  ],
  exports: [FIREBASE_ADMIN],
})
export class FirebaseModule {}
