import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widget/product_item.dart';
import 'package:flutter_complete_guide/widget/user_product.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProductScreen';

  Future<void> refreshData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getFetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final ProductData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products!!'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder(
          future: refreshData(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => refreshData(context),
                      child: Consumer<ProductsProvider>(
                        builder: (ctx, ProductData, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: ProductData.items.length,
                            itemBuilder: (ctx, int index) => Column(
                              children: [
                                UserProduct(
                                  ProductData.items[index].id,
                                  ProductData.items[index].title,
                                  ProductData.items[index].imageUrl,
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
