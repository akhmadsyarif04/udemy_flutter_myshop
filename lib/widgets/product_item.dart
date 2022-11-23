import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../screens/product_detail_screen.dart";
import "../providers/product.dart";
import "../providers/cart.dart";

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    print('product rebuild');
    return ClipRRect(
        borderRadius: BorderRadius.circular(
            10), // wajib menggunakan ClipRRect untuk menambahkan border radius
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl.toString(),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.grey,
            leading: Consumer<Product>(
              builder: (ctx, Product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoritStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title.toString(),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(product.id!, product.price!, product.title!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                )); // snackbar adalah UI yang tampil dari bawah untuk menampilkan suatu informasi
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ));
  }
}
