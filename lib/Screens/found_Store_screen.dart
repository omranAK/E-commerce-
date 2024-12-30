import 'package:flutter/material.dart';
import '../widgets/store_item.dart';
import 'package:provider/provider.dart';
import '../Provider/store_provider.dart';

class SearchResultStore extends StatelessWidget {
  static const routename = '/search_store';
  const SearchResultStore({super.key});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) return const SizedBox.shrink();
    final arguments = route.settings.arguments as Map<String, Object>;
    final List<Store> searchresault = arguments['list'] as List<Store>;
    final String searchvalue = arguments['value'] as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search results.."$searchvalue"',
          style: const TextStyle(fontSize: 24),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            searchresault.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search,
                          size: 100,
                          color: Colors.black45,
                        ),
                        Text(
                          " Sorry No resault match your search!!!!! ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.vertical,
                    itemCount: searchresault.length,
                    itemBuilder: ((ctx, i) => ChangeNotifierProvider.value(
                          value: searchresault[i],
                          child: const StoreItem(),
                        )),
                  )
          ],
        ),
      ),
    );
  }
}
