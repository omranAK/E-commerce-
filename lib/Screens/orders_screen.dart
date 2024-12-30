import 'package:flutter/material.dart';
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';
import '../Provider/orders_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  static const routename = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderdata = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.oreders,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<Orders>(context, listen: false).fetchingdata();
        },
        child: ListView.builder(
            itemCount: orderdata.length,
            itemBuilder: (ctx, i) => OrderItemWidget(orderdata[i])),
      ),
    );
  }
}
