import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Provider/products_provider.dart';
import '../Provider/product_provider.dart';
import '../Provider/cart_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Provider/auth_provider.dart';
import '../server_config.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routename = '/product_detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isauth = Provider.of<Auth>(context, listen: false).isauth;
    const ip = Serverconfig.ip;
    const host = '$ip:8000';
    // ignore: unused_local_variable
    String? value;
    int? selectedimage = 0;

    //moduleroute
    final route = ModalRoute.of(context);
    if (route == null) return const SizedBox.shrink();
    final productId = route.settings.arguments as String;

    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    Map<String, List<String>> loadedsizeandcolor = loadedProduct.colorandsize!;
    List<String> sizesforchoosencolor = [];
    //dropdown
    DropdownMenuItem<String> buildmenuitem(String item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 11),
          ),
        );
    return WillPopScope(
      onWillPop: () async {
        product.choosencolor = null;
        product.choosensize = null;
        product.number1 = 1;
        product.rateing = 0;
        product.rating1 = false;
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Consumer<Product>(
              builder: (context, value, child) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        'http://$host/${loadedProduct.imageURL![selectedimage!]}'),
                  ),
                ),
                height: MediaQuery.sizeOf(context).height * 0.35,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                          loadedProduct.imageURL!.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  Provider.of<Product>(context, listen: false)
                                      .choosimage(index);
                                  selectedimage = index;
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: selectedimage == index
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent),
                                  ),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        'http://$host/${loadedProduct.imageURL![index]}'),
                                  ),
                                ),
                              ))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: BackButton(
                onPressed: () {
                  product.choosencolor = null;
                  product.choosensize = null;
                  product.number1 = 1;
                  product.rateing = 0;
                  product.rating1 = false;
                  Navigator.pop(context);
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF708CF8),
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loadedProduct.name![0].toUpperCase() +
                                loadedProduct.name!.substring(1),
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 32,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${loadedProduct.price} ${AppLocalizations.of(context)!.sdollar}",
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Color(0xFF3114E3),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: Text(
                          loadedProduct.companyname!,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w200,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.aboutthisproduct,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.25,
                        child: Text(
                          loadedProduct.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (isauth)
                        Consumer<Product>(
                          builder: (context, value1, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 75,
                                height: 41,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color(0xFF576CBC),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: value1.choosencolor,
                                    padding: const EdgeInsets.only(left: 5),
                                    hint: Text(
                                      AppLocalizations.of(context)!.color,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    isExpanded: true,
                                    items: loadedsizeandcolor.keys
                                        .map(buildmenuitem)
                                        .toList(),
                                    onChanged: (value) => {
                                      Provider.of<Product>(context,
                                              listen: false)
                                          .chosecolor(
                                        value!,
                                      ),
                                      sizesforchoosencolor =
                                          loadedsizeandcolor[value]!,
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Provider.of<Product>(
                                        context,
                                        listen: false,
                                      ).decrement();
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.1,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.04,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            color: Color(0xFF708CF8),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: const Icon(Icons.remove),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${value1.number1}',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () => Provider.of<Product>(
                                      context,
                                      listen: false,
                                    ).increment(),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.1,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.04,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            color: Color(0xFF708CF8),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 75,
                                height: 41,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color(0xFF576CBC),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: value1.choosensize,
                                    padding: const EdgeInsets.only(left: 5),
                                    hint: Text(
                                      AppLocalizations.of(context)!.size,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    isExpanded: true,
                                    items: sizesforchoosencolor
                                        .map(buildmenuitem)
                                        .toList(),
                                    onChanged: (value) => {
                                      value = value,
                                      Provider.of<Product>(context,
                                              listen: false)
                                          .chosesize(value!)
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isauth)
                        Consumer<Product>(
                          builder: (context, value, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: RatingBar.builder(
                                  initialRating: value.rateing,
                                  itemSize: 30,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.blue,
                                    size: 11,
                                  ),
                                  onRatingUpdate: (rating) {
                                    Provider.of<Product>(context, listen: false)
                                        .enableraterate(rating);
                                  },
                                ),
                              ),
                              value.rating1
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .sendrate(value.rateing, productId)
                                            .then((e) => {
                                                  Provider.of<Product>(context,
                                                          listen: false)
                                                      .rateing = 0,
                                                  Provider.of<Product>(context,
                                                          listen: false)
                                                      .disablerate(),
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .thanksforrating),
                                                    ),
                                                  )
                                                });
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .sendrate),
                                    )
                                  : const Center()
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isauth)
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () {
                              cart.addItem(
                                  loadedProduct.id!,
                                  loadedProduct.price!,
                                  loadedProduct.name!,
                                  loadedProduct.imageURL![0],
                                  product.number1,
                                  product.choosencolor!,
                                  product.choosensize!,
                                  loadedProduct.companyname!,
                                  loadedProduct.companyid!);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: const Duration(
                                  seconds: 2,
                                ),
                                content: Text(
                                  AppLocalizations.of(context)!.addedproduct,
                                ),
                              ));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.addtocart,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
