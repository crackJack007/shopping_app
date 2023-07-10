import 'package:shopping_app/model/product_model.dart';
import 'package:shopping_app/repository/products_repo.dart';

import '../data/api_service.dart';
import '../data/network_api.dart';

class ProductRepoImp implements ProductRepo {
  ApiService apiService = NetworkApiService();

  @override
  Future<List<ProductModel>?> getProductList() async {
    try {
      var response = await apiService.getProductsDetailsFromApi();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
