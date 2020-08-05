import 'package:flashcard/model/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class CardViewScreen extends StatelessWidget {
  final Cards card;

  CardViewScreen({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.front),
      ),
      body: CardViewWidget(
        card: card,
      ),
    );
  }
}

class CardViewWidget extends StatefulWidget {
  final Cards card;

  CardViewWidget({Key key, @required this.card}) : super(key: key);

  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardViewWidget> {
  var code = '''main() {
  print("Hello, World!");
}
''';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: HighlightView(
        // The original code to be highlighted
        widget.card.back,

        // Specify language
        // It is recommended to give it a value for performance
        language: 'python',

        // Specify highlight theme
        // All available themes are listed in `themes` folder
        theme: githubTheme,

        // Specify padding
        padding: EdgeInsets.all(12),

        // Specify text style
        textStyle: TextStyle(
          fontFamily: 'My awesome monospace font',
          fontSize: 18,
        ),
      ),
    );
  }
}
