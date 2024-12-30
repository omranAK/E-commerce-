// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:project_2/widgets/store_item.dart';

import '../Provider/store_provider.dart';
import '../Provider/stores_provider.dart';

// ignore: must_be_immutable
class StoresList extends StatefulWidget {
  String? location;
  StoresList({
    Key? key,
    required this.location,
  }) : super(key: key);
  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  @override
  Widget build(BuildContext context) {
    List<Store> stores = Provider.of<Stores>(context, listen: false).items;
    return widget.location == ''
        ? ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            itemCount: stores.length,
            itemBuilder: ((ctx, i) => ChangeNotifierProvider.value(
                  value: stores[i],
                  child: const StoreItem(),
                )),
          )
        : FutureBuilder(
            future: Provider.of<Stores>(context, listen: false)
                .findByLocation(widget.location!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((ctx, i) => ChangeNotifierProvider.value(
                        value: snapshot.data![i],
                        child: const StoreItem(),
                      )),
                );
              }
            },
          );
  }
}
