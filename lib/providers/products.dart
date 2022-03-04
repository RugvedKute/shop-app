import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;


  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite

  });

  void toggleFavourite(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;

    final _params = <String, String>{'auth': '$authToken'};
    final url = Uri.https('flutter-update-f1dbc-default-rtdb.firebaseio.com',
        '/userFavourites/$userId/$id.json', _params);
    final response = await http.put(
      url,
      body: json.encode(
        isFavourite,
      ),
    );

 
    notifyListeners();
  }
}
