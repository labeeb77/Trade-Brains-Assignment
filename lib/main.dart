import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:trade_brains/controller/provider.dart';
import 'package:trade_brains/model/watch_list_model.dart';
import 'package:trade_brains/view/widget/bottom_nav.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(WatchListModelAdapter().typeId)){
  Hive.registerAdapter(WatchListModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderScreen(),
      child: OverlaySupport.global(
        child: MaterialApp(
           debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          
             darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true
          /* dark theme settings */
        ),
          home: const BottomNav()
        ),
      ),
    );
  }
}
