import 'package:flutter/material.dart';
import 'package:p_sarees/widgets/plus_minus_buttons.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final product = loadedProduct;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.015, vertical: size.height * 0.003),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: Container(
          padding: EdgeInsets.only(
            left: size.width * 0.013,
            top: size.width * 0.013,
            bottom: size.width * 0.013,
            right: size.width * 0.013,
          ),
          height: size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.03),
            color: Colors.blueGrey,
          ),
          child: Row(
            children: [
              Container(
                height: size.height * 0.3,
                width: size.width * 0.35,
                padding: EdgeInsets.only(
                  left: size.width * 0.0025,
                  top: size.width * 0.0025,
                  bottom: size.width * 0.0025,
                  right: size.width * 0.0025,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                  child: FadeInImage(
                    placeholder:
                        const AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(product.images[0]),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.01,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.55,
                    child: Text(
                      title,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontFamily: 'Exo_2',
                        fontSize: size.width * 0.08,
                      ),
                    ),
                  ),
                  Text(
                    '\u{20B9}${(loadedProduct.price)}',
                    style: TextStyle(
                      fontFamily: 'Open_Sans',
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ValueListenableBuilder<int>(
                      valueListenable: ValueNotifier<int>(quantity),
                      builder: (context, val, child) {
                        return PlusMinusButtons(
                          addQuantity: () {
                            Provider.of<Cart>(
                              context,
                              listen: false,
                            ).addQuantity(productId);
                          },
                          deleteQuantity: () {
                            Provider.of<Cart>(
                              context,
                              listen: false,
                            ).deleteQuantity(productId);
                          },
                          text: val.toString(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: size.width * 0.04),
                          ),
                          Text(
                            '\u{20B9}${(price * quantity).toStringAsFixed(1)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.07,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Are you sure'),
                                  content: const Text(
                                    'Do you want to remove the item from the cart?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                        Provider.of<Cart>(
                                          context,
                                          listen: false,
                                        ).removeItem(productId);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
