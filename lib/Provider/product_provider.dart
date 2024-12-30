import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? name;
  final String? description;
  final num? price;
  final List<String>? imageURL;
  Map<String, List<String>>? colorandsize;
  final num? rate;
  final int? counter;
  final String? companyname;
  final String? companyid;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageURL,
    this.colorandsize,
    this.rate,
    this.counter,
    this.companyname,
    this.companyid,
  });

  String? choosencolor;
  String? choosensize;
  int number1 = 1;
  int choosenimage = 0;
  int get number => number1;
  double rateing = 0;
  bool rating1 = false;

  void increment() {
    number1++;
    notifyListeners();
  }

  void decrement() {
    if (number1 > 1) {
      number1--;
    }

    notifyListeners();
  }

  void chosecolor(String color) {
    choosencolor = color;
    notifyListeners();
  }

  void choosimage(int number) {
    choosenimage = number;
    notifyListeners();
  }

  void chosesize(String size) {
    choosensize = size;
    notifyListeners();
  }

  void enableraterate(double rate) {
    rateing = rate;
    rating1 = true;
    notifyListeners();
  }

  void disablerate() {
    rating1 = false;
    notifyListeners();
  }
}
