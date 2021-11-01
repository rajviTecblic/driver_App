
import 'package:driver/Screens/Detailspage.dart';
import 'package:driver/Screens/GoogleMapScreen.dart';
import 'package:driver/Screens/ListDelivery.dart';
import 'package:driver/Screens/LiveTrackingScreen.dart';
import 'package:driver/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.0,
        ),

        primarySwatch: Colors.blue,
      ),
     home: LoginScreen(),
     // home: Home(),
    );
  }
}

