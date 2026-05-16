import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import 'services/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.splash,
      routes: AppRoute.getAppRoutes(),
    );
  }
}
