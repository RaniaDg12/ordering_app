import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'models/SignIn.dart';
import 'models/order.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => SignInModel()),
  ChangeNotifierProvider(create: (_) => OrderModel()),
];
