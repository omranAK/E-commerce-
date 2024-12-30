// ignore_for_file: body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import '../Provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

enum FilterOption { arabic, english }

class DeliveryAuth extends StatefulWidget {
  static const routename = '/delivery_auth';
  const DeliveryAuth({super.key});

  @override
  State<DeliveryAuth> createState() => _DeliveryAuthState();
}

class _DeliveryAuthState extends State<DeliveryAuth> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final GlobalKey<FormState> _formKey = GlobalKey();
    final Map<String, String> _authData = {
      'email': '',
      'password': '',
      'phone': '',
      'name': ''
    };
    final loclaization = AppLocalizations.of(context);

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An Error Occurred!'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      setState(
        () {
          _isLoading = true;
        },
      );

      try {
        await Provider.of<Auth>(context, listen: false)
            .loginasdelivery(_authData['email']!, _authData['password']!)
            .then((value) {
          var roleid = Provider.of<Auth>(context, listen: false).roleid;
          if (roleid != null && roleid == '4') {
            Navigator.pushReplacementNamed(context, '/Delivery');
          } else {
            print('object');
            throw const HttpException('Not a delivery account');
          }
        });
        ;
      } on HttpException catch (error) {
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        } else if (error.toString().contains('Email or password incorrect!')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password.';
        } else if (error.toString().contains('Not a delivery account')) {
          errorMessage = 'Not a delivery account';
        }
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedlocal) {
                if (selectedlocal == FilterOption.arabic) {
                  Provider.of<Auth>(context, listen: false).changeLocal(
                    const Locale('ar', ''),
                  );
                } else {
                  Provider.of<Auth>(context, listen: false).changeLocal(
                    const Locale('en', ''),
                  );
                }
              },
              icon: const Icon(
                Icons.flag_circle_outlined,
                color: Colors.red,
                size: 30,
              ),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOption.arabic,
                      child: Text('🇸🇾'),
                    ),
                    const PopupMenuItem(
                      value: FilterOption.english,
                      child: Text('🇬🇧'),
                    )
                  ]),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.34,
                height: MediaQuery.sizeOf(context).height * 0.22,
                child: const Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: loclaization!.email,
                    contentPadding: const EdgeInsets.only(top: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return loclaization.invalidemail;
                    }
                  },
                  onSaved: (newValue) {
                    _authData['email'] = newValue!;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: loclaization.password,
                    contentPadding: const EdgeInsets.only(top: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Colors.black,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return loclaization.passwordistoshort;
                    }
                  },
                  onSaved: (newValue) {
                    _authData['password'] = newValue!;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 113, 141, 255),
                    fixedSize: const Size(184, 41),
                  ),
                  onPressed: _submit,
                  child: Text(
                    loclaization.login,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
