import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/product_provider.dart';
import '../widgets/product_item.dart';

class SearchResult extends StatelessWidget {
  static const routename = '/search_product';
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) return const SizedBox.shrink();
    final arguments = route.settings.arguments as Map<String, Object>;
    final List<Product> searchresault = arguments['list'] as List<Product>;
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
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: searchresault.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: searchresault[i],
                      child: const ProductItem(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
