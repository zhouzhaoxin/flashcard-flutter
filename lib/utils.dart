import 'package:flashcard/view/CardAddScreen.dart';
import 'package:flashcard/view/CardEditScreen.dart';
import 'package:flashcard/view/CardScreen.dart';
import 'package:flashcard/view/CardViewScreen.dart';
import 'package:flashcard/view/HomeScreen.dart';
import 'package:flashcard/view/LoginScreen.dart';
import 'package:flashcard/view/RememberScreen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case "/home":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "/card":
        return MaterialPageRoute(builder: (_) => CardScreen(cardType: args));
      case "/cardAdd":
        return MaterialPageRoute(builder: (_) => CardAddScreen(card: args));
      case "/cardEdit":
        return MaterialPageRoute(builder: (_) => CardEditScreen(card: args));
      case "/cardView":
        return MaterialPageRoute(builder: (_) => CardViewScreen(card: args));
      case "/remember":
        return MaterialPageRoute(builder: (_) => RememberScreen(cardType: args));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("error"),
        ),
        body: Text("error"),
      );
    });
  }
}

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext?.findRenderObject();
  return renderBox?.size;
}

Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Success',
    message: message,
    icon: Icon(
      Icons.check,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Error',
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

showToast(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt("userId");
  return userId;
}
