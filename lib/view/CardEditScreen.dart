import 'package:flashcard/model/card.dart';
import 'package:flashcard/model/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardEditScreen extends StatelessWidget {
  final Cards card;

  CardEditScreen({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("修改"),
      ),
      body: CardEditWidget(card: card),
    );
  }
}

class CardEditWidget extends StatefulWidget {
  final Cards card;

  CardEditWidget({Key key, this.card}) : super(key: key);

  _CardEditState createState() => _CardEditState();
}

class _CardEditState extends State<CardEditWidget> {
  final frontController = TextEditingController();
  final backController = TextEditingController();

  Duration get loginTime => Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    frontController.text = widget.card.front;
    backController.text = widget.card.back;
  }

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
                maxLines: 13,
                decoration: InputDecoration.collapsed(hintText: "卡片正面"),
              ),
            )),
        Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: backController,
              maxLines: 13,
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
              color: Colors.orange,
              highlightColor: Colors.orange[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Text("提交"),
              onPressed: () async {
                var base = Basic();
                widget.card.front = frontController.text;
                widget.card.back = backController.text;
                if (await base.put("cards", widget.card)) {
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
