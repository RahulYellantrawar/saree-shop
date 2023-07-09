import 'package:flutter/material.dart';
import 'package:p_sarees/constants/colors.dart';
import 'package:p_sarees/screens/search_screen.dart';
import 'package:p_sarees/widgets/cart_button.dart';
import 'package:p_sarees/widgets/products_grid.dart';

import '../providers/product.dart';

class SearchResultsScreen extends StatelessWidget {
  static const routeName = '/search results';
  final String title;
  final _showOnlyFavorites = false;
  List<Product> results = [];

  SearchResultsScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(title),
        actions: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.search), onPressed: (){
                Navigator.of(context).pushNamed(
                  SearchScreen.routeName,
                );
              },),
              const CartButton()
            ],
          )
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductsGrid(_showOnlyFavorites, title),
      ),
    );
  }
}
