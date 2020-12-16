import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_douban/models/User.dart';
import 'package:my_douban/pages/bookAV/hot_movie_page.dart';
import 'package:my_douban/pages/bookAV/movie_page.dart';
import 'package:my_douban/store/global.dart';
import 'package:provider/provider.dart';

import 'home_news.dart';

class FlutterTabBarView extends StatelessWidget {
  final TabController tabController;

  FlutterTabBarView({Key key, @required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build FlutterTabBarView');
    Profile file = Global.profile;
    print('用户名字：${file.user}');

    var viewList = [
      MoviePage(key: PageStorageKey<String>('MoviePage')),
      HotMoviePage(),
      Page1(),
      Page2(),
      HomeNewsPage(),
    ];

    return TabBarView(
      children: viewList,
      controller: tabController,
    );
  }
}

MethodChannel _channel;

int viewId = 0;

class Page1 extends StatelessWidget with CommonInterface {
  @override
  Widget build(BuildContext context) {
    print('build Page1');
    return Center(
      child: Column(
        children: <Widget>[
          FlatButton.icon(
              onPressed: clickUpdtae,
              icon: Icon(Icons.update),
              label: Text('11')),
          iOSLabel(),
        ],
      ),
    );
  }

  Widget iOSLabel() {
    return Container(
      height: 200,
      color: Colors.lightBlue,
      child: UiKitView(
        viewType: 'my_flutter_to_native',
        creationParams: {'content': 'flutter传过来的'},
        creationParamsCodec: const StandardMessageCodec(),
        //view创建完成时的回调
        onPlatformViewCreated: (id) {
          viewId = id;
        },
      ),
    );
  }

  void clickUpdtae() {
    _channel = new MethodChannel('my_flutter_to_native_$viewId');
    updateTextView();
  }

  //这里的标识 updateText
  //与android 中接收消息的方法中
  //if ("updateText".equals(methodCall.method)) {...} 一至
  void updateTextView() async {
    return _channel.invokeMethod('updateText', {'key': '从flutter的更新内容'});
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page4');
    return Center(
      child: Consumer<UserModel>(builder: (context, model, child) {
        return Text('${model.user}');
      }),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build Page3');
    return Center(
      child: Text('Page3'),
    );
  }
}
