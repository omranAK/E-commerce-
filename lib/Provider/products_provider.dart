import 'package:flutter/material.dart';
import 'package:project_2/Provider/product_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:collection';
import '../server_config.dart';

class Products with ChangeNotifier {
  static const ip = Serverconfig.ip;
  // ignore: prefer_final_fields
  List<Product> _items = [];
  List<Product> _bestsales = [];
  List<Product> get bestsales {
    return [..._bestsales];
  }

  String? authtoken;
  Products(this.authtoken, this._items, this._bestsales);
  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> findByName(String name) {
    return _items
        .where((element) =>
            element.name!.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  List<Product> findByNamestore(String name, String id) {
    return _items
        .where((element) =>
            element.name!.toLowerCase().contains(name.toLowerCase()) &&
            element.companyid == id)
        .toList();
  }

  Future<void> fetchingdata() async {
    List<String> ides = [];
    const url1 = 'http://$ip:8000/api/markets_best_sales';
    http.Response response1 = await http.get(
      Uri.parse(url1),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authtoken',
        'Connection': 'Keep-Alive',
      },
    );
    final extracteddata = json.decode(response1.body);
    for (int i = 0; i < extracteddata.length; i++) {
      ides.add(
        extracteddata[i]['product']['id'].toString(),
      );
    }

    const url = 'http://$ip:8000/api/show_products';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authtoken',
        'Connection': 'Keep-Alive',
      },
    );

    final extracetdData = jsonDecode(response.body);

    Map<String, List<String>>? loadedcolorandsize = HashMap();
    List<Product> loadedproduct = [];

    List<Product> loadedbestsales = [];
    for (int i = 0; i < extracetdData.length; i++) {
      List<String> loadedimages = [];
      var image = extracetdData[i]['images'] as List;
      image.forEach((element) {
        loadedimages.add(element['image']);
      });

      List colorandsizelist = extracetdData[i]['colors_and_sizes'];
      for (int i = 0; i < colorandsizelist.length; i++) {
        List sizes = colorandsizelist[i]['sizes'];
        List<String> loadedsizes = [];
        for (int j = 0; j < sizes.length; j++) {
          loadedsizes.add(sizes[j]['size']);
        }
        loadedcolorandsize.putIfAbsent(
          colorandsizelist[i]['color']['color'],
          () => loadedsizes,
        );
      }
      Product product = Product(
        id: extracetdData[i]['product']['id'].toString(),
        name: extracetdData[i]['product']['name'],
        description: extracetdData[i]['product']['description'],
        price: extracetdData[i]['product']['price'],
        imageURL: loadedimages,
        colorandsize: loadedcolorandsize,
        rate: extracetdData[i]['product']['rate'],
        counter: extracetdData[i]['product']['counter'],
        companyid: extracetdData[i]['product']['owner_id'].toString(),
        companyname: extracetdData[i]['owner']['name'],
      );
      loadedproduct.add(product);
      if (ides.contains(product.id)) {
        loadedbestsales.add(product);
      }
    }
    _bestsales = loadedbestsales;
    _items = loadedproduct;
    notifyListeners();
  }

  Future<void> sendrate(double rate, String productId) async {
    final url = 'http://$ip:8000/api/add_rate/$productId/$rate';
    http.Response response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authtoken',
    });
    final url1 = 'http://$ip:8000/api/num_of_rates/$productId';
    await http.get(Uri.parse(url1), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authtoken',
    });
  }
}
