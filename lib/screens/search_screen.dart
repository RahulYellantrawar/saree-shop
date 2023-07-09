import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p_sarees/screens/search_results_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> allProducts = [];
  List<Product> searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch product data from Firebase
  }

  Future<void> fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      allProducts = snapshot.docs.map((doc) {
        return Product(
          id: doc.id,
          title: doc['title'],
          price: doc['price'],
          color: doc['color'],
          blousePiece: doc['blousePiece'],
          stockAvailability: doc['stockAvailability'],
          fabricType: doc['fabricType'],
          sareeStyle: doc['sareeStyle'],
          category: doc['category'],
          blouseLength: doc['blouseLength'],
          sareeLength: doc['sareeLength'],
          pattern: doc['pattern'],
          images: doc['images'],
          isFavorite: doc['isFavorite'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    void searchProducts(String searchTerm) {
      setState(() {
        searchResults = products.prodItems.where((product) {
          final titleMatch =
              product.title.toLowerCase().contains(searchTerm.toLowerCase());
          final categoryMatch =
              product.category.toLowerCase().contains(searchTerm.toLowerCase());
          final colorMatch =
              product.color.toLowerCase().contains(searchTerm.toLowerCase());
          return titleMatch || categoryMatch || colorMatch;
        }).toList();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          onChanged: searchProducts,
          decoration: const InputDecoration(
            hintText: 'Search for products...',
          ),
          onSubmitted: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsScreen(value),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return InkWell(
            child: Column(
              children: [
                ListTile(
                  title: Text(product.title),
                ),
                ListTile(
                  title: Text(product.category),
                ),
                ListTile(
                  title: Text(product.color),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultsScreen(product.title),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
