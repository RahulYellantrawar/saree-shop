import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: Container(
          color: gridLabelColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: gridTitleColor
                  ),
                ),
                Text(
                  '\u{20B9}${product.price}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: gridPriceColor,
                  ),
                )
              ],
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: Stack(
              children: [
                product.images.isNotEmpty
                    ? FadeInImage(
                        fadeInCurve: Curves.decelerate,
                        placeholder:
                            const AssetImage('assets/images/placeholder.png'),
                        image: NetworkImage(product.images[0]),
                        fit: BoxFit.contain,
                      )
                    : const SizedBox(),
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    icon: Icon(product.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
