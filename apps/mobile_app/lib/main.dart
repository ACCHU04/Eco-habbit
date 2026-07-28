import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/router/app_router.dart';
import 'package:mobile_app/core/services/storage_service.dart';
import 'package:mobile_app/core/services/api_client.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseAvailable = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseAvailable = true;
  } catch (e, st) {
    debugPrint('Firebase initialization unavailable: $e');
    debugPrintStack(stackTrace: st);
  }

  if (firebaseAvailable) {
    try {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e) {
      debugPrint('Crashlytics setup deferred (non-fatal): $e');
    }
  }

  try {
    final storage = StorageService();
    await storage.init();

    final apiClient = ApiClient(storage);
    final authRepository = AuthRepository(apiClient);

    runApp(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          apiClientProvider.overrideWithValue(apiClient),
          authRepositoryProvider.overrideWithValue(authRepository),
          authProvider.overrideWith(
            (ref) => AuthNotifier(authRepository, storage, ref),
          ),
        ],
        child: const EcoHabitApp(),
      ),
    );
  } catch (e, st) {
    debugPrint('App initialization failed: $e');
    debugPrintStack(stackTrace: st);
    if (firebaseAvailable) {
      FirebaseCrashlytics.instance.recordError(e, st, fatal: true);
    }
    runApp(_InitErrorApp(error: 'App init failed: $e'));
  }
}

class _InitErrorApp extends StatelessWidget {
  final String error;
  const _InitErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EcoHabitApp extends ConsumerWidget {
  const EcoHabitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final storage = ref.watch(storageServiceProvider);
    final themeMode = _getThemeMode(storage.getThemeMode());

    return MaterialApp.router(
      title: 'EcoHabit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
