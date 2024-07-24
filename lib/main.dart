import 'package:flutter/material.dart';
import 'package:order_up/items/search_for_supplier.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/cart_component/shopping_cart_screen.dart';
import 'package:order_up/widgets/home_component/ordering_history.dart';
import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';
import 'package:order_up/widgets/loading_component/loading_screen.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:order_up/widgets/manage_product_componenet/add_edit_product.dart';
import 'package:order_up/widgets/manage_product_componenet/manage_product.dart';
import 'package:order_up/widgets/orders_component/order_progres.dart';
import 'package:order_up/widgets/product_component/product_details.dart';
import 'package:order_up/widgets/profile_component/profile_screen.dart';
import 'package:order_up/widgets/sales_component/sales_screen.dart';
import 'package:order_up/widgets/supplier_home_componenet/all_orders.dart';
import 'package:order_up/widgets/supplier_lists_component/suppliers_screens.dart';
import 'package:provider/provider.dart';

import 'widgets/supplier_home_componenet/supplier_homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, auth, previousProducts) => previousProducts!
            ..setAuth(
              auth.token ?? '',
              auth.userId,
              previousProducts == null ? [] : previousProducts.products,
            ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrders) => previousOrders!
            ..setAuth(
              auth.token ?? '',
              auth.userId,
              auth.userName ?? '',
              auth.userType ?? '',
              previousOrders == null ? [] : previousOrders.orders,
            ),
        ),
        ChangeNotifierProvider(
          create: (context) => Suppliers(),
        ),
      ],
      child: MaterialApp(
        title: 'Order Up',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: StatefulBuilder(
          builder: (ctx, _) {
            final auth = ctx.watch<Auth>();

            return auth.isAuth
                ? (auth.userType == 'restaurant'
                    ? ResturantMainPageScreen()
                    : SupplierHomepage())
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? LoadingScreen()
                            : LoginScreen(),
                  );
          },
        ),
        // initialRoute: LoginScreen.routeName,
        routes: {
          // TwoUsers.routeName: (context) => TwoUsers(),
          LoginScreen.routeName: (c) => LoginScreen(),
          ResturantMainPageScreen.routeName: (c) => ResturantMainPageScreen(),
          SuppliersScreens.routeName: (c) => SuppliersScreens(),
          ProductDetails.routeName: (c) => ProductDetails(),
          SearchForSupplier.routeName: (c) => SearchForSupplier(),
          ShoppingCartScreen.routeName: (c) => ShoppingCartScreen(),
          OrderingHistory.routeName: (c) => OrderingHistory(),
          ProfileScreen.routeName: (c) => ProfileScreen(),
          OrderProgres.routeName: (c) => OrderProgres(),
          SupplierHomepage.routeName: (c) => SupplierHomepage(),
          ManageProduct.routeName: (c) => ManageProduct(),
          AddEditProduct.routeName: (c) => AddEditProduct(),
          SalesScreen.routeName: (c) => SalesScreen(),
          AllOrders.routeName: (c) => AllOrders(),
        },
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => LoginScreen()),
      ),
    );
  }
}
