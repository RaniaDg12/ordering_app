import 'package:provider/provider.dart';
import 'providers/signinProvider.dart';
import 'providers/orderProvider.dart';
import 'providers/OrderStepProvider.dart';

class Providers {
  Providers._();

  static final providers = [
    ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(),
    ),
    ChangeNotifierProvider<OrderModel>(
      create: (_) => OrderModel(),
    ),
    ChangeNotifierProvider<OrderStepProvider>(
      create: (_) => OrderStepProvider(),
    ),
  ].toList();
}