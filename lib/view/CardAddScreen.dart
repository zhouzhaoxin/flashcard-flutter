import 'package:flashcard/model/card.dart';
import 'package:flashcard/model/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardAddScreen extends StatelessWidget {
  final Cards card;

  CardAddScreen({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("添加"),
      ),
      body: SingleChildScrollView(
        child: CardAddWidget(card: card),
      ),
    );
  }
}

class CardAddWidget extends StatefulWidget {
  final Cards card;

  CardAddWidget({Key key, this.card}) : super(key: key);

  _CardAddState createState() => _CardAddState();
}

class _CardAddState extends State<CardAddWidget> {
  final frontController = TextEditingController();
  final backController = TextEditingController();

  Duration get loginTime => Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: frontController,
                maxLines: 10,
                decoration: InputDecoration.collapsed(hintText: "卡片正面"),
              ),
            )),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: backController,
              maxLines: 10,
              decoration: InputDecoration.collapsed(hintText: "卡片反面"),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: SizedBox(
            width: 150,
            height: 50,
            child: RaisedButton(
              color: Colors.green,
              highlightColor: Colors.green[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Text("提交"),
              onPressed: () async {
                var base = Basic();
                widget.card.front = frontController.text;
                widget.card.back = backController.text;
                widget.card.known = 1;
                print(widget.card.known);
                if (await base.post("cards", widget.card)) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("成功"),
                  ));

                  Future.delayed(loginTime).then((_) {
                    Navigator.pop(context);
                  });
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("失败"),
                  ));
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
