import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // listener provider
    final productsData = Provider.of<Products>(context);
    final products = productsData.items; // extract data productsData
    return GridView.builder(
      padding: const EdgeInsets.all(
          10.0), // const agar EdgeInsets tidak dirender ulang ketika halaman ini dipanggil lagi.
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(products[i].id.toString(),
          products[i].title.toString(), products[i].imageUrl.toString()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
