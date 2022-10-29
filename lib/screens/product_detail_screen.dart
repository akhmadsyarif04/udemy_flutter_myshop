import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

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
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productid);
    /*
        listen: false = jika ada perubahan dari listen dan products data provider maka akan render bagian ini saja. bagus untuk digunakan dalam mendapatkan atau mencari data pada state management provider.
        listen: true = maka semua yang memanggil provider products ketika ada perubahan akan dirender ulang. (default)
        */
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title.toString())),
    );
  }
}
