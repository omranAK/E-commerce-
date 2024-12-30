import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../server_config.dart';

class ProfileData with ChangeNotifier {
  final String? name;
  final String? email;
  final String? profileImage;
  final int? pocket;
  final String? phonnumber;

  ProfileData(
      {this.name, this.email, this.profileImage, this.pocket, this.phonnumber});
}

class Profile with ChangeNotifier {
  static const ip = Serverconfig.ip;
  List<ProfileData> _profile = [];
  String? _authtoken;
  String? _userId;
  Profile(this._authtoken, this._userId, this._profile);
  List<ProfileData> get profile {
    if (_profile.isNotEmpty) {
      return [..._profile];
    }
    return [
      ProfileData(
          email: null,
          name: null,
          phonnumber: null,
          pocket: null,
          profileImage: null)
    ];
  }

  Future<void> fetchingdata() async {
    final url = 'http://$ip:8000/api/auth/show/$_userId';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_authtoken',
      'Connection': 'Keep-Alive',
    });
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);
      final ProfileData profile = ProfileData(
          name: extractedData['0']['user']['name'],
          email: extractedData['0']['user']['email'],
          profileImage: extractedData['0']['user']['prof_img'],
          pocket: extractedData['0']['user']['wallet'] == null
              ? 0
              : extractedData['0']['user']['wallet']['wallet'],
          phonnumber: extractedData['0']['user']['phone']);
      final List<ProfileData> loadedprofile = [];
      loadedprofile.add(profile);
      _profile = loadedprofile;
      notifyListeners();
    } else {
      _profile = [];
      notifyListeners();
    }
  }

  Future<void> editprofile(Map<String, String> editedprofile) async {
    final url = 'http://$ip:8000/api/auth/update/$_userId';
    var request = http.MultipartRequest("POST", Uri.parse(url));
    //request.fields['name'] = editedprofile['name']!;
    request.headers['Accept'] = 'application/json';
    request.fields['name'] = editedprofile['name']!;
    request.fields['email'] = editedprofile['email']!;
    request.fields['phone'] = editedprofile['phone']!;
    request.fields['_method'] = 'patch';
    request.headers['Authorization'] = 'Bearer $_authtoken';
    request.headers['Connection'] = 'Keep-Alive';

    if (selectedimage != null) {
      var multipartfile =
          await http.MultipartFile.fromPath('prof_img', selectedimage!.path);
      request.files.add(multipartfile);
    }
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    print(result);
  }

  final _picker = ImagePicker();
  XFile? selectedimage;
  void pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedimage = image;
    notifyListeners();
  }
}
