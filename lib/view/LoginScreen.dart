import 'dart:convert';

import 'package:flashcard/model/global.dart';
import 'package:flashcard/model/response.dart';
import 'package:flashcard/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final utf8decoder = Utf8Decoder();

  static final FormFieldValidator<String> _usernameValidator = (value) {
    if (value.isEmpty) {
      return '用户名为空!';
    }
    return null;
  };

  static final FormFieldValidator<String> _passwordValidator = (value) {
    if (value.isEmpty) {
      return '密码为空!';
    }
    return null;
  };

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = User(username: data.name, password: data.password);
    var future = await http.post("${serverURL}remember/login", body: jsonEncode(user));
    var basic = Basic.fromJson(json.decode(utf8decoder.convert(future.bodyBytes)));
    if (basic.errcode != 200) {
      print(basic.errmsg);
      return basic.errmsg;
    }
    await prefs.setInt("userId", basic.data['id']);
    return null;
  }

  Future<String> _signUp(LoginData data) async {
    var future = await http.post("${serverURL}remember/signup",
        body: jsonEncode(User(username: data.name, password: data.password)));
    var basic = Basic.fromJson(json.decode(utf8decoder.convert(future.bodyBytes)));
    if (basic.errcode != 200) {
      print(basic.errmsg);
      return basic.errmsg;
    }
    return null;
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return '用户名不存在';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Flash Card',
      logo: "",
      onLogin: _login,
      onSignup: _signUp,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed("/home");
      },
      onRecoverPassword: _recoverPassword,
      emailValidator: _usernameValidator,
      passwordValidator: _passwordValidator,
      messages: LoginMessages(
        usernameHint: "用户名",
        passwordHint: "密码",
        confirmPasswordHint: "确认",
        loginButton: "登录",
        signupButton: "注册",
        forgotPasswordButton: "忘记密码？",
        recoverPasswordButton: "查询",
        recoverPasswordIntro: "在此查询密码",
        recoverPasswordDescription: "我们会把密码发送到您的邮箱",
        goBackButton: "返回",
      ),
    );
  }
}
