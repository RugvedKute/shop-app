import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ChartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  ChartItem({this.id, this.title, this.price, this.quantity});
}

class Chart with ChangeNotifier {
  Map<String, ChartItem> _items = {};

  Map<String, ChartItem> get items {
    return {..._items};
  }

  double get total {
    var total = 0.00;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    ;
    return total.roundToDouble();
  }

  int get itemCount {
    return _items.length;
  }

  void additems(
    String id,
    String title,
    double price,
  ) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (exisitingCarItem) => ChartItem(
              id: exisitingCarItem.id,
              price: exisitingCarItem.price,
              title: exisitingCarItem.title,
              quantity: exisitingCarItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          id,
          () => ChartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeSingleItem(String ProductId) {
    if (!_items.containsKey(ProductId)) {
      return;
    }
    if (_items[ProductId].quantity > 1) {
      _items.update(
        ProductId,
        (existingitem) => ChartItem(
            id: existingitem.id,
            price: existingitem.price,
            title: existingitem.title,
            quantity: existingitem.quantity - 1),
      );
    } else {
      _items.remove(ProductId);
    }
  }

  void removeItems(String ProductID) {
    _items.remove(ProductID);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
