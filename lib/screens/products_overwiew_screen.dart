import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  /* 
                    setState, agar UI dibangun kembali ketika ada perubahaan data.
                    Jika tidak maka data berubah akan tetapi pada UI tidak terlihat.
                  */
                  if (selectedValue == FilterOptions.Favorite) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.Favorite),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.All)
                  ])
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
