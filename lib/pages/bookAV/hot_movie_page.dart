import 'package:flutter/material.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/widgets/image/radius_img.dart';

import '../../router.dart';

//热门电影
class HotMoviePage extends StatefulWidget {
  HotMoviePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HotMoviePageState();
  }
}

class _HotMoviePageState extends State<HotMoviePage> {
  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  Widget _getBody() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Image.asset(Constant.ASSETS_IMG + "ic_group_top.png");
          }
          return Padding(
            padding: const EdgeInsets.only(right: 13, left: 6, top: 10),
            child: _getItem(index - 1),
          );
        });
  }

  _getItem(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: <Widget>[
          RadiusImg.get(Constant.TEST_IMG, 50, radius: 3.0),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "海上钢琴师",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "人生真谛，无人能懂！",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "1300人",
              style: TextStyle(fontSize: 13),
            ),
          ),
          GestureDetector(
            child: Image.asset(
              Constant.ASSETS_IMG + 'ic_group_checked_anonymous.png',
              width: 25,
              height: 25,
            ),
            onTap: () {
              setState(() {});
            },
          )
        ],
      ),
      onTap: () {
        // Router().pushNoParams(context, "xx");
        Routers.pushNoParams(context, 'url');
      },
    );
  }
}
