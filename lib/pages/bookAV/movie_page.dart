import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/pages/bookAV/title_widget.dart';
import 'package:my_douban/pages/bookAV/today_play_movie.dart';

import 'hot_soon_tab_bar.dart';
import 'dart:math' as math;

class MoviePage extends StatefulWidget {
  MoviePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoviePageState();
  }
}

class _MoviePageState extends State<MoviePage>
    with AutomaticKeepAliveClientMixin {
  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0; //选中的是热映、即将上映

  HotSoonTabBar hotSoonTabBar;
  Widget hotSoonTabBarPadding;
  var itemW;
  var imgSize;
  static const String url =
      'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2544987866.webp';
  static const String url1 =
      'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2508369771.webp';
  static const String url2 =
      'https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2544987866.webp';

  var urls = [url, url1, url2];
  @override
  void initState() {
    super.initState();

    hotSoonTabBar = HotSoonTabBar(onTabCallBack: (index) {
      setState(() {
        selectIndex = index;
      });
    });
    hotSoonTabBarPadding = Padding(
      padding: EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabBar,
    );

    Future.delayed(Duration(seconds: 2), () {
      hotSoonTabBar.setCount(["1", '2', '3']);
      hotSoonTabBar.setComingSoonCount(["1", '2', '3']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _containerBody(),
      ],
    );
  }

  int _getChildCount() {
    if (selectIndex == 0) {
      return 7;
    } else {
      return 9;
    }
  }

  Widget _containerBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: new TitleWidget(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TodayPlayMovieWidget(urls),
            ),
          ),
          SliverToBoxAdapter(
            child: hotSoonTabBarPadding,
          ),
          SliverGrid(
            key: PageStorageKey<String>('xxxx'),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Center(
                child: Text('$index'),
              );
            }, childCount: math.max(_getChildCount(), 6)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
              mainAxisSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
