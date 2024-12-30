// ignore_for_file: body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../Provider/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FilterOption { arabic, english }

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'phone': '',
    'name': ''
  };
  var _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  void cleartext() {
    emailController.clear();
    nameController.clear();
    phoneController.clear();
    confirmpassController.clear();
    _passwordController.clear();
  }

  final _passwordController = TextEditingController();
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
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['name']!,
          _authData['email']!,
          _authData['password']!,
          _authData['phonenumber']!,
        );
      }
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
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double hieght = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(actions: [
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
      ]),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: width * 0.34,
                    height: hieght * 0.22,
                    child: const Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  _authMode == AuthMode.signup
                      ? Text(
                          localizations!.register,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : Text(
                          localizations!.login,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                  _authMode == AuthMode.signup
                      ? Text(
                          localizations.thanksforjoiningus,
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            decorationThickness: 1,
                          ),
                        )
                      : const SizedBox(
                          height: 20,
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
                          hintText: localizations.email),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return localizations.invalidemail;
                        }
                      },
                      onSaved: (newValue) {
                        _authData['email'] = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_authMode == AuthMode.signup)
                    SizedBox(
                      width: width * 0.8,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 15),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            hintText: localizations.nameHint),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return localizations.invalidname;
                          }
                        },
                        onSaved: (newValue) {
                          _authData['name'] = newValue!;
                        },
                      ),
                    ),
                  if (_authMode == AuthMode.signup)
                    const SizedBox(
                      height: 20,
                    ),
                  if (_authMode == AuthMode.signup)
                    SizedBox(
                      width: width * 0.8,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 15),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.black,
                            ),
                            hintText: localizations.phonenumber),
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length < 10 && value.length > 10) {
                            return localizations.invalidphone;
                          }
                        },
                        onSaved: (newValue) {
                          _authData['phonenumber'] = newValue!;
                        },
                      ),
                    ),
                  if (_authMode == AuthMode.signup)
                    const SizedBox(
                      height: 20,
                    ),
                  SizedBox(
                    width: width * 0.8,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
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
                        hintText: localizations.password,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return localizations.passwordistoshort;
                        }
                      },
                      onSaved: (newValue) {
                        _authData['password'] = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_authMode == AuthMode.signup)
                    SizedBox(
                      width: width * 0.8,
                      child: TextFormField(
                        controller: confirmpassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 15),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.check_outlined,
                            color: Colors.black,
                          ),
                          hintText: localizations.confirmpassword,
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return localizations.passwordsdontmatch;
                          }
                        },
                      ),
                    ),
                  if (_authMode == AuthMode.signup)
                    const SizedBox(
                      height: 25,
                    ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 113, 141, 255),
                        fixedSize: const Size(184, 41),
                      ),
                      onPressed: _submit,
                      child: Text(
                        _authMode == AuthMode.signup
                            ? localizations.signip
                            : localizations.login,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      _switchAuthMode();
                      cleartext();
                    },
                    child: Text(
                      _authMode == AuthMode.signup
                          ? localizations.alreadyhaveaccount
                          : '${localizations.donthaveaccountyet}${localizations.registernow}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 112, 139, 248),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/delivery_auth');
                      },
                      child: const Text("Singin as delivery account!!")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/tabs');
                      },
                      child: const Text("Singin as visitor")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
