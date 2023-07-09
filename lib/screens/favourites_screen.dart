import 'package:flutter/material.dart';
import 'package:p_sarees/widgets/products_grid.dart';

import '../constants/colors.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Favorites', style: TextStyle(
                fontFamily: 'Exo_2',
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),),
              SizedBox(height: 15,),
              Flexible(
                  fit: FlexFit.loose,
                  child: ProductsGrid(true, '')),
            ],
          ),
        ),
      ),
    );
  }
}
