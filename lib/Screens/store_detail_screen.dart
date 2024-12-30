import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/drawer.dart';
import '../Provider/stores_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/store_product_grid.dart';
import '../Provider/product_provider.dart';
import '../Provider/products_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../server_config.dart';

class StoreDetailScreen extends StatelessWidget {
  static const routename = '/store_detail';
  const StoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? value;
    const ip = Serverconfig.ip;
    const host = '$ip:8000';
    final route = ModalRoute.of(context);
    if (route == null) return const SizedBox.shrink();
    final storeId = route.settings.arguments as String;
    final loadedStore =
        Provider.of<Stores>(context, listen: false).findById(storeId);
    final TextEditingController textEditingController = TextEditingController();
    void clearText() {
      textEditingController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.1,
        title: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          width: 230,
          height: 28,
          child: TextFormField(
            controller: textEditingController,
            onFieldSubmitted: (newValue) {
              value = newValue;
              final List<Product> searchresult =
                  Provider.of<Products>(context, listen: false)
                      .findByNamestore(newValue, storeId);
              Navigator.of(context).pushNamed(
                '/search_product',
                arguments: {
                  'list': searchresult,
                  'value': newValue,
                },
              );
              clearText();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(7),
              hintTextDirection: TextDirection.ltr,
              border: InputBorder.none,
              prefixIcon: IconButton(
                padding: const EdgeInsets.all(-15),
                onPressed: () {
                  final List<Product> searchresult =
                      Provider.of<Products>(context, listen: false)
                          .findByName(value!);
                  Navigator.of(context).pushNamed(
                    '/search_product',
                    arguments: {
                      'list': searchresult,
                      'value': value,
                    },
                  );
                  clearText();
                },
                icon: const Icon(Icons.search, color: Colors.black),
              ),
              hintText: AppLocalizations.of(context)!.searchforproduct,
              hintStyle: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 19.0, right: 19.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.25,
                  child: Image(
                    fit: BoxFit.contain,
                    image: CachedNetworkImageProvider(
                        'http://$host/${loadedStore.imagURL}'),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context)!.products,
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              StoreProductsGrid(
                id: storeId,
              )
            ],
          ),
        ),
      ),
    );
  }
}
