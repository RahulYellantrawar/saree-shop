import 'package:flutter/material.dart';
import 'package:p_sarees/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import 'badge.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (_, cart, ch) => CartBadge(
        value: cart.itemCount.toString(),
        child: ch!,
      ),
      child: IconButton(onPressed: (){
        Navigator.of(context).pushNamed(CartScreen.routeName);
      }, icon: const Icon(Icons.shopping_cart),),
    );
  }
}