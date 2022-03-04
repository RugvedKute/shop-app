import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/order.dart' show Order;
import 'package:provider/provider.dart';
import '../widget/order_item.dart';

class OrderItemScreen extends StatelessWidget {
  static const routeName = '/orderItemScreen'; 

  @override
  Widget build(BuildContext context) {
    final OrderData = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders!'),
        ),
        body: FutureBuilder(
            future: Provider.of<Order>(context, listen: false).getFetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('An error has occured.'),
                  );
                } else {
                  return Consumer<Order>(
                    builder: (ctx, OrderData, child) => ListView.builder(
                      itemCount: OrderData.orders.length,
                      itemBuilder: (BuildContext context, int i) =>
                          OrderItem(OrderData.orders[i]),
                    ),
                  );
                }
              }
            }));
  }
}
