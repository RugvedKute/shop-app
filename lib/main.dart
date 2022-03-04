import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/order.dart';
import 'package:flutter_complete_guide/screens/cart_item_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/order_item_screen.dart';
import 'package:flutter_complete_guide/screens/product_overview_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_product_screen.dart';
import '../providers/cart.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import '../screens/product_item_screen.dart';

import './screens/auth_screen.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider('', [], ''),
          update: (ctx, auth, previousProductProvider) => ProductsProvider(
              auth.token, previousProductProvider.itemss, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Chart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order('', [], ''),
          update: (ctx, auth, previousOrders) => Order(
              auth.token,
              previousOrders == null ? [] : previousOrders.orderss,
              auth.userId),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomTransistionBuilder(),
                TargetPlatform.iOS: CustomTransistionBuilder(),
              }
            )
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductItemScreen.routeName: (ctx) => ProductItemScreen(),
            CartItemScreen.routeName: (ctx) => CartItemScreen(),
            OrderItemScreen.routeName: (ctx) => OrderItemScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
