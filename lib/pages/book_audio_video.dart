import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_douban/models/subject_entity.dart';
import 'package:my_douban/pages/bookAV/book_tab_bar_widget.dart';
import 'package:my_douban/router.dart';
import 'package:my_douban/widgets/search_text_field_widget.dart';
import 'package:provider/provider.dart';

class BoolAudioVideoPage extends StatefulWidget {
  @override
  _BookAudioVideoPageState createState() => _BookAudioVideoPageState();
}

TabController _tabController;
List<String> titleList = ["推荐", "热门", "读书", "电影", "新闻"];
List<Widget> tabList;

class _BookAudioVideoPageState extends State<BoolAudioVideoPage>
    with SingleTickerProviderStateMixin {
  List<String> list = [];
  var tabBar;

  @override
  void initState() {
    print('build book_av init');

    super.initState();
    tabList = getTabList();
    tabBar = HomePageTabBar();
    _tabController = TabController(length: titleList.length, vsync: this);
    // requestAPI();
  }

  List<Widget> getTabList() {
    return titleList
        .map((title) => Text(
              "$title",
              style: TextStyle(fontSize: 15),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: DefaultTabController(
            length: titleList.length, child: _getNestedScrollView(tabBar)),
      ),
    );
  }

  Widget _getNestedScrollView(Widget tabBar) {
    String hintText = "用一个词形容你自己";
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: SearchTextFieldWidget(
                  hintText: hintText,
                  onTab: () {
                    Routers.pushNoParams(context, "Page");
                  },
                ),
              ),
            ),
            SliverPersistentHeader(
              floating: true,
              pinned: true,
              delegate: _SliverAppBarDelegate(
                  maxHeight: 49.0,
                  minHeight: 49.0,
                  child: Container(color: Colors.white, child: tabBar)),
            )
          ];
        },
        body: FlutterTabBarView(tabController: _tabController));
  }

  void requestAPI() async {
    print("此处先当做模拟登陆");

    final SubjectEntity entity = SubjectEntity();
    try {
      List<Subject> lists = await entity.getList();
      if (mounted) {
        for (Subject item in lists) {}
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max((minHeight ?? kToolbarHeight), minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overLappsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePageTabBar extends StatefulWidget {
  HomePageTabBar({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomePageTabBarState();
  }
}

class _HomePageTabBarState extends State<HomePageTabBar> {
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;
  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.white,
      child: TabBar(
        tabs: tabList,
        isScrollable: true,
        controller: _tabController,
        indicatorColor: selectColor,
        labelColor: selectColor,
        labelStyle: selectStyle,
        unselectedLabelColor: unselectedColor,
        unselectedLabelStyle: unselectedStyle,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
