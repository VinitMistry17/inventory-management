class ApiUrls {
  //base url
  static const String baseUrl = "http://192.168.1.100:8001/api";

  //Auth
  static const String loginUrl = "$baseUrl/login";
  static const String registerUrl = "$baseUrl/register";
  static const String logoutUrl = "$baseUrl/logout";

  //items
  static const String categoriesUrl = "$baseUrl/categories";
  static const String itemsUrl = "$baseUrl/items";
}
