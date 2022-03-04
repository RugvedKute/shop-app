import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import '../providers/order.dart' as o;

class OrderItem extends StatefulWidget {
  final o.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20.0 + 150, 180) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat.yMMMMEEEEd().format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
              
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height:  _expanded?  min(widget.order.products.length * 20.0 + 20.0, 180) : 95,
                  child: ListView(
                    children: 
                      widget.order.products
                          .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prod.title,
                                    style: TextStyle(color: Colors.grey,
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text('${prod.quantity}x\$${prod.price}', style: TextStyle(
                                    color: Colors.black, fontSize: 18
                                  ),)
                                ],
                              ))
                          .toList()
                    ,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
