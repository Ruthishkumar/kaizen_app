import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kaizen_app/features/controller/firebase_api.dart';
import 'package:kaizen_app/features/view/screens/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initialNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoutes,

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


class RouteGenerator {

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case '/screen2':
        return MaterialPageRoute(builder: (context) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (context) => Scaffold(
          body: Center(
            child: Text("Not found ${settings.name}"),
          ),
        ));
    }
  }
}
