import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  final String name;
  final String ownername;
  final String id;
  final String phonenumber;
  final String? imagURL;
  final String catogries;
  final String location;

  Store({
    required this.name,
    required this.ownername,
    required this.id,
    required this.phonenumber,
    this.imagURL,
    required this.catogries,
    required this.location,
  });
}
