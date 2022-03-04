import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/widget/app_drawer.dart';
import 'package:flutter_complete_guide/widget/badge.dart';
import 'package:provider/provider.dart';

import '../widget/products_grid.dart';
import '../screens/cart_item_screen.dart';

enum FilterProduct { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavouriteOnly = false;
  var _isit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isit) {
      setState(() {
      isLoading = true;
    });
      Provider.of<ProductsProvider>(context).getFetchData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: [
          Consumer<Chart>(
            builder: (_, product, ch) => Badge(
              child: ch,
              value: product.items.length.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartItemScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
              onSelected: (FilterProduct selectedProduct) {
                setState(() {
                  if (selectedProduct == FilterProduct.Favorites) {
                    _showFavouriteOnly = true;
                  } else {
                    _showFavouriteOnly = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterProduct.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterProduct.All,
                    )
                  ]),
        ],
      ),
      body:  isLoading? Center(child: CircularProgressIndicator(),) :ProductsGrid(_showFavouriteOnly),
      drawer: AppDrawer(),
    );
  }
}
