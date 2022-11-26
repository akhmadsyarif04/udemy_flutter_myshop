import 'package:flutter/material.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/user_product_item.dart';

import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'Your Products'), // yang memiliki type const disini tidak akan direbuild flutter karena flutter tau itu tidak akan berubah
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ]),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                  productsData.items[i].id!,
                  productsData.items[i].title!,
                  productsData.items[i].imageUrl!),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
