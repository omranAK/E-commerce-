import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2/Provider/products_provider.dart';
import 'package:project_2/widgets/products_grid.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';
import '../widgets/product_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  static const routename = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var isInit = true;
  var isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchingdata()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    final localization = AppLocalizations.of(context);
    String? value;
    List<Product> bestsaleslist = Provider.of<Products>(context).bestsales;
    final TextEditingController textEditingController = TextEditingController();
    void clearText() {
      textEditingController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.1,
        title: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.sizeOf(context).width * 0.60,
          height: MediaQuery.sizeOf(context).height * 0.041,
          child: TextFormField(
            controller: textEditingController,
            onFieldSubmitted: (newValue) {
              value = newValue;
              final List<Product> searchresult =
                  Provider.of<Products>(context, listen: false)
                      .findByName(newValue);
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
              hintText: localization!.searchforproduct,
              hintStyle: const TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
        actions: const [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/logo.png'),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      localization.topsales,
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white54),
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                              value: bestsaleslist[i],
                              child: const ProductItem()),
                          itemCount: bestsaleslist.length,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      localization.explore,
                      style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const ProductsGrid()
                ],
              ),
            ),
    );
  }
}
