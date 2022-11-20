import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // listener provider
    final productsData = Provider.of<Products>(context);
    final products = showFavs
        ? productsData.favoriteItems
        : productsData.items; // extract data productsData
    return GridView.builder(
      padding: const EdgeInsets.all(
          10.0), // const agar EdgeInsets tidak dirender ulang ketika halaman ini dipanggil lagi.
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
          // builder: (c) => products[i], // ini bisa diganti dengan create dibawah
          /* Since provider version 3.2.0 "builder" is marked as deprecated in favor of "create". */
          create: (c) => products[i],
          child: ProductItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
