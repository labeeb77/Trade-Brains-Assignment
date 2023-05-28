import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:trade_brains/controller/provider.dart';

import 'package:trade_brains/view/widget/search_debouncer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ProviderScreen>(context, listen: false);
      provider.debouncer =
          SearchDebouncer(delay: const Duration(milliseconds: 500));
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
        title: const Text("Trade Brains"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CupertinoSearchTextField(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                itemColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                controller: searchController,
                placeholder: 'Search company',
                onChanged: (value) {
                  Provider.of<ProviderScreen>(context, listen: false)
                      .updateSearchResult(value, context);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Consumer<ProviderScreen>(
                  builder: (context, provider, child) {
                    return provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : provider.searchResults.isEmpty
                            ? const Center(
                                child: Text("Search Company"),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final company = provider.searchResults[index];

                                  return Card(
                                    child: ListTile(
                                      title: Text(company.name),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Rs: ${company.latestPrice}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Consumer<ProviderScreen>(
                                            builder:
                                                (context, provider, child) {
                                              final isAdd = provider
                                                  .isInWatchList(company);
                                              return isAdd
                                                  ? const Icon(Icons.check)
                                                  : Card(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              172,
                                                              148,
                                                              238),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          provider.addToWatch(
                                                              company, index);
                                                          toast(
                                                              'Added to Watch List');
                                                        },
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: provider.searchResults.length);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
