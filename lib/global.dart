library global;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/User.dart';

part 'global.g.dart';

@JsonSerializable()
class Profile {
  String user = '';
  bool isLogin = false;
  String avatar = '';
  Profile();

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    _prefs = await SharedPreferences.getInstance();

    String _profile = _prefs.getString('profile');
    Response message;
    if (_profile != null) {
      try {
        //  如果存在用户，则拉取聊天记录
        Map decodeContent = jsonDecode(_profile != null ? _profile : '');
        profile = Profile.fromJson(decodeContent);
      } catch (e) {
        print(e);
      }
    }
  }

  static saveProfile() =>
      _prefs.setString('profile', jsonEncode(profile.toJson()));
}

//  给其他widget做的抽象类，用来获取数据
abstract class CommonInterface {
  String cUser(BuildContext context) {
    return Provider.of<UserModel>(context).user;
  }
}
