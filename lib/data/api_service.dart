abstract class ApiService {
  final String apiUrl = 'https://fakestoreapi.com/products';

  Future<dynamic> getProductsDetailsFromApi();

  Future<dynamic> postResponse(String url, Map<String, String> jsonBody);
}
