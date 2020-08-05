import 'package:flashcard/model/card.dart';
import 'package:flashcard/model/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("分类"),
        ),
        body: CardTypeWidget(),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).accentColor,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.remove_red_eye),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class CardTypeWidget extends StatefulWidget {
  _CardTypeState createState() => _CardTypeState();
}

class _CardTypeState extends State<CardTypeWidget> {
  List<CardType> cardTypes = List<CardType>();

  void _initCardType() async {
    var basic = Basic();
    await basic.fetch("card/type");

    setState(() {
      for (var type in basic.data["types"]) {
        var cardType = CardType.fromJson(type);
        cardTypes.add(cardType);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initCardType();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: cardTypes.length * 2,
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();
        final index = item ~/ 2;
        return _buildRow(index);
      },
    );
  }

  Widget _buildRow(int index) {
    return ListTile(
      title: Text(cardTypes[index].name),
      onTap: () {
        Navigator.of(context).pushNamed("/card", arguments: cardTypes[index]);
      },
    );
  }
}
