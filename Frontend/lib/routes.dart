import 'package:flutter/material.dart';

import 'views/Bienvenue.dart';
import 'views/SignIn.dart';
import 'views/orderList.dart';
import 'views/addOrder.dart';
import 'views/sync.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => Bienvenue(),
  '/signin': (context) => SignIn(),
  '/orderlist': (context) => OrderList(),
  '/addOrder': (context) => AddOrder(),
  '/sync': (context) => Synchronisation(),
};
