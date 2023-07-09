import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'products_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  final String searchTerm;

  const ProductsGrid(this.showOnlyFavorites, this.searchTerm, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavorites ? productsData.favoriteItems : productsData.items;

    List<Product> filteredProducts = searchTerm.isNotEmpty
        ? products.where((product) {
            final titleMatch =
                product.title.toLowerCase().contains(searchTerm.toLowerCase());
            final categoryMatch = product.category
                .toLowerCase()
                .contains(searchTerm.toLowerCase());
            final colorMatch =
                product.color.toLowerCase().contains(searchTerm.toLowerCase());
            return titleMatch || categoryMatch || colorMatch;
          }).toList()
        : products;

    return filteredProducts.isNotEmpty
        ? GridView.builder(
            itemCount: filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 5,
              crossAxisSpacing: 15,
              mainAxisSpacing: 13,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: filteredProducts[i],
              child: const ProductItem(),
            ),
          )
        : const Center(
            child: Text(
              'No results found.',
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
