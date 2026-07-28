class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://eco-habbit.onrender.com/api/v1',
  );
  static const String aiServiceUrl = String.fromEnvironment(
    'AI_SERVICE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );
  static const String appName = 'EcoHabit';
  static const String appVersion = '2.0.0-rc1';
}
