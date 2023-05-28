import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:trade_brains/controller/services.dart';
import 'package:trade_brains/model/company_model.dart';
import 'package:trade_brains/model/watch_list_model.dart';
import 'package:trade_brains/view/widget/search_debouncer.dart';

class ProviderScreen with ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<WatchListModel> watchList = [];
  List<Company> searchResults = [];
  bool isLoading = false;
  late SearchDebouncer debouncer;

  Future addToWatchList(WatchListModel value, int index) async {
    final listDb = await Hive.openBox<WatchListModel>('watchList_db');
    final id = await listDb.add(value);

    value.id = id;
    log('added to hive');

    getAllList();
    notifyListeners();
  }

  Future<void> getAllList() async {
    final listDb = await Hive.openBox<WatchListModel>('watchList_db');
    watchList.clear();

    watchList.addAll(listDb.values);
    notifyListeners();
  }

  bool isInWatchList(Company company) {
    return watchList.any((element) => element.name == company.name);
  }

  Future<void> deleteItem(int id) async {
    final listDb = await Hive.openBox<WatchListModel>('watchList_db');
    await listDb.deleteAt(id);
    log('item deleted');
    getAllList();
    notifyListeners();
  }

  void updateSearchResult(String keyword, BuildContext context) async {
    if (keyword.isEmpty) {
      searchResults = [];
    } else {
      isLoading = true;
      notifyListeners();

      debouncer.debounce(() async {
        final results = await fetchSearchResults(keyword);
        log("Result of companies =  ${results[0].name}");
        final List<Company> stocktPrice = [];
        for (var result in results) {
          log('enterd to loop');
          final latestPrice = await fetchLatestPrice(result.symbol);
          stocktPrice.add(Company(
              symbol: result.symbol,
              name: result.name,
              latestPrice: latestPrice));
          log(stocktPrice[0].latestPrice.toString());
        }

        searchResults = stocktPrice;
        isLoading = false;
        notifyListeners();

        FocusScope.of(context).unfocus();
      });
    }
  }

  void addToWatch(Company company, int index) {
    final watchListModel =
        WatchListModel(name: company.name, stockPrice: company.latestPrice);
    watchList.add(watchListModel);
    addToWatchList(watchListModel, index);
    notifyListeners();
  }
}
