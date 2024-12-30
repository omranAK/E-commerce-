import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_2/Provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../server_config.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String companyname;
  final String companyid;
  final String productID;
  final num price;
  final int quantity;
  final String imageUrl;
  final String name;
  final String size;
  final String color;
  const CartItemWidget(
      this.id,
      this.companyname,
      this.companyid,
      this.price,
      this.quantity,
      this.imageUrl,
      this.name,
      this.color,
      this.size,
      this.productID,
      {super.key});

  @override
  Widget build(BuildContext context) {
    const ip = Serverconfig.ip;
    const host = '$ip:8000';
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeproduct(id);
      },
      key: ValueKey(id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LimitedBox(
              maxWidth: MediaQuery.sizeOf(context).width * 0.95,
              child: Container(
                height: 90,
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color(
                      0xFF576CBC,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                          'http://$host/$imageUrl',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Text(
                                'X$quantity',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'size: $size',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Text(
                                'color: $color',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                companyname,
                                style: GoogleFonts.robotoCondensed(
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Text('Total: ${price * quantity}')
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
