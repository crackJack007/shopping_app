import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/enums/category_item.dart';
import 'package:shopping_app/view/login.dart';
import 'package:shopping_app/view_model/product_list_vm.dart';
import '../model/product_model.dart';
import '../enums/status.dart';
import '../widgets/error_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_grid_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductListVM viewModel = ProductListVM();
  TextEditingController searchController = TextEditingController();

  void logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void initState() {
    viewModel.fetchProduct();
    super.initState();
  }

  List categoryList = ['electronics', 'jewelery', 'men', 'women'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 60, top: 10, bottom: 10),
              child: SearchBar(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                controller: searchController,
                leading: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                onChanged: (value) {
                  viewModel.searchProduct(value);
                },
              ),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
          PopupMenuButton<Categories>(
              onSelected: (value) {
                if (value.name == 'men') {
                  viewModel.searchMenCategory(value.name);
                } else if (value.name == 'all') {
                  viewModel.addAllProducts(value.name);
                } else {
                  viewModel.searchCategory(value.name);
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: Categories.electronics,
                        child: Text('Electronics')),
                    const PopupMenuItem(
                        value: Categories.jewelery, child: Text('Jewelery')),
                    const PopupMenuItem(
                        value: Categories.men, child: Text('Men\'s Clothing')),
                    const PopupMenuItem(
                        value: Categories.women,
                        child: Text('Women\'s Clothing')),
                    const PopupMenuItem(
                      value: Categories.all,
                      child: Text('All Products'),
                    ),
                  ])
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: null,
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
                  onTap: logout,
                )
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider<ProductListVM>(
          create: (BuildContext context) => viewModel,
          child: Consumer<ProductListVM>(
            builder: (context, viewModel, _) {
              switch (viewModel.productMain.status) {
                case Status.LOADING:
                  if (kDebugMode) {
                    print("LOADING");
                  }
                  return LoadingWidget();
                case Status.ERROR:
                  if (kDebugMode) {
                    print("ERROR");
                  }
                  return MyErrorWidget(viewModel.productMain.message ?? "NA");
                case Status.COMPLETED:
                  if (kDebugMode) {
                    print("COMPLETED");
                  }
                  // allProductList.clear();
                  // filteredList.clear();
                  // allProductList.addAll(viewModel.productMain.data!);
                  // filteredList.addAll(allProductList);

                  return productGridView(viewModel.productMain.data!);
                default:
              }
              return Container();
            },
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
