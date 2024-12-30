import 'package:flutter/material.dart';
import '../Provider/store_provider.dart';
import 'package:provider/provider.dart';
import '../server_config.dart';

class StoreItem extends StatefulWidget {
  const StoreItem({super.key});

  @override
  State<StoreItem> createState() => _StoreItemState();
}

class _StoreItemState extends State<StoreItem> {
  @override
  Widget build(BuildContext context) {
    const ip = Serverconfig.ip;
    const host = '$ip:8000';
    final store = Provider.of<Store>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/store_detail',
          arguments: store.id,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            LimitedBox(
              maxWidth: MediaQuery.sizeOf(context).width * 0.95,
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.09,
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
                          image: NetworkImage('http://$host/${store.imagURL}'),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              store.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                color: Colors.black45,
                                size: 18,
                              ),
                              Text(store.location,
                                  style: const TextStyle(fontSize: 16))
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.black45,
                                size: 18,
                              ),
                              Text(store.catogries)
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
