import 'dart:convert';

import 'package:flutter/widgets.dart';
import './cart.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<ChartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  final String authToken;
  List<OrderItem> orderss;
  String userId;

  Order(this.authToken, this.orderss, this.userId);
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getFetchData() async {
    final _params = <String, String>{'auth': '$authToken'};
    final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
        '/orders/$userId.json', _params);
    final response = await http.get(url);
    List<OrderItem> loadedProducts = [];
    final extarctedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extarctedData == null) {
      return;
    }
    extarctedData.forEach((prodID, prodData) {
      loadedProducts.add(
        OrderItem(
          id: prodID,
          amount: prodData['amount'],
          dateTime: DateTime.parse(prodData['dateTime']),
          products: (prodData['products'] as List<dynamic>).map((prod) {
            ChartItem(
              id: prod['id'],
              quantity: prod['quantity'],
              price: prod['price'],
              title: prod['title'],
            );
          }).toList(),
        ),
      );
      _orders = loadedProducts;
      notifyListeners();
    });
  }

  Future<void> addOrders(List<ChartItem> orderProduct, double amount) async {
    final timeStamp = DateTime.now();
    final _params = <String, String>{'auth': '$authToken'};
    final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
        '/orders/$userId.json', _params);
    final response = await http.post(
      url,
      body: json.encode({
        'amount': amount,
        'dateTime': timeStamp.toIso8601String(),
        'products': orderProduct
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity
                })
            .toList()
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: amount,
        products: orderProduct,
        dateTime: timeStamp,
      ),
    );

    notifyListeners();
  }
}
