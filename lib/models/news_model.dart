import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/tools/base_resp.dart';
import 'package:my_douban/tools/dio_util.dart';

class NewsModelRepo {
  Future<List<NewModel>> getNewsList() async {
    BaseResp baseResp = await DioUtil().request(Method.get, Constant.Home_news);
    if (baseResp.code == 200 || baseResp.code == 0) {
      List<NewModel> lists = (baseResp.data["data"] as List)
          ?.map((e) => e == null ? null : NewModel.fromJson(e))
          ?.toList();
      return lists;
    } else {
      return Future.error(baseResp);
    }
  }
}

class NewModel {
  var title;
  var date;
  var category;
  var authorname;
  var url;
  var thumbnail_pic_s;
  var thumbnail_pic_s02;
  var thumbnail_pic_s03;
  NewModel(this.title, this.date, this.category, this.authorname, this.url,
      this.thumbnail_pic_s, this.thumbnail_pic_s02, this.thumbnail_pic_s03);

  factory NewModel.fromJson(Map<String, dynamic> json) =>
      NewModel.fromMap(json);

  NewModel.fromMap(Map<String, dynamic> map) {
    this.title = map["title"];
    this.date = map["date"];
    this.category = map["category"];
    this.authorname = map["author_name"];

    this.url = map["url"];
    this.thumbnail_pic_s = map["thumbnail_pic_s"];
    this.thumbnail_pic_s02 = map["thumbnail_pic_s02"];
    this.thumbnail_pic_s03 = map["thumbnail_pic_s03"];
  }
}
