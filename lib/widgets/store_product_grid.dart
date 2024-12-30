import 'package:flutter/material.dart';
import '../Provider/stores_provider.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class StoreProductsGrid extends StatelessWidget {
  String? id;
  StoreProductsGrid({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Stores>(context, listen: false).fetchingproducts(id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data != null) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: snapshot.data![i],
                child: const ProductItem(),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            );
          } else {
            return const Center(
              child: Text('No Product yet!!!!'),
            );
          }
        }
      },
    );
  }
}
