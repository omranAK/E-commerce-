import 'package:flutter/material.dart';
import '../Provider/auth_provider.dart';
import '../Provider/cart_provider.dart';
import '../Provider/product_provider.dart';
import '../Provider/products_provider.dart';
import '../Screens/splash_screen2.dart';
import './Screens/orders_screen.dart';
import '../Screens/product_detail_screen.dart';
import '../Screens/tab_screen.dart';
import './Provider/stores_provider.dart';
import 'package:provider/provider.dart';
import './Screens/store_detail_screen.dart';
import './Provider/orders_provider.dart';
import './Screens/splash_screen.dart';
import './Screens/found_product_screen.dart';
import './Screens/auth_screen.dart';
import './Screens/found_Store_screen.dart';
import './Provider/profile_provider.dart';
import './Screens/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './Screens/delivery_auth_screen.dart';
import './Screens/delivery_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, [], []),
          update: (ctx, auth, previous) => Products(
            auth.token,
            previous == null ? [] : previous.items,
            previous == null ? [] : previous.bestsales,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Stores>(
          create: (ctx) => Stores(null, [], {}),
          update: (ctx, auth, previous) => Stores(
              auth.token,
              previous == null ? [] : previous.items,
              previous == null ? {} : previous.locations),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Product(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null, [], null),
          update: (ctx, auth, previous) => Orders(
            auth.token,
            previous == null ? [] : previous.orders,
            auth.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Profile>(
            create: (context) => Profile(null, null, []),
            update: (context, auth, previous) => Profile(auth.token,
                auth.userId, previous == null ? [] : previous.profile))
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoCondensed',
              ),
              bodySmall: TextStyle(
                  fontSize: 12,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.w100),
            ),
            primaryColor: const Color(0xFF708CF8),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: auth.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          home: auth.isauth ? const SplashScreen() : const AuthScreen(),
          routes: {
            ProductDetailScreen.routename: (ctx) => const ProductDetailScreen(),
            StoreDetailScreen.routename: (ctx) => const StoreDetailScreen(),
            Tabs.routename: (ctx) => const Tabs(),
            OrdersScreen.routename: (ctx) => const OrdersScreen(),
            SearchResult.routename: (ctx) => const SearchResult(),
            SearchResultStore.routename: (ctx) => const SearchResultStore(),
            ProfileScreen.routename: (ctx) => const ProfileScreen(),
            DeliveryAuth.routename: (ctx) => const DeliveryAuth(),
            Delivery.routename: (ctx) => const Delivery()
          },
        ),
      ),
    );
  }
}
