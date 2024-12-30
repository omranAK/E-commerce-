import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:project_2/Provider/products_provider.dart';
import '../Provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../server_config.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    const ip = Serverconfig.ip;
    const host = '$ip:8000';

    final product = Provider.of<Product>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_detail',
          arguments: product.id,
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.38,
        height: MediaQuery.sizeOf(context).height * 0.35,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color(
              0xFFBCEFF6,
            ),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: product.imageURL != null
                              ? CachedNetworkImageProvider(
                                  'http://$host/${product.imageURL![0]}',
                                )
                              : const AssetImage(
                                      'asset/images/productholedr.png')
                                  as ImageProvider),
                    ),
                    width: double.infinity,
                    height: 99,
                  ),
                ),
                product.colorandsize!.isNotEmpty
                    ? const Center()
                    : Center(
                        child: Container(
                          width: 62,
                          height: 21,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFF0000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.outofstok,
                                style: GoogleFonts.robotoCondensed(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            const Divider(
              color: Color(0x7F3E69FF),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: Text(
                      product.name![0].toUpperCase() +
                          product.name!.substring(1),
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${product.price} ${AppLocalizations.of(context)!.sdollar}',
                            style: const TextStyle(
                              color: Color(0xFF3114E3),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${product.rate}',
                            style: const TextStyle(color: Color(0xFF3114E3)),
                          ),
                          const Icon(
                            Icons.star,
                            color: Color(0xFF3114E3),
                            size: 13,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
