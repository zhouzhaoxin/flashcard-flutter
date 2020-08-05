import 'package:flashcard/utils.dart';
import 'package:flashcard/view/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      title: "Flash Card",
      initialRoute: "/login",
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
      ),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
