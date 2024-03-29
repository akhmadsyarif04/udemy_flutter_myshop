import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavorite;
  /*
  ? mengartikan nullable, atau null valid
  */

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoritStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners(); // agar provider mendengarkan bahwa ada perubahan pada data

    var params = {
      'auth': token,
    };

    final url = Uri.https(
        'shop-app-flutter-472e2-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/userFavorites/$userId/$id.json',
        params);
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
