import 'package:flutter/material.dart';
import 'package:project_2/Provider/orders_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DeliveryOrderItemWidget extends StatefulWidget {
  final DeliveryModel order;

  const DeliveryOrderItemWidget({super.key, required this.order});

  @override
  // ignore: library_private_types_in_public_api
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<DeliveryOrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(localization!.areyousure),
                      actions: [
                        ElevatedButton(
                          child: Text(localization.no),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                        ElevatedButton(
                            child: Text(localization.yes),
                            onPressed: () async {
                              await Provider.of<Orders>(context, listen: false)
                                  .isdeliverd(widget.order.id!)
                                  .then((value) => {
                                        Provider.of<Orders>(context,
                                                listen: false)
                                            .fetchdeliverydate(),
                                        Navigator.of(ctx).pop(true)
                                      });
                            }),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.check)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${widget.order.total}${AppLocalizations.of(context)!.sdollar}'),
                Text('${widget.order.phonenumber}'),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From : ${widget.order.marketname}'),
                SizedBox(
                  width: 100,
                  child: Text(
                    'To: ${widget.order.location}',
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
