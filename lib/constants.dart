class Constants {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Updated for Android emulator

  // Auth endpoints
  static String loginUrl = '$baseUrl/api/login/';
  static String logoutUrl = '$baseUrl/api/logout/';
  static String registerUrl = '$baseUrl/api/register/';
  static String authStatusUrl = '$baseUrl/api/auth-status/';

  // Section heights
  static const double heroSectionHeight = 400.0;
  static const double productsSectionHeight = 300.0;
  static const double storeOwnerSectionHeight = 350.0;
  static const double joinNowSectionHeight = 300.0;

  // Request headers
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}
