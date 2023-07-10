import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';
import '../response/app_exception.dart';
import 'api_service.dart';

class NetworkApiService extends ApiService {
  final List<ProductModel> _product = [];

  @override
  Future getProductsDetailsFromApi() async {
    try {
      Uri input = Uri.parse(apiUrl);
      debugPrint(apiUrl);
      var response = await http.get(input);
      debugPrint(response.body);
      List productJson = returnResponse(response) as List;
      for (var productDynamic in productJson) {
        ProductModel p = ProductModel.fromJson(productDynamic);
        _product.add(p);
      }
      if (kDebugMode) {
        print(_product);
      }
      return _product;
    } on SocketException {
      throw FetchDataException('No internet connection');
    } catch (e) {
      debugPrint('Caught error : $e');
    }
  }

  @override
  Future postResponse(String url, Map<String, String> jsonBody) async {
    dynamic responseJson;
    try {
      final response = await http.post(Uri.parse(apiUrl + url), body: jsonBody);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print(response.body);
        List doctorsJson = jsonDecode(response.body) as List;
        return doctorsJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
