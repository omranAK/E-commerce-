import 'dart:collection';
import 'dart:convert';
import '../server_config.dart';
import 'package:flutter/material.dart';
import 'package:project_2/Provider/product_provider.dart';
import './store_provider.dart';
import 'package:http/http.dart' as http;

class Stores with ChangeNotifier {
  static const ip = Serverconfig.ip;
  List<Store> _items = [];

  String? authtoken;

  Stores(this.authtoken, this._items, this._locations);
  Map<int, String> _locations = HashMap();
  String? choosenlocation;
  void chooslocation(String location) {
    choosenlocation = location;
    notifyListeners();
  }

  Map<int, String> get locations {
    return {..._locations};
  }

  List<Store> get items {
    return [..._items];
  }

  Future<List<Store>> findByLocation(String location) async {
    if (location == 'All') return _items;
    int? locationid;
    locations.forEach((key, value) {
      if (value == location) {
        locationid = key;
      }
    });
    final url = 'http://$ip:8000/api/filter_area_markets/$locationid';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    final extractedData = json.decode(response.body) as List;
    List<Store> loadedStore = [];

    for (int i = 0; i < extractedData.length; i++) {
      loadedStore.add(
        _items.firstWhere(
          (element) => element.id == extractedData[i][0]['id'].toString(),
        ),
      );
    }
    return loadedStore;
  }

  Store findById(String id) {
    return _items.firstWhere((store) => store.id == id);
  }

  List<Store> findByName(String name) {
    return _items
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<List<Product>> fetchingproducts(String id) async {
    final url = 'http://$ip:8000/api/show_market_products/$id';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    final extractedData = json.decode(response.body);
    Map<String, List<String>>? loadedcolorandsize = HashMap();
    List<Product> loadedproduct = [];

    for (int i = 0; i < extractedData.length; i++) {
      List<String> loadedimages = [];
      var image = extractedData[i]['images'] as List;
      image.forEach((element) {
        loadedimages.add(element['image']);
      });

      List colorandsizelist = extractedData[i]['colors_and_sizes'];
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
        id: extractedData[i]['product']['id'].toString(),
        name: extractedData[i]['product']['name'],
        description: extractedData[i]['product']['description'],
        price: extractedData[i]['product']['price'],
        imageURL: loadedimages,
        colorandsize: loadedcolorandsize,
        rate: extractedData[i]['product']['rate'],
        counter: extractedData[i]['product']['counter'],
        companyid: extractedData[i]['product']['owner_id'].toString(),
        companyname: extractedData[i]['owner']['name'],
      );
      loadedproduct.add(product);
    }
    return loadedproduct;
  }

  Future<void> fetchingData() async {
    const url = 'http://$ip:8000/api/get_areas';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
    );
    final extracteddata = json.decode(response.body) as List;
    final Map<int, String> locations = HashMap();
    locations.putIfAbsent(0, () => 'All');
    extracteddata.forEach((element) {
      locations.putIfAbsent(
          element['area']['id'], () => element['area']['area']);
      // locations.add(element['area']['area']);
    });
    _locations = locations;
    notifyListeners();
    const url1 = 'http://$ip:8000/api/show_markets';
    http.Response response1 = await http.get(Uri.parse(url1), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authtoken',
      'Connection': 'Keep-Alive',
    });

    final extractedData = json.decode(response1.body) as Map;
    List<Store> loadedStore = [];
    final extractedlist = extractedData['0'] as List;
    for (int i = 0; i < extractedlist.length; i++) {
      final location = locations[extractedlist[i]['user_extra']['area_id']];

      loadedStore.add(
        Store(
          name: extractedlist[i]['user']['name'],
          ownername: extractedlist[i]['user_extra']['owner'],
          id: extractedlist[i]['user']['id'].toString(),
          phonenumber: extractedlist[i]['user']['phone'],
          imagURL: extractedlist[i]['user']['prof_img'],
          catogries: extractedlist[i]['user_extra']['p_type'],
          location: location!,
        ),
      );
    }

    _items = loadedStore;
    notifyListeners();
  }
}
