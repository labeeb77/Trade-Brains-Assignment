import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_brains/controller/provider.dart';

class WatchList extends StatelessWidget {
  const WatchList({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProviderScreen>(context, listen: false).getAllList();
    });
    final provider = Provider.of<ProviderScreen>(context);
    final watchList = provider.watchList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch List"),
        centerTitle: true,
        elevation: 10,
      ),
      body: watchList.isEmpty
          ? const Center(
              child: Text("No data added"),
            )
          : ListView.separated(
              itemCount: watchList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = watchList[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Rs: ${item.stockPrice.toStringAsFixed(2)},',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Card(
                        color: const Color.fromARGB(255, 172, 148, 238),
                        child: IconButton(
                          onPressed: () {
                            provider.deleteItem(index);
                            toast("Deleted from Watch List");
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
