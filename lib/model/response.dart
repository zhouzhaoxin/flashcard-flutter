import 'dart:convert';

import 'package:flashcard/model/global.dart';
import 'package:http/http.dart' as http;

class Basic {
  int errcode;
  String errmsg;
  dynamic data;
  final utf8decoder = Utf8Decoder();

  Basic({this.errcode, this.errmsg, this.data});

  factory Basic.fromJson(Map<String, dynamic> json) {
    return Basic(
      errcode: json['errcode'],
      errmsg: json['errmsg'],
      data: json['data'],
    );
  }

  Future<bool> fetch(String path) async {
    var url = "$serverURL$path";
    print(url);
    var response = await http.get("$serverURL$path");
    var decode = json.decode(utf8decoder.convert(response.bodyBytes));
    this.data = decode['data'];
    this.errmsg = decode['errmsg'];
    this.errcode = decode['errcode'];
    if (this.errcode == 200) {
      return true;
    } else {
      print(this.errmsg);
      return false;
    }
  }

  Future<bool> post(String path, dynamic data) async {
    var url = "$serverURL$path";
    print(url);
    print(jsonEncode(data));
    var response = await http.post("$serverURL$path", body: jsonEncode(data));
    var decode = json.decode(utf8decoder.convert(response.bodyBytes));
    this.data = decode['data'];
    this.errmsg = decode['errmsg'];
    this.errcode = decode['errcode'];
    if (this.errcode == 200) {
      return true;
    } else {
      print(this.errmsg);
      return false;
    }
  }

  Future<bool> delete(String path) async {
    var url = "$serverURL$path";
    print(url);
    var response = await http.delete("$serverURL$path");
    var decode = json.decode(utf8decoder.convert(response.bodyBytes));
    this.data = decode['data'];
    this.errmsg = decode['errmsg'];
    this.errcode = decode['errcode'];
    if (this.errcode == 200) {
      return true;
    } else {
      print(this.errmsg);
      return false;
    }
  }

  Future<bool> put(String path, dynamic data) async {
    var url = "$serverURL$path";
    print(url);
    var response = await http.put("$serverURL$path", body: jsonEncode(data));
    var decode = json.decode(utf8decoder.convert(response.bodyBytes));
    this.data = decode['data'];
    this.errmsg = decode['errmsg'];
    this.errcode = decode['errcode'];
    if (this.errcode == 200) {
      return true;
    } else {
      print(this.errmsg);
      return false;
    }
  }
}
