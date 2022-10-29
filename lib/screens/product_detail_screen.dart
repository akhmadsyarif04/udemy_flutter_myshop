import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // ProductDetailScreen(this.title);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) return SizedBox.shrink();
    final productid = route.settings.arguments as String; // this is id
    // selanjutnya dapatkan semua data dari id yang didapat

    return Scaffold(
      appBar: AppBar(title: Text('title')),
    );
  }
}
