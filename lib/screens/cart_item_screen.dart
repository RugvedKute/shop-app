import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:provider/provider.dart';
import '../widget/cart_item.dart' as ci;

import '../providers/order.dart';

class CartItemScreen extends StatelessWidget {
  static const routeName = '/cartItemScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Chart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.total}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, i) => ci.CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].title,
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity),
                itemCount: cart.itemCount),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Chart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

var _isLoading = false;

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return _isLoading? CircularProgressIndicator()  :FlatButton(
      onPressed: (widget.cart.total <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrders(
                  widget.cart.items.values.toList(), widget.cart.total);

              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
      child: Text(
        'Order now',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
