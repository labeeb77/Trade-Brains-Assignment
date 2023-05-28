import 'package:hive_flutter/hive_flutter.dart';
part 'watch_list_model.g.dart';

@HiveType(typeId: 0)
class WatchListModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double stockPrice;

  WatchListModel({required this.name, required this.stockPrice});
}
