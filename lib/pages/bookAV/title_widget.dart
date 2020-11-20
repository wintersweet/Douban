import 'package:flutter/material.dart';

typedef TapCallback = void Function();

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _TextImgeWdiget('找电影', 'assets/images/find_movie.png',
            tapCallback: () {}),
        _TextImgeWdiget('豆瓣榜单', 'assets/images/douban_top.png',
            tapCallback: () {}),
        _TextImgeWdiget('豆瓣猜', 'assets/images/douban_guess.png',
            tapCallback: () {}),
        _TextImgeWdiget('豆瓣影片', 'assets/images/douban_film_list.png',
            tapCallback: () {}),
      ],
    );
  }
}

class _TextImgeWdiget extends StatelessWidget {
  final String text;
  final String imageAsset;
  final TapCallback tapCallback;
  _TextImgeWdiget(
    this.text,
    this.imageAsset, {
    Key key,
    this.tapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Image.asset(imageAsset, width: 45, height: 45),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          )
        ],
      ),
    );
  }
}
