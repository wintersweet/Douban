import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_douban/models/subject_entity.dart';
import 'package:my_douban/widgets/image/radius_img.dart';
import 'package:my_douban/widgets/search_text_field_widget.dart';
import 'package:my_douban/widgets/video_widget.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/pages/login.register/login.dart';

import '../../router.dart';
// import 'home_app_bar.dart' as myapp;

class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

List<String> _tabs = ["动态", "推荐"];

class _HomeTabPageState extends State<HomeTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabC;
  @override
  void initState() {
    super.initState();
    _tabC = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  @override
  Widget build1(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          indicatorPadding: EdgeInsets.only(left: 50),
          tabs: _tabs.map((xx) => Tab(text: xx)).toList(),
          controller: _tabC,
        ),
      ),
      body: TabBarView(
        controller: _tabC,
        children: _tabs.map((title) {
          return SliverContainer(
            name: title,
          );
        }).toList(),
      ),
    );
  }

  DefaultTabController getWidget() {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 1,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            // SliverOverlapAbsorber(
            //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            //   child: [],
            // ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                primary: true,
                titleSpacing: 0.0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: Colors.green,
                    child: SearchTextFieldWidget(
                      hintText: "影视作品",
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      onTab: () {
                        print("去搜索1");
                        Routers.pushNoParams(context, "Page");
                      },
                    ),
                    alignment: Alignment(0.0, 0.0),
                  ),
                ),
                // bottomTextString: _tabs,
                bottom: TabBar(
                  tabs: _tabs
                      .map((e) => Container(
                            child: Text(e),
                            padding: const EdgeInsets.only(bottom: 10),
                          ))
                      .toList(),
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          // controller: _tabC,
          children: _tabs.map((title) {
            return SliverContainer(
              name: title,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SliverContainer extends StatefulWidget {
  final String name;
  SliverContainer({Key key, @required this.name}) : super(key: key);

  @override
  _SliverContainerState createState() => _SliverContainerState();
}

class _SliverContainerState extends State<SliverContainer> {
  List<Subject> list = [];

  @override
  void initState() {
    super.initState();
    print("Home page init");
    if (list == null || list.isEmpty) {
      if (_tabs[0] == widget.name) {}
    } else {}
  }

  void requestAPI() async {
    final SubjectEntity entity = SubjectEntity();
    try {
      List<Subject> lists = await entity.getList();
      if (mounted) {
        list.addAll(lists);
        setState(() {});
      }
    } on Exception catch (e) {
      print('tab刷新$e');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getContentSliver(context, list);
  }

  //动态TAB
  _getContentSliver(BuildContext context, List<Subject> list) {
    if (widget.name == _tabs[0]) {
      return _loginContainer(context);
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          primary: false,
          physics: const BouncingScrollPhysics(),
          key: PageStorageKey<String>(widget.name),
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  ((BuildContext context, int index) {
                return getCommentItem(list, index);
              }), childCount: 5),
            ),
          ],
        );
      }),
    );
  }

  double singleLineImgHeight = 180.0;
  double contentVideoHeight = 350.0;
  //列表的普通单个item
  getCommentItem(List<Subject> items, int index) {
    // Subject item = items[index];
    bool showVideo = index == 1;
    return Container(
      height: showVideo ? singleLineImgHeight : singleLineImgHeight,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(Constant.TEST_AVARTAR),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("复仇者联盟-终极之战"),
              ),
              Expanded(
                child: Align(
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                    size: 18,
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: getItemCenterImg(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
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
        ],
      ),
    );
  }

  getItemCenterImg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: RadiusImg.get(
            Constant.TEST_HOME_CARD,
            null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              bottomLeft: Radius.circular(5),
            )),
          ),
        ),
        Expanded(
          child: RadiusImg.get(Constant.TEST_HOME_CARD, null, radius: 2.0),
        ),
        Expanded(
          child: RadiusImg.get(
            Constant.TEST_HOME_CARD,
            null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              bottomLeft: Radius.circular(5),
            )),
          ),
        ),
      ],
    );
  }

  getItemVideoImg(int index) {
    if (!mounted) {
      return Container();
    }
    return VideoWidget(
      index == 1 ? "url1" : "url2",
      showProgressBar: false,
    );
  }

  _loginContainer(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/" + "ic_new_empty_view_default.png",
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              "登陆后查看关注人的动态",
              style: TextStyle(fontSize: 15, color: Colors.green),
            ),
          ),
          GestureDetector(
            child: Container(
              child: Text(
                '去登陆',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              padding:
                  const EdgeInsets.only(left: 35, right: 35, top: 8, bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
            ),
            onTap: () {
              print("去登录");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
