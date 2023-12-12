import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'a1',
      title: 'Sentra 2005',
      description: 'Muy bueno',
      km: 160000,
      price: '90,000',
      imageUrl01:
          'https://www.ford.pe/content/dam/Ford/website-assets/latam/pe/nameplate/explorer/2022/Overview/models/xlt-3-5l-4-4/thumbnails/fpe-vehicle-group-explorer-blanco.png',
      //imageUrl02: 'https://imgfz.com/i/YaZMLvd.jpeg',
      imageUrl02:
          'https://www.ford.pe/content/dam/Ford/website-assets/latam/pe/nameplate/explorer/2022/Overview/models/xlt-3-5l-4-4/thumbnails/fpe-vehicle-group-explorer-blanco.png',
      imageUrl03:
          'https://ripleype.imgix.net/https%3A%2F%2Fdpq25p1ucac70.cloudfront.net%2Fseller-place-files%2Fmrkl-files%2F1396%2FOTRAS%20CATEGORIAS%2FCONSOLA%20SONY%20PLAYSTATION%205%20LECTORA%20DISCO%20DE%20825GB.jpg?w=750&h=555&ch=Width&auto=format&cs=strip&bg=FFFFFF&q=60&trimcolor=FFFFFF&trim=color&fit=fillmax&ixlib=js-1.1.0&s=ac2628a5773aaef3c89b697a2c2e2f7e',
      phone: '+51 926 831 100',
      whatsapp: 51926831100,
    ),
    Product(
      id: 'a2',
      title: 'Altima 2011',
      description: 'Cool',
      km: 270000,
      price: '120,000',
      imageUrl01:
          'https://ripleype.imgix.net/https%3A%2F%2Fdpq25p1ucac70.cloudfront.net%2Fseller-place-files%2Fmrkl-files%2F1396%2FOTRAS%20CATEGORIAS%2FCONSOLA%20SONY%20PLAYSTATION%205%20LECTORA%20DISCO%20DE%20825GB.jpg?w=750&h=555&ch=Width&auto=format&cs=strip&bg=FFFFFF&q=60&trimcolor=FFFFFF&trim=color&fit=fillmax&ixlib=js-1.1.0&s=ac2628a5773aaef3c89b697a2c2e2f7e',
      imageUrl02:
          'https://www.ford.pe/content/dam/Ford/website-assets/latam/pe/nameplate/explorer/2022/Overview/models/xlt-3-5l-4-4/thumbnails/fpe-vehicle-group-explorer-blanco.png',
      imageUrl03:
          'https://s7d2.scene7.com/is/image/TottusPE/42277088_1?wid=800&hei=800&qlt=70',
      phone: '+51 926 831 100',
      whatsapp: 51926831100,
    ),
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
  List<Product> get itens {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fechAndSetProducts() async {
    var url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/product.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      //print(json.decode(response.body));
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      if (extratedData == null) {
        return;
      }
      url =
          'https://prueba-164f3-default-rtdb.firebaseio.com/userFavorites/$userId/.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extratedData.forEach((prodId, prodData) {
        loadedProducts.insert(
            (0),
            Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              description: prodData['description'],
              km: prodData['km'],
              phone: prodData['phone'],
              whatsapp: prodData['whatsapp'],
              imageUrl01: prodData['imageUrl01'],
              imageUrl02: prodData['imageUrl02'],
              imageUrl03: prodData['imageUrl03'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/product.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'km': product.km,
            'phone': product.phone,
            'whatsapp': product.whatsapp,
            'imageUrl01': product.imageUrl01,
            'imageUrl02': product.imageUrl02,
            'imageUrl03': product.imageUrl03,
          }));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        km: product.km,
        phone: product.phone,
        whatsapp: product.whatsapp,
        imageUrl01: product.imageUrl01,
        imageUrl02: product.imageUrl02,
        imageUrl03: product.imageUrl03,
        isFavorite: product.isFavorite,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://prueba-164f3-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'km': newProduct.km,
            'phone': newProduct.phone,
            'whatsapp': newProduct.whatsapp,
            'imageUrl01': newProduct.imageUrl01,
            'imageUrl02': newProduct.imageUrl02,
            'imageUrl03': newProduct.imageUrl03,
            //'':newProduct.isFavorite
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProducts(String id) async {
    final url =
        'https://prueba-164f3-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('No se borró el producto');
    }
    //existingProduct = null;
  }
}
