import 'dart:convert'; // untuk convert data

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  var authToken;
  var userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners(); // untuk memerintahkan state management cek perubahan data
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners(); // untuk memerintahkan state management cek perubahan data
  // }

  void updateUser(String token, String id) {
    print('updateUser');
    this.userId = id;
    this.authToken = token;
    notifyListeners();
  }

  // tanda [] pada argument artinya optional, akan tetapi wajib default value
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    var params;
    if (filterByUser == true) {
      params = <String, String?>{
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }

    if (filterByUser == false) {
      print(authToken);
      params = <String, String?>{
        'auth': authToken,
      };
    }

    var url = Uri.https(
        'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        params);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData.isEmpty || extractedData['error'] != null) {
        return;
      }

      params = {
        'auth': authToken,
      };

      url = Uri.https(
          'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/userFavorites/$userId.json',
          params);
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null
              ? false
              : favoriteData[prodId] ??
                  false, // jika favoriteData[prodId] masih null maka beri false
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    var params = {
      'auth': authToken,
    };

    // begin send add data to firebase
    // https://shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app/
    final url = Uri.https(
        'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        params);
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          }));

      // begin add to local data state provider
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // end add to local data state provider

      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
    // end send add data to firebase
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var params = {
      'auth': authToken,
    };
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      // jika terdapat id yang sama, artinya data yang diperbarui ada dalam list _items
      // maka perbarui
      final url = Uri.https(
          'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/products/${id}.json',
          params);
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('tidak ditemukan id/data yang ingin diupdate');
    }
  }

  Future<void> deleteProduct(String id) async {
    var params = {
      'auth': authToken,
    };
    final url = Uri.https(
        'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
        params);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);

    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(
          'Could not delete product.'); // customisasi error HttpException
    }

    existingProduct = null;
  }
}
