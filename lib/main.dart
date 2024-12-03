import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rootments_test/controller/home_screen_controller.dart';
import 'package:rootments_test/controller/login_screen_controller.dart';
import 'package:rootments_test/firebase_options.dart';
import 'package:rootments_test/view/home_screen/home_screen.dart';

import 'package:rootments_test/view/login_screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: LoginScreen(),
      ),
    );
  }
}
