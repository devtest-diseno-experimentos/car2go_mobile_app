class Constant {
  static const String BASE_URL =
      "https://car2go-webservice-c6h8hqd2c0eehsd3.canadacentral-01.azurewebsites.net/";

  static const String RESOURCE_PATH = "api/v1/";

  static String getEndpoint(String route, [String path = ""]) {
    return BASE_URL + RESOURCE_PATH + route + path;
  }
}
