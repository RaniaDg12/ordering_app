import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/enums/priority.dart';
import 'providers.dart';
import 'routes.dart';


import 'models/LocalModels/LocalOrder.dart';
import 'models/LocalModels/LocalArticle.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);


  Hive.registerAdapter(LocalOrderAdapter());
  Hive.registerAdapter(LocalArticleAdapter());
  Hive.registerAdapter<Priority>(PriorityAdapter());

  await Hive.openBox<LocalOrder>('orders');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}