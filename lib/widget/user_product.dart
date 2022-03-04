import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';

class UserProduct extends StatefulWidget {
  String id;
  String title;
  String ImageUrl;

  UserProduct(this.id, this.title, this.ImageUrl);

  @override
  State<UserProduct> createState() => _UserProductState();
}

class _UserProductState extends State<UserProduct> {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.ImageUrl),
      ),
      title: Text(widget.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: widget.id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(widget.id);
                } catch (error) {
                  scaffold
                      .showSnackBar(SnackBar(content: Text('deleting failed'),),);
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
