class CardType {
  int id;
  int tp;
  String name;

  CardType({this.id, this.tp, this.name});

  factory CardType.fromJson(Map<String, dynamic> json) {
    return CardType(
      id: json['id'],
      tp: json['tp'],
      name: json['name'],
    );
  }
}

class Cards {
  int id;
  int tp;
  int known;
  int uid;
  String front;
  String back;

  Cards({this.id, this.tp, this.known, this.uid, this.front, this.back});

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'],
      tp: json['tp'],
      known: json['known'],
      uid: json['uid'],
      front: json['front'],
      back: json['back'],
    );
  }

  Map<String, dynamic> toJson() => {
        'tp': tp,
        'known': known,
        'front': front,
        'back': back,
        'uid': uid,
        'id': id == null ? -1 : id,
      };
}
