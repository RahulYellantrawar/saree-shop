import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontFamily: 'Exo_2',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.010,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.09,
        width: double.infinity,
        color: Colors.white,
        // margin: EdgeInsets.all(15),
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.008),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: size.width * 0.04, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.025, bottom: size.width * 0.018),
                    child: Text(
                      '\u{20B9}${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.black, fontSize: size.width * 0.075),
                    ),
                  ),
                ],
              ),
              OrderButton(cart: cart),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 2,padding: EdgeInsets.symmetric(horizontal: size.width * 0.06, vertical: size.width * 0.035)
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              showAnimatedDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClassicGeneralDialogWidget(
                    titleText: 'Order Placed',
                    contentText: 'Hurray! Your order has been placed successfully!',
                    onPositiveClick: () {
                      Navigator.pop(context);
                    },
                    positiveText: 'Close',
                    positiveTextStyle: TextStyle(color: Colors.black),
                    negativeText: '',
                    negativeTextStyle: TextStyle(color: Colors.black),

                  );
                },
                animationType: DialogTransitionType.scale,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
              );
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.06
              ),
            ),
    );
  }
}
