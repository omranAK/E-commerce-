import 'dart:io';
import 'package:flutter/material.dart';
import '../Provider/order_provider.dart';
import './cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../server_config.dart';

class DeliveryModel {
  String? id;
  num? total;
  bool? isdeliverd;
  String? name;
  String? phonenumber;
  String? location;
  String? marketname;

  DeliveryModel({
    this.id,
    this.total,
    this.isdeliverd,
    this.name,
    this.phonenumber,
    this.location,
    this.marketname,
  });
}

class Orders with ChangeNotifier {
  static const ip = Serverconfig.ip;
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  List<DeliveryModel> _items = [];
  List<DeliveryModel> get delivery {
    return [..._items];
  }

  Map<String, DeliveryModel> _deliveryorders = {};
  Map<String, DeliveryModel> get deliveryorders {
    return {..._deliveryorders};
  }
  // void addorder(List<CartItem> cartproducts, double total) {
  //   _orders.insert(
  //     0,
  //     Order(
  //       id: DateTime.now().toString(),
  //       products: cartproducts,
  //       ammount: total,
  //       dateTime: DateTime.now(),
  //     ),
  //   );
  //   notifyListeners();
  // }

  final String? authToken;
  final String? userId;
  Orders(this.authToken, this._orders, this.userId);

  Future<void> addorder(List<CartItem> cartproducts, String location) async {
    const url = 'http://$ip:8000/api/order';
    final orederitem = jsonEncode(
      cartproducts
          .map((e) => {
                'id_p': e.productId,
                'size': e.size,
                'color': e.color,
                'quant': e.quantity
              })
          .toList(),
    );
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: {
        'location': location,
        'orderItems': orederitem,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
    } else {
      throw const HttpException('you don\'t have enough mony');
    }
  }

  // }
  Future<void> fetchingdata() async {
    const url = 'http://$ip:8000/api/show_my_orders';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
      'Connection': 'Keep-Alive',
    });
    final extracteddata = json.decode(response.body);
    final List<Order> loadedOrders = [];
    if (response.statusCode == 200) {
      var extractedorders = extracteddata['Order&Books']['ordersItem'] as List;

      for (int i = 0; i < extractedorders.length; i++) {
        final list = extractedorders[i] as List;

        if (list.length != 1) {
          double tot = 0;
          List<CartItem> list1 = [];
          for (int j = 0; j < list.length; j++) {
            tot += (list[j]['product']['price'] * list[j]['quant']);
            list1.add(
              CartItem(
                id: list[j]['order_id'].toString(),
                productId: list[j]['product_id'].toString(),
                name: list[j]['product']['name'],
                quantity: list[j]['quant'],
                price: list[j]['product']['price'],
                size: list[j]['size'],
                color: list[j]['color'],
              ),
            );
          }
          loadedOrders.add(Order(
              id: list[0]['order_id'].toString(),
              products: list1,
              ammount: tot,
              dateTime: DateTime.parse(list[0]['created_at'])));
        } else {
          double tot = 0;
          tot += (list[0]['product']['price'] * list[0]['quant']);
          List<CartItem> list1 = [];
          list1.add(
            CartItem(
              id: list[0]['order_id'].toString(),
              productId: list[0]['product_id'].toString(),
              name: list[0]['product']['name'],
              quantity: list[0]['quant'],
              price: list[0]['product']['price'],
              size: list[0]['size'],
              color: list[0]['color'],
            ),
          );
          loadedOrders.add(
            Order(
              id: list[0]['order_id'].toString(),
              products: list1,
              ammount: tot,
              dateTime: DateTime.parse(
                list[0]['created_at'],
              ),
            ),
          );
        }
      }

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } else {
      _orders = [];
      notifyListeners();
    }
  }

  Future<void> fetchdeliverydate() async {
    print(userId);
    const url = 'http://$ip:8000/api/show_orders';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
      'Connection': 'Keep-Alive',
    });
    final responseData = json.decode(response.body);

    final list2 = responseData["0"]["orderItems"] as List;
    final list = responseData["0"]["orders"] as List;
    print(list);
    for (int i = 0; i < list.length; i++) {
      if (list[i]["isDelivered"] == null) {
        _deliveryorders[list[i]["id"].toString()] = DeliveryModel(
          id: list[i]["id"].toString(),
          name: list[i]["user"]["name"],
          total: list[i]["total_price"],
          location: list[i]["location"],
          phonenumber: list[i]["user"]["phone"],
        );
      }
    }

    for (int i = 0; i < list2.length; i++) {
      if (_deliveryorders.keys.contains(list2[i]["order_id"].toString())) {
        _deliveryorders.update(
          list2[i]["order_id"].toString(),
          (value) => DeliveryModel(
            id: value.id,
            total: value.total,
            name: value.name,
            phonenumber: value.phonenumber,
            location: value.location,
            marketname: list2[i]["market"]["name"],
          ),
        );
      }
    }
    _items = _deliveryorders.values.toList();
    notifyListeners();
  }

  Future<void> isdeliverd(String id) async {
    final url = 'http://$ip:8000/api/isDelivered/$id';
    // ignore: unused_local_variable
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    _deliveryorders.remove(id);
    notifyListeners();
  }
}
