import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String productId;
  final String? companyname;
  final String? companyid;
  final String name;
  final int quantity;
  final num price;
  final String? imageUrl;
  final String size;
  final String color;

  CartItem(
      {required this.id,
      required this.productId,
      this.companyname,
      this.companyid,
      required this.name,
      required this.quantity,
      required this.price,
      this.imageUrl,
      required this.size,
      required this.color});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    for (int i = 0; i < _items.length; i++) {
      total += _items[i].price * _items[i].quantity;
    }
    return total;
  }

  void addItem(
      String productId,
      num price,
      String name,
      String imageUrl,
      int quantity,
      String color,
      String size,
      String companyname,
      String companyid) {
    if (_items.any((element) => element.size == size) &&
        _items.any((element) => element.color == color)) {
      int index =
          _items.indexWhere((element) => element.productId == productId);
      String id = _items[index].id;
      int quanti = _items[index].quantity;
      _items[index] = CartItem(
          id: id,
          productId: productId,
          companyname: companyname,
          companyid: companyid,
          name: name,
          quantity: quanti + quantity,
          price: price,
          imageUrl: imageUrl,
          size: size,
          color: color);
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          name: name,
          companyname: companyname,
          companyid: companyid,
          quantity: quantity,
          price: price,
          imageUrl: imageUrl,
          color: color,
          size: size,
        ),
      );

      notifyListeners();
    }
  }

  void removeproduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  // void removeSingleItem(int productid, int number) {
  //   var f = _items[productid];

  //   if (!_items.containsKey(productid)) {
  //     return;
  //   } else if (f != null) {
  //     if (f.quantity > 1) {
  //       _items.update(
  //         productid,
  //         (existingCartItem) => CartItem(
  //           id: existingCartItem.id,
  //           companyname: existingCartItem.companyname,
  //           companyid: existingCartItem.companyid,
  //           name: existingCartItem.name,
  //           quantity: existingCartItem.quantity - number,
  //           price: existingCartItem.price,
  //           imageUrl: existingCartItem.imageUrl,
  //           color: existingCartItem.color,
  //           size: existingCartItem.size,
  //         ),
  //       );
  //     } else {
  //       _items.remove(productid);
  //     }
  //   }
  //   notifyListeners();
  // }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
