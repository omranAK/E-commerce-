// ignore_for_file: body_might_complete_normally_nullable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2/Provider/orders_provider.dart';
import '../Provider/cart_provider.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    String? location;
    final GlobalKey<FormState> formKey = GlobalKey();
    final TextEditingController locationcontroller = TextEditingController();
    final cart = Provider.of<Cart>(context);

    void showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.red,
          title: Text(localization!.anerroraccurred),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text(localization.okay),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: const [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/logo.png'),
          )
        ],
        centerTitle: true,
        title: Text(localization!.mycart,
            style: GoogleFonts.robotoCondensed(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: locationcontroller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.place,
                      color: Colors.black,
                    ),
                    hintText: localization.enteryourlocationplease,
                  ),
                  onSaved: (newValue) {
                    location = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return localization.invalidlocation;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemWidget(
                  cart.items[index].id,
                  cart.items[index].companyname!,
                  cart.items[index].companyid!,
                  cart.items[index].price,
                  cart.items[index].quantity,
                  cart.items[index].imageUrl!,
                  cart.items[index].name,
                  cart.items[index].color,
                  cart.items[index].size,
                  cart.items[index].productId),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.sizeOf(context).width * 0.9,
                height: MediaQuery.sizeOf(context).height * 0.17,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.subtotal,
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Text(
                              "${cart.totalAmount}${localization.sdollar}",
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.shipping,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Text(
                              "${cart.totalAmount * 0.03}${localization.sdollar}",
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localization.total,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Text(
                              "${cart.totalAmount + cart.totalAmount * 0.03}${localization.sdollar}",
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor),
        onPressed: () {
          if (!formKey.currentState!.validate()) {
            return;
          }
          formKey.currentState!.save();
          cart.items.isEmpty
              ? {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(
                        seconds: 2,
                      ),
                      content: Text(
                        localization.yourcartisempty,
                      ),
                    ),
                  )
                }
              : showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(localization.confirmtheorder),
                    content: Text(localization.doyouwanttoconfirmtheorder),
                    actions: [
                      ElevatedButton(
                        child: Text(localization.no),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      ElevatedButton(
                        child: Text(localization.yes),
                        onPressed: () async {
                          try {
                            await Provider.of<Orders>(context, listen: false)
                                .addorder(cart.items, location!)
                                .then((value) {
                              Provider.of<Cart>(context, listen: false).clear();
                              Navigator.of(ctx).pop(true);
                            });
                            // ignore: unused_catch_clause
                          } on HttpException catch (e) {
                            var errorMessage =
                                localization.sorryyoudaonthaveenoughmony;
                            showErrorDialog(errorMessage);
                          }
                        },
                      ),
                    ],
                  ),
                );
        },
        child: Text(
          localization.confirmtheorder,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
