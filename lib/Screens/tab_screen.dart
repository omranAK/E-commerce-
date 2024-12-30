import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:project_2/Provider/stores_provider.dart';
import 'package:provider/provider.dart';
import '../Screens/home_screen.dart';
import '../Screens/stores_list_screen.dart';
import '../Screens/cart_screen.dart';
import '../Provider/products_provider.dart';
import '../Provider/profile_provider.dart';
import '../Provider/orders_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tabs extends StatefulWidget {
  static const routename = '/tabs';
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context, listen: false).fetchingdata();
      Provider.of<Stores>(context, listen: false).fetchingData();
      Provider.of<Profile>(context, listen: false).fetchingdata();
      Provider.of<Orders>(context, listen: false).fetchingdata();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int selectedIndex = 0;
  final screens = [
    const Home(),
    const StoresScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: GNav(
        onTabChange: (value) {
          setState(
            () {
              selectedIndex = value;
            },
          );
        },
        activeColor: const Color.fromARGB(255, 46, 196, 237),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        padding: const EdgeInsets.only(bottom: 8),
        tabs: [
          GButton(
            text: AppLocalizations.of(context)!.home,
            iconSize: 28,
            icon: Icons.home_outlined,
          ),
          GButton(
            text: AppLocalizations.of(context)!.stores,
            iconSize: 28,
            icon: Icons.store_mall_directory_outlined,
          ),
          GButton(
            text: AppLocalizations.of(context)!.mycart,
            iconSize: 28,
            icon: Icons.shopping_cart_outlined,
          )
        ],
      ),
    );
  }
}
