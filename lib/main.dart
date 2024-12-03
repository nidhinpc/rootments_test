import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rootments_test/controller/home_screen_controller.dart';
import 'package:rootments_test/controller/login_screen_controller.dart';
import 'package:rootments_test/view/home_screen/home_screen.dart';

import 'package:rootments_test/view/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginScreenController(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeScreenController(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
