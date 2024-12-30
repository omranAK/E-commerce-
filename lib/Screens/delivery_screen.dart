import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project_2/widgets/delivery_order_widget.dart';
import '../Provider/orders_provider.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';

class Delivery extends StatelessWidget {
  static const routename = '/Delivery';
  const Delivery({super.key});

  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<Orders>(context).delivery;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 125, 160),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
              child: const Text('logout'))
        ],
        title: Text(
          AppLocalizations.of(context)!.oreders,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Orders>(context, listen: false).fetchdeliverydate(),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (ctx, i) => DeliveryOrderItemWidget(
            order: orders[i],
          ),
        ),
      ),
    );
  }
}
