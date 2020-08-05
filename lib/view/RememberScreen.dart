import 'package:flashcard/model/card.dart';
import 'package:flashcard/model/response.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../utils.dart';

var currentCardId = 0;

class RememberScreen extends StatelessWidget {
  final CardType cardType;

  RememberScreen({Key key, @required this.cardType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardType.name),
        actions: [
          IconButton(
            icon: Icon(Icons.layers),
            onPressed: () async {
              var base = Basic();
              int userId = await getUserId();
              await base.fetch("remember/known?tp=${cardType.tp}&id=$currentCardId&uid=$userId");
            },
          )
        ],
      ),
      body: RememberScreenWidget(
        cardType: cardType,
      ),
    );
  }
}

class RememberScreenWidget extends StatefulWidget {
  final CardType cardType;

  RememberScreenWidget({Key key, @required this.cardType}) : super(key: key);

  _RememberScreenState createState() => _RememberScreenState();
}

class _RememberScreenState extends State<RememberScreenWidget> {
  List<Cards> cards = List<Cards>();
  int page = 1;

  _nextRememberCard() async {
    print("int next");
    int userId = await getUserId();
    page++;
    var basic = Basic();
    await basic.fetch("remember/index?uid=$userId&tp=${widget.cardType.id}&curr=$page");

    if (basic.data["cards"].length > 0) {
      setState(() {
        for (var c in basic.data["cards"]) {
          var card = Cards.fromJson(c);
          cards.add(card);
        }
      });
    }
  }

  Future _initRememberCard() async {
    int userId = await getUserId();
    var basic = Basic();
    await basic.fetch("remember/index?uid=$userId&tp=${widget.cardType.id}&curr=$page");
    setState(() {
      for (var c in basic.data["cards"]) {
        var card = Cards.fromJson(c);
        cards.add(card);
      }
    });
  }

  _refreshRememberCard() async {
    int userId = await getUserId();
    var basic = Basic();

    await basic
        .fetch("remember/refresh?uid=$userId&tp=${widget.cardType.id}&curr=$page")
        .then((value) => {cards.clear()});
    await _initRememberCard();
  }

  @override
  void initState() {
    super.initState();
    _refreshRememberCard();
//    _initRememberCard();
  }

  @override
  void dispose() {
    cards.clear();
    super.dispose();
  }

  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return _buildPageView();
  }

  Widget _buildPageView() {
    return PageView.builder(
        itemCount: cards.length,
        itemBuilder: (context, item) {
          if (item == cards.length - 1) {
            _nextRememberCard();
          }
          currentCardId = cards[item].id;
          return _buildHighlightView(cards[item].front, cards[item].back);
        });
  }

  Widget _buildHighlightView(String front, String back) {
    return FlipCard(
      front: _buildScrollView(front),
      back: _buildScrollView(back),
    );
  }

  Widget _buildScrollView(String code) {
    return SingleChildScrollView(
        child: HighlightView(
      // The original code to be highlighted
      code,

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
    ));
  }
}
