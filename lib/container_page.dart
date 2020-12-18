import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/pages/home_page.dart';
import 'package:my_douban/pages/person_center.dart';
import 'package:my_douban/pages/book_audio_video.dart';
import 'package:my_douban/pages/shop_page.dart';
import 'package:my_douban/tools/dio_util.dart';

class ContainerPage extends StatefulWidget {
  ContainerPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContainerPageState();
  }
}

class _Item {
  String name, activeIcon, normalIcon;
  _Item(this.name, this.activeIcon, this.normalIcon);
}

class _ContainerPageState extends State<ContainerPage> {
  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);
  List<Widget> pages;
  final itemNames = [
    _Item('首页', 'assets/images/ic_tab_home_active.png',
        'assets/images/ic_tab_home_normal.png'),
    _Item('书影音', 'assets/images/ic_tab_subject_active.png',
        'assets/images/ic_tab_subject_normal.png'),
    _Item('市集', 'assets/images/ic_tab_shiji_active.png',
        'assets/images/ic_tab_shiji_normal.png'),
    _Item('我的', 'assets/images/ic_tab_profile_active.png',
        'assets/images/ic_tab_profile_normal.png')
  ];
  int _selectIndex = 0;
  List<BottomNavigationBarItem> itemList;
  @override
  void initState() {
    super.initState();
    congifDio();
    if (pages == null) {
      pages = [
        HomePage(),
        BoolAudioVideoPage(),
        ShopPage(),
        PersonCenterPage(),
      ];
    }
    if (itemList == null) {
      itemList = itemNames
          .map(
            (item) => BottomNavigationBarItem(
              icon: Image.asset(
                item.normalIcon,
                width: 30.0,
                height: 30.0,
              ),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 12.0),
              ),
              activeIcon:
                  Image.asset(item.activeIcon, width: 30.0, height: 30.0),
            ),
          )
          .toList();
    }
  }

  //Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  void didUpdateWidget(ContainerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          _getPagesWidget(0),
          _getPagesWidget(1),
          _getPagesWidget(2),
          _getPagesWidget(3),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: itemList,
        onTap: (int index) {
          print("选中了11：$index");
          setState(() {
            _selectIndex = index;
          });
        },
        iconSize: 24,
        currentIndex: _selectIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Color.fromARGB(255, 0, 0, 0),
        showUnselectedLabels: true,
      ),
    );
  }

  void congifDio() {
    BaseOptions options = BaseOptions();
    options.baseUrl = Constant.BASE_URL;
    Map<String, dynamic> _headers = Map();
    _headers['Accept-Language'] = 'zh-CN';
    options.headers = _headers;

    DioUtil().setConfig(HttpConfig(
      code: 'code',
      msg: 'message',
      options: options,
      enableLogging: false,
      mockRepo: Constant.MOCK_REPO,
    ));
  }
}
