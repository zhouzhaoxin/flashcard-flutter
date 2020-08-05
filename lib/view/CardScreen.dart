import 'package:flashcard/model/card.dart';
import 'package:flashcard/model/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int userId;
int tp;

class CardScreen extends StatelessWidget {
  final CardType cardType;

  CardScreen({Key key, @required this.cardType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardType.name),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {
              Navigator.of(context).pushNamed("/remember", arguments: cardType);
            },
          )
        ],
      ),
      body: CardWidget(cardType: cardType),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/cardAdd", arguments: Cards(uid: userId, tp: tp));
        },
      ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final CardType cardType;

  CardWidget({Key key, @required this.cardType}) : super(key: key);

  _CardState createState() => _CardState();
}

class _CardState extends State<CardWidget> {
  List<Cards> cards = List<Cards>();
  Set<int> knownCards = Set<int>();

  int page;
  int size;

  String _buildParam(int page) {
    return "cards?tp=$tp&uid=$userId&page=$page&size=$size";
  }

  void _fetchCard(int page) async {
    var basic = Basic();
    await basic.fetch(_buildParam(page));
    if (basic.data["cards"].length > 0) {
      setState(() {
        for (var type in basic.data["cards"]) {
          var cardType = Cards.fromJson(type);
          cards.add(cardType);
          if (cardType.known == 2) {
            knownCards.add(cardType.id);
          }
        }
      });
    }
  }

  void _initCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");
    tp = widget.cardType.id;
    page = 1;
    size = 10;
    _fetchCard(page);
  }

  @override
  void initState() {
    super.initState();
    _initCard();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: _buildListView(),
      onRefresh: () async {
        cards.clear();
        _initCard();
      },
    );
  }

  Widget _buildRow(int index) {
    final alreadySaved = knownCards.contains(cards[index].id);

    String front;
    return Dismissible(
      secondaryBackground: Container(
        color: Colors.orange,
        child: Icon(Icons.edit),
      ),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      key: Key("${cards[index].id}"),
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          front = cards[index].front;
          var base = Basic();
          if (await base.delete("cards?id=${cards[index].id}}")) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("$front 已删除")));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("$front 删除失败")));
          }
        } else {
          Navigator.of(context).pushNamed("/cardEdit", arguments: cards[index]);
        }
        setState(() {
          cards.removeAt(index);
        });
      },
      child: ListTile(
        trailing: IconButton(
          icon: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
          onPressed: () async {
            if (!alreadySaved) {
              print("unknown to known");
              await _rememberCard(cards[index].uid, cards[index].id, cards[index].tp);
              setState(() {
                knownCards.add(cards[index].id);
              });
            } else {
              print("known to unknown");
              await _forgetCard(cards[index].uid, cards[index].id, cards[index].tp);
              setState(() {
                knownCards.remove(cards[index].id);
              });
            }
          },
        ),
        title: Text(cards[index].front),
        onTap: () {
          Navigator.of(context).pushNamed("/cardView", arguments: cards[index]);
        },
      ),
    );
  }

  Future<bool> _rememberCard(int uid, int id, int tp) async {
    var base = Basic();
    return await base.fetch("remember/known?uid=$uid&id=$id&tp=$tp");
  }

  Future<bool> _forgetCard(int uid, int id, int tp) async {
    var base = Basic();
    return await base.fetch("remember/unknown?uid=$uid&id=$id&tp=$tp");
  }

  _buildListView() {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: cards.length * 2,
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();
          final index = item ~/ 2;
          if (index == cards.length - 1) {
            page++;
            _fetchCard(page);
          }
          return _buildRow(index);
        });
  }
}
