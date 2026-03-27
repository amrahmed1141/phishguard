class ApiConstants {
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:5000';
  static const String iosSimulatorBaseUrl = 'http://127.0.0.1:5000';
  static const String predictUrl = '/predict_url';
  static const String health = '/health';

  static String get baseUrl => androidEmulatorBaseUrl;
}
