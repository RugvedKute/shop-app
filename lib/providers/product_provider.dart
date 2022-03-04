import 'dart:io';

import 'package:flutter/material.dart';

import 'products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers',
    //   price: 50.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Long and Cozy- exactly what u need for winters',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Donkey',
    //   description: 'Cute donkey',
    //   price: 80.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // )
  ];
  final String authToken;
  List<Product> itemss;
  final String userId;

  ProductsProvider(this.authToken, this.itemss, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favsItems {
    return _items.where((product) => product.isFavourite == true).toList();
  }

  Future<void> getFetchData([bool filterByUser = false]) async {
    final filterString = filterByUser
        ? <String, String>{
            'auth': '$authToken',
            'orderBy': json.encode('creatorId'),
            'equalTo': json.encode('$userId')
          }
        : <String, String>{'auth': '$authToken'};

    var url = Uri.https(
      'flutter-update-f1dbc-default-rtdb.firebaseio.com',
      '/products.json', filterString
    );
    try {
      final response = await http.get(url);
      final fetchedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
          '/userFavourites/$userId.json', filterString);
      final favoriteResponse = await http.get(url);
      final favData = json.decode(favoriteResponse.body);
      final List<Product> _loadedProducts = [];
      fetchedData.forEach((prodId, prodData) {
        _loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageurl'],
            isFavourite: favData == null ? false : favData[prodId] ?? false));
        _items = _loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final _params = <String, String>{
      'auth': '$authToken',
    };
    final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
        '/products.json', _params);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'isFavourite': product.isFavourite,
            'imageurl': product.imageUrl,
            'creatorId': userId,
          },
        ),
      );
      _items.add(
        Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProducts(String productId, Product newProduct) async {
    final index = _items.indexWhere((prod) => prod.id == productId);
    if (index >= 0) {
      final _params = <String, String>{'auth': '$authToken'};
      final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
          '/products/$productId.json', _params);
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageurl': newProduct.imageUrl,
            'price': newProduct.price
          }));

      _items[index] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void deleteProduct(String productid) async {
    final _params = <String, String>{'auth': '$authToken'};
    final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
        '/products/$productid.json', _params);
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productid);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    ;

    existingProduct = null;
  }

  void findById(String productId) {
    _items.firstWhere((product) => product.id == productId);
  }
}
