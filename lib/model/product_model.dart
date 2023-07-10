import 'dart:convert';

ProductsMain productsMainFromJson(String str) =>
    ProductsMain.fromJson(json.decode(str));

String productsMainToJson(ProductsMain data) => json.encode(data.toJson());

class ProductsMain {
  ProductsMain(this.products);

  List<ProductModel>? products;

  factory ProductsMain.fromJson(Map<String, dynamic> json) => ProductsMain(
        json["products"] == null
            ? null
            : List<ProductModel>.from(
                json["products"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class ProductModel {
  int? id;
  String? title;
  String? price;
  String? description;
  String? category;
  String? image;
  Map<String,dynamic>? rating;

  ProductModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toString(),
      description: json["description"],
      image: json['image'],
      category: json["category"],
      rating: json["rating"]);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'image': image,
        'category': category,
        'rating': rating,
      };

  // Map<String, dynamic> quantityMap() {
  //   return {
  //     'productId': id,
  //     'quantity': quantity!.value,
  //   };
  // }
}
