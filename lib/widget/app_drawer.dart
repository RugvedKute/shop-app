import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/screens/order_item_screen.dart';
import 'package:flutter_complete_guide/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friends!'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
            leading: Icon(Icons.shopping_bag),
            title: Text('Shop'),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(OrderItemScreen.routeName);
            },
            leading: Icon(Icons.card_giftcard),
            title: Text('Orders'),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pushNamed(UserProductScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
