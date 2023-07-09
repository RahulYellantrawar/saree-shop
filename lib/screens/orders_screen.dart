import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (ctx, index) =>
              OrderItem(orderData.orders[index]),
          itemCount: orderData.orders.length,
        ),
      ),
    );
  }
}
