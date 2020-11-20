import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/tools/base_resp.dart';
import 'package:my_douban/tools/dio_util.dart';

class SubjectEntity {
  Future<List<Subject>> getList() async {
    BaseResp baseResp = await DioUtil().request(Method.get, Constant.Home_tab);
    if (baseResp.code == 200) {
      List<Subject> lists = (baseResp.data as List)
          ?.map((e) => e == null ? null : Subject.fromJson(e))
          ?.toList();
      return lists;
    } else {
      return Future.error(baseResp);
    }
  }
}

class Subject {
  Rating rating;
  var title;
  List<Cast> casts;
  var alt;

  var nameType;
  var apiUrl;
  var name;
  var tabType;
  var id;
  Subject(this.nameType, this.apiUrl, this.name, this.tabType, this.id);

  factory Subject.fromJson(Map<String, dynamic> json) => Subject.fromMap(json);

  Subject.fromMap(Map<String, dynamic> map) {
    var nameType = map['nameType'];
    this.nameType = nameType;
    var apiUrl = map['apiUrl'];
    this.apiUrl = apiUrl;
    var name = map['name'];
    this.name = name;

    var tabType = map['tabType'];
    this.tabType = tabType;
    var id = map['id'];
    this.id = id;
  }

  _converCasts(casts) {
    return casts.map<Cast>((item) => Cast.fromMap(item)).toList();
  }
}

class TitleItem {
  var nameType;
  var apiUrl;
  var name;
  var tabType;
  var id;
  TitleItem(this.nameType, this.apiUrl, this.name, this.tabType, this.id);
}

class Images {
  var small;
  var large;
  var medium;

  Images(this.small, this.large, this.medium);
}

class Rating {
  var average;
  var max;
  Rating(this.average, this.max);
}

class Cast {
  var id;
  var name_en;
  var name;
  Avatar avatars;
  var alt;
  Cast(this.avatars, this.name_en, this.name, this.alt, this.id);

  Cast.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name_en = map['name_en'];
    name = map['name'];
    alt = map['alt'];
    var tmp = map['avatars'];
    if (tmp == null) {
      avatars = null;
    } else {
      avatars = Avatar(tmp['small'], tmp['large'], tmp['medium']);
    }
  }
}

class Avatar {
  var medium;
  var large;
  var small;
  Avatar(this.small, this.large, this.medium);
}
