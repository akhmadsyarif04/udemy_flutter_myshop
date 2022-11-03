import "package:flutter/foundation.dart";

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

  void toggleFavoritStatus() {
    isFavorite = !isFavorite;
    notifyListeners(); // agar provider mendengarkan bahwa ada perubahan pada data
  }
}
