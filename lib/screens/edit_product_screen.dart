import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageurlFocusNode = FocusNode();
  final _form =
      GlobalKey<FormState>(); // untuk menghubungkan dengan widget form
  var _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  @override
  void initState() {
    _imageurlFocusNode
        .addListener(_updateImageUrl); // setiap kali image keluar dari focus
    super.initState();
  }

  void dispose() {
    // untuk memastikan memori yang digunakan focusNode untuk dihapus
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageurlFocusNode.dispose();
    _imageurlFocusNode.removeListener(_updateImageUrl);
    super
        .dispose(); // super keyword is used to refer immediate parent class object.
  }

  void _updateImageUrl() {
    if (!_imageurlFocusNode.hasFocus) {
      // jika image url keluar dari focus input maka rebuild ulang
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!
        .validate(); // akan memicu semua validator dan akan mengembalikan true jika semua validator return tidak ada kesalahan input (null), dan akan return false jika terjadi kesalahan pada validator form input yng telah diterapkan
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print(_editProduct.title);
    print(_editProduct.description);
    print(_editProduct.price);
    print(_editProduct.imageUrl);
    Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    Navigator.of(context).pop(); // kembali ke halaman sebelumnya
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form, // untuk menghubungkan dengan widget form
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction
                      .next, // yang artinya ketika pada keyboard HP diklik return maka akan ke input selanjutnya bukan mengirimkan data
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      // jika tidak valid
                      return 'Please provide a value';
                    }

                    return null; // jika valid
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: value,
                        description: _editProduct.description,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zeor';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: _editProduct.title,
                        description: _editProduct.description,
                        price: double.parse(value!),
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 character long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: _editProduct.title,
                        description: value,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageurlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valida URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: null,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: value);
                        },
                      ),
                    )
                  ],
                ) // dimulti line tidak bisa menggunakan focusNode karena return disini pada keyboard digunakan untuk enter bari baru.
              ],
            )),
      ),
    );
  }
}
