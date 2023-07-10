import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/product_detail.dart';
import '../model/product_model.dart';

Widget productGridView(List<ProductModel>? productsList) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 1),
    itemCount: productsList?.length,
    itemBuilder: (context, position) {
      if(productsList!.isNotEmpty){
        return getProductGridItem(productsList[position],context);
      }else{
        return const SizedBox();
      }

    },
  );
}

Widget getProductGridItem(ProductModel product, BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                        title: product.title,
                        category: product.category,
                        description: product.description,
                        id: product.id,
                        image: product.image,
                        price: product.price,
                        rating: product.rating)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 150,
                  height: 100,
                  child: Material(
                    child: FadeInImage(
                        placeholder: const AssetImage('assets/images/place_holder.png'),
                        image: NetworkImage('${product.image}'),
                        fit: BoxFit.fill),
                  )),
              Flexible(
                  child: Text('${product.title}',
                      maxLines: 3, overflow: TextOverflow.ellipsis)),
              Text('\$${product.price}'),
              // Text('${product.description}')
            ],
          )),
    ),
  );
}
