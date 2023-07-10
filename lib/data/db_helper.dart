import 'package:shopping_app/model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;


class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  Future<ProductModel> insert(ProductModel cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toJson());
    return cart;
  }

  Future<List<ProductModel>?> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('cart');
    return queryResult.map((result) => ProductModel.fromJson(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  // Future<int> updateQuantity(ProductModel cart) async {
  //   var dbClient = await database;
  //   return await dbClient!.update('cart', cart.quantityMap(),
  //       where: "productId = ?", whereArgs: [cart.id]);
  // }

  Future<List<ProductModel>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
    await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => ProductModel.fromJson(e)).toList();
  }
}
