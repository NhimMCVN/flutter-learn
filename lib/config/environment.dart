class Environment {
  static const String authApiBaseUrl = String.fromEnvironment(
    'AUTH_API_BASE_URL',
    defaultValue: 'https://x8ki-letl-twmt.n7.xano.io/api:qlhlF8OV',
  );

  static const String notesApiBaseUrl = String.fromEnvironment(
    'NOTES_API_BASE_URL',
    defaultValue: 'https://x8ki-letl-twmt.n7.xano.io/api:D6nCcBx0',
  );

  static const String apiBaseUrl = authApiBaseUrl;

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';
  static const bool isStaging = environment == 'staging';

  static const String authLoginEndpoint = '/auth/login';
  static const String authRegisterEndpoint = '/auth/signup';
  static const String notesEndpoint = '/note';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
}
