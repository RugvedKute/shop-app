import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:provider/provider.dart';

// import '../providers/products.dart';
import '../widget/product_item.dart';
import '../providers/product_provider.dart';

class ProductsGrid extends StatelessWidget {
  final showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final ProductData = Provider.of<ProductsProvider>(context);
    final products = showFavs? ProductData.favsItems : ProductData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}
