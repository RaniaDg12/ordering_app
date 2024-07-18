import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'views/Bienvenue.dart';
import 'views/SignIn.dart';
import 'models/SignIn.dart';
import 'views/orderList.dart';
import 'models/order.dart';
import 'views/addOrder.dart';
import 'views/sync.dart';
import 'models/LocalOrder.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(LocalOrderAdapter());
  Hive.registerAdapter(LocalArticleAdapter());
  Hive.registerAdapter<Priority>(PriorityAdapter());
  Hive.registerAdapter<Status>(StatusAdapter());

  await Hive.openBox<LocalOrder>('orders');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInModel()),
        ChangeNotifierProvider(create: (_) => OrderModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Bienvenue(),
          '/signin': (context) => SignIn(),
          '/orderlist': (context) => OrderList(),
          '/addOrder': (context) => AddOrder(),
          '/sync': (context) => Synchronisation(),
        },
      ),
    );
  }
}
