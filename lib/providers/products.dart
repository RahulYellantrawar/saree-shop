import 'dart:convert';

import 'package:flutter/material.dart';
import '/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> prodItems = [];
  var showFavorites = false;

  List<Product> get items {
    return [...prodItems];
  }

  List<Product> get favoriteItems {
    return prodItems.where((prodItem) => prodItem.isFavorite ?? false).toList();
  }

  bool _isInitialized = false;

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    if (!_isInitialized) {
      var url =
          'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/products.json';
      try {
        final response = await http.get(Uri.parse(url));
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        print(extractedData);
        if (extractedData == null) {
          return;
        }
        final List<Product> loadedProducts = [];
        extractedData.forEach((prodId, prodData) {
          loadedProducts.insert(
            0,
            Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              isFavorite: prodData['isFavorite'],
              color: prodData['color'],
              blousePiece: prodData['blousePiece'],
              stockAvailability: prodData['stockAvailability'],
              fabricType: prodData['fabricType'],
              sareeStyle: prodData['sareeStyle'],
              category: prodData['category'],
              blouseLength: prodData['blouseLength'],
              sareeLength: prodData['sareeLength'],
              pattern: prodData['pattern'],
              images: List<String>.from(prodData['images']),
            ),
          );
        });
        prodItems = loadedProducts;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
      _isInitialized = true;
    }
  }


  Future<void> addProduct(Product product) async {
    const url =
        'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'pattern': product.pattern,
          'color': product.color,
          'sareeLength': product.sareeLength,
          'blouseLength': product.blouseLength,
          'category': product.category,
          'sareeStyle': product.sareeStyle,
          'stockAvailability': product.stockAvailability,
          'fabricType': product.fabricType,
          'blousePiece': product.blousePiece,
          'images': product.images,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'].toString(),
        title: product.title,
        price: product.price,
        pattern: product.pattern,
        color: product.color,
        sareeLength: product.sareeLength,
        blouseLength: product.blouseLength,
        category: product.category,
        sareeStyle: product.sareeStyle,
        stockAvailability: product.stockAvailability,
        fabricType: product.fabricType,
        blousePiece: product.blousePiece,
        images: product.images,
      );
      prodItems.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Product findById(String id) {
    return prodItems.firstWhere((prod) => prod.id == id);
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = prodItems.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      prodItems[prodIndex] = newProduct;
      notifyListeners();
    }
  }
}
