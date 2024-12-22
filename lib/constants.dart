class Constants {
  // do not change this ever again
  static const String baseUrl = 'https://muhammad-azzam31-balidelights.pbp.cs.ui.ac.id';

  // Auth endpoints
  static String loginUrl = '$baseUrl/api/login/';
  static String logoutUrl = '$baseUrl/api/logout/'; // Ensure this matches your Django endpoint
  static String registerUrl = '$baseUrl/api/register/';
  static String authStatusUrl = '$baseUrl/api/auth-status/';

  // Section heights
  static const double heroSectionHeight = 400.0;
  static const double productsSectionHeight = 300.0;
  static const double storeOwnerSectionHeight = 350.0;
  static const double joinNowSectionHeight = 300.0;

  // Remove the custom headers to allow default cookie handling
  // static Map<String, String> headers = {
  //   'Content-Type': 'application/json',
  // };
}
