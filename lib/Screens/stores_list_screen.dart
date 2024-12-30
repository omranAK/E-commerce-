import 'package:flutter/material.dart';
import 'package:project_2/Provider/stores_provider.dart';
import '../Provider/store_provider.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/stores_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    void clearText() {
      textEditingController.clear();
    }

    final localization = AppLocalizations.of(context);
    String? value;
    final locations = Provider.of<Stores>(context).locations;
    List<String> list = [];

    locations.forEach(
      (key, value) => list.add(value),
    );
    return Scaffold(
        appBar: AppBar(
          actions: const [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                'assets/images/logo.png',
              ),
            )
          ],
          toolbarHeight: MediaQuery.sizeOf(context).height * 0.1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization!.shopsin,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Consumer<Stores>(
                builder: (ctx, value, child) => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value.choosenlocation,
                    padding: const EdgeInsets.only(left: 5),
                    hint: Text(
                      localization.chooseone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => {
                      Provider.of<Stores>(context, listen: false)
                          .chooslocation(value!),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
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
                        final List<Store> searchresult =
                            Provider.of<Stores>(context, listen: false)
                                .findByName(newValue);
                        Navigator.of(context).pushNamed(
                          '/search_store',
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
                            final List<Store> searchresult =
                                Provider.of<Stores>(context, listen: false)
                                    .findByName(value!);
                            Navigator.of(context).pushNamed(
                              '/search_store',
                              arguments: {
                                'list': searchresult,
                                'value': value,
                              },
                            );
                            clearText();
                          },
                          icon: const Icon(Icons.search, color: Colors.black),
                        ),
                        hintText: localization.searchforstore,
                        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
              RefreshIndicator(
                onRefresh: () =>
                    Provider.of<Stores>(context, listen: false).fetchingData(),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.73,
                  child: Consumer<Stores>(builder: (context, value, child) {
                    return StoresList(
                      location: value.choosenlocation != null
                          ? value.choosenlocation!
                          : '',
                    );
                  }),
                ),
              ),
            ],
          ),
        ));
  }
}
