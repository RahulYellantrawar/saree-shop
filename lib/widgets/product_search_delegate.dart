import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (query.isEmpty) {
          close(
            context,
            Product(
              id: '',
              title: '',
              price: 0,
              pattern: '',
              color: '',
              sareeLength: 0,
              blouseLength: 0,
              category: '',
              sareeStyle: '',
              stockAvailability: '',
              fabricType: '',
              blousePiece: '',
            ),
          );
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = products.where((product) {
      final queryLower = query.toLowerCase();
      return product.title.toLowerCase().contains(queryLower) ||
          product.category.toLowerCase().contains(queryLower) ||
          product.color.toLowerCase().contains(queryLower) ||
          product.sareeStyle.toLowerCase().contains(queryLower);
    }).toList();

    if (searchResults.isEmpty) {
      return const Center(
        child: Text('No products found :('),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final product = searchResults[index];
        return ListTile(
          title: Text(product.title),
          subtitle: Text(product.category),
          onTap: () {
            close(context, product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = products.where((product) {
      final queryLower = query.toLowerCase();
      return product.title.toLowerCase().contains(queryLower) ||
          product.category.toLowerCase().contains(queryLower) ||
          product.color.toLowerCase().contains(queryLower) ||
          product.sareeStyle.toLowerCase().contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final product = searchResults[index];
        return ListTile(
          title: Text(product.title),
          subtitle: Text(product.category),
          onTap: () {
            query = product.title;
            showResults(context);
          },
        );
      },
    );
  }
}
