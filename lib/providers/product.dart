import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  bool? isFavorite;
  final String pattern;
  final String color;
  final double sareeLength;
  final double blouseLength;
  final String category;
  final String sareeStyle;
  final String stockAvailability;
  final String fabricType;
  final String blousePiece;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.isFavorite = false,
    required this.pattern,
    required this.color,
    required this.sareeLength,
    required this.blouseLength,
    required this.category,
    required this.sareeStyle,
    required this.stockAvailability,
    required this.fabricType,
    required this.blousePiece,
    this.images = const [],
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async{
    final oldStatus = isFavorite;
    isFavorite = !(isFavorite ?? false);
    notifyListeners();
    final url =
        'https://pochampally-sarees-8cd71-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(Uri.parse(url), body: json.encode({
        'isFavorite': isFavorite,
      }),);
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus ?? false);
      }
    } catch (error) {
      _setFavValue(oldStatus ?? false);
    }
  }
}
