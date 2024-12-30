import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../server_config.dart';

class Auth with ChangeNotifier {
  static const ip = Serverconfig.ip;
  String? _token;
  String? userId;
  Locale? _locale;
  String? _roleId;
  Locale? get locale {
    return _locale;
  }

  void changeLocal(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  bool get isauth {
    if (_roleId == '3') {
      return token != null;
    } else {
      return false;
    }
  }

  String? get roleid {
    return _roleId;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(
      String name, String email, String password, String phone) async {
    const url = 'http://$ip:8000/api/auth/sign-up/client';
    http.Response response = await http.post(
      Uri.parse(url),
      body: ({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData["0"]['access_token'];
      userId = responseData["0"]['user']['id'].toString();

      notifyListeners();
    } else {
      throw const HttpException('Email_Exists');
    }
  }

  Future<void> login(String email, String password) async {
    const url = 'http://$ip:8000/api/auth/login';
    http.Response response = await http.post(Uri.parse(url),
        body: ({
          'email': email,
          'password': password,
        }),
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      _token = responseData["0"]['access_token'];
      userId = responseData["0"]['user']['id'].toString();
      _roleId = responseData["0"]["user"]["role_id"].toString();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final usetData =
          json.encode({'token': _token, 'userId': userId, 'roleId': _roleId});
      prefs.setString('userData', usetData);
    } else {
      throw const HttpException('Email or password incorrect!');
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData')!);
    _token = extractedData['token'];
    userId = extractedData['userId'];
    _roleId = extractedData['roleId'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    const url = 'http://$ip:8000/api/auth/logout';
    await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });

    _token = null;
    userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  Future<void> loginasdelivery(String email, String password) async {
    const url = 'http://$ip:8000/api/auth/login';
    http.Response response = await http.post(Uri.parse(url),
        body: ({
          'email': email,
          'password': password,
        }),
        headers: {
          'Accept': 'application/json',
        });
    final extractedData = json.decode(response.body);
    _token = extractedData["0"]["access_token"];
    userId = extractedData["0"]['user']['id'].toString();
    _roleId = extractedData["0"]["user"]["role_id"].toString();
    notifyListeners();
  }
}
