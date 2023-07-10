import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shopping_app/enums/category_item.dart';
import 'package:shopping_app/model/product_model.dart';
import '../repository/products_repo_impl.dart';
import '../response/api_response.dart';

class ProductListVM extends ChangeNotifier {
  final myRepo = ProductRepoImp();

  ApiResponse<List<ProductModel>> productMain = ApiResponse.loading();
  List<ProductModel> allProducts = [];

  void setProductMain(ApiResponse<List<ProductModel>> response) {
    print("$response");
    productMain = response;
    notifyListeners();
  }

  Future<void> fetchProduct() async {
    setProductMain(ApiResponse.loading());
    myRepo.getProductList().then((value) {
      allProducts = value!;
      return setProductMain(ApiResponse.completed(value));
    }).onError((error, stackTrace) =>
        setProductMain(ApiResponse.error(error.toString())));
  }

  Future<void> searchProduct(String searchedText) async {
    List<ProductModel> filteredList = [];

    setProductMain(ApiResponse.loading());

    debugPrint(
        "searchProduct - allProducts before filtering : ${allProducts.length}");

    if (searchedText.isNotEmpty) {
      for (var element in allProducts) {
        if (element.title!.toLowerCase().contains(searchedText.toLowerCase()) ||
            element.description!
                .toLowerCase()
                .contains(searchedText.toLowerCase())) {
          filteredList.add(element);
        }
      }
      setProductMain(ApiResponse.completed(filteredList));
      debugPrint("searchProduct - filteredList : ${filteredList.length}");
    } else {
      setProductMain(ApiResponse.completed(allProducts));
      debugPrint("searchProduct - allProducts : ${allProducts.length}");
    }
  }

  void searchCategory(String value) {
    List<ProductModel> categoryList = [];
    setProductMain(ApiResponse.loading());
    for (var element in allProducts) {
      debugPrint(
          'element Category: ${element.category} / element value: $value');
       if (element.category!.contains(value)) {
        categoryList.add(element);
      }
    }
    setProductMain(ApiResponse.completed(categoryList));
  }

  void searchMenCategory(String value) {
    List<ProductModel> menClothingList = [];
    setProductMain(ApiResponse.loading());
    for (var element in allProducts) {
      if (element.category!.contains(value) &&
          element.category!.startsWith('men')) {
        menClothingList.add(element);
      }
    }
    setProductMain(ApiResponse.completed(menClothingList));
  }

  void addAllProducts(String value){
    List<ProductModel> allProductList = [];
    for(var element in allProducts){
    allProductList.add(element);
    }
    setProductMain(ApiResponse.completed(allProductList));
  }

}
