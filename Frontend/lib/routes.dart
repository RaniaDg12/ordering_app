import 'package:flutter/material.dart';

import 'views/Bienvenue.dart';
import 'views/SignIn.dart';
import 'views/orderList.dart';
import 'views/addOrder.dart';
import 'views/sync.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Bienvenue(),
  '/signin': (context) => const SignIn(),
  '/orderlist': (context) => const OrderList(),
  '/addOrder': (context) => const AddOrder(),
  '/sync': (context) => const Synchronisation(),
};
