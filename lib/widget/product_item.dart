import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';

import 'package:flutter_complete_guide/screens/product_item_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Chart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductItemScreen.routeName,
              arguments: products.id,
            );
          },
            child: Hero(
              tag: products.id ,child: FadeInImage(placeholder: AssetImage('assets/images/product-placeholder.png'), image: NetworkImage(products.imageUrl),fit: BoxFit.cover,))
          ),
      
        footer: GridTileBar(
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.additems(products.id, products.title, products.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Added item to Cart!'),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(products.id);
                      }),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                products.toggleFavourite(authData.token, authData.userId);
              },
              icon: Icon(products.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border),
            ),
            // child: Text('Changed!')
          ),
          backgroundColor: Colors.black54,
          title: Text(products.title,
              style: TextStyle(fontSize: 12, fontFamily: 'Anton'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade),
        ),
      ),
    );
  }
}
