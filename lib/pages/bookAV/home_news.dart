import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/constants/widget/style.dart';
import 'package:my_douban/models/news_model.dart';
import 'package:my_douban/mywidgets/image/radius_img.dart';
import 'package:my_douban/tools/dio_util.dart';

class HomeNewsPage extends StatefulWidget {
  HomeNewsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeNewsPageeState();
  }
}

class _HomeNewsPageeState extends State<HomeNewsPage> {
  NewsModelRepo _newsModelRepo;
  List<NewModel> newsList = [];
  bool isLoading = true;
  @override
  void initState() {
    congifDio();
    _newsModelRepo = NewsModelRepo();
    requestNewsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? showIndicatorWidget() : _getBody();
  }

  Widget _getBody() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _getItem(index, newsList);
      },
      shrinkWrap: true,
      itemCount: newsList.length,
    );
  }

  Widget showIndicatorWidget() {
    return Center(
      child: SizedBox(height: 50, width: 50, child: wrapperLoadingIndicator()),
    );
  }

  void congifDio() {
    BaseOptions options = BaseOptions();
    options.baseUrl = Constant.BASE_URL;
    Map<String, dynamic> _headers = Map();
    _headers['Accept-Language'] = 'zh-CN';
    options.headers = _headers;

    DioUtil().setConfig(HttpConfig(
      code: 'error_code',
      msg: 'reason',
      options: options,
      enableLogging: false,
      mockRepo: Constant.MOCK_REPO,
    ));
  }

  void requestNewsList() async {
    try {
      List<NewModel> lists = await _newsModelRepo.getNewsList();
      newsList.addAll(lists);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      print('请求出错：$e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  _getItem(int index, List<NewModel> list) {
    NewModel item = list[index];
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      // margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(Constant.TEST_AVARTAR),
                    ),
                  )),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(item.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.none,
                        )),
                    Text('来源：' + item.category + item.authorname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle())
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(Constant.ASSETS_IMG + 'ic_info_done.png',
                      width: 20, height: 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                Image.network(item.thumbnail_pic_s, width: 100),
                Image.network(item.thumbnail_pic_s, width: 100),
                Image.network(item.thumbnail_pic_s, width: 100),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(Constant.ASSETS_IMG + 'ic_vote.png',
                    width: 25, height: 25),
                Image.asset(
                    Constant.ASSETS_IMG +
                        'ic_notification_tv_calendar_comments.png',
                    width: 20,
                    height: 25),
                Image.asset(
                    Constant.ASSETS_IMG + 'ic_status_detail_reshare_icon.png',
                    width: 25,
                    height: 25),
              ],
            ),
          ),
          Container(
            height: 5,
            color: Colors.grey[50],
          ),
        ],
      ),
    );
  }
}
