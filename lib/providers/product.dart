import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String autor;
  final String title;
  final String description;
  final int km;
  final String price;
  final String imageUrl01;
  final String imageUrl02;
  final String imageUrl03;
  final String phone;
  final int whatsapp;
  bool isFavorite;

  Product(
      {required this.id,
      required this.autor,
      required this.title,
      required this.description,
      required this.km,
      required this.price,
      required this.imageUrl01,
      required this.imageUrl02,
      required this.imageUrl03,
      required this.phone,
      required this.whatsapp,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
