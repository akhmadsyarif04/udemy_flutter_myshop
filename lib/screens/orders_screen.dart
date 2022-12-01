import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _orderFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building order');
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your Order')),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // do error handling here
                return Center(
                  child: Text('An Error occurred!'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                          itemCount: ordersData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(ordersData.orders[i]),
                        ));
              }
            }
          },
        ));
  }
}
