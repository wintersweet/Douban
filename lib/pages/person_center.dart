import 'package:flutter/material.dart';
import 'package:my_douban/constants/constant.dart';
import 'package:my_douban/models/User.dart';
import 'package:my_douban/models/counter.dart';
import 'package:my_douban/models/subject_entity.dart';
import 'package:my_douban/theme/theme_provider.dart';
import 'package:my_douban/widgets/image/heart_img_widget.dart';
import 'package:provider/provider.dart';

import 'login.register/login.dart';

typedef VoidCallback = void Function();

class PersonCenterPage extends StatefulWidget {
  _PersonCenterPageState createState() => _PersonCenterPageState();
}

VoidCallback onTap;
Counter counter = Counter(1);

class _PersonCenterPageState extends State<PersonCenterPage> {
  @override
  void initState() {
    super.initState();
  }

  void requestLogin() async {
    final SubjectEntity entity = SubjectEntity();
    try {
      if (mounted) {
        print("登陆成功");
        String userName = "马云";
        UserModel globalStore = Provider.of<UserModel>(context, listen: false);
        globalStore.user = userName;
        globalStore.isLogin = true;
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
    var controller = ThemeProvider.controllerOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 210,
                flexibleSpace: HeartImgWidget(
                  Image.asset(
                      Constant.ASSETS_IMG + 'bg_person_center_default.webp'),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10, top: 15, bottom: 20, right: 10),
                      child: Image.asset(Constant.ASSETS_IMG + 'ic_notify.png',
                          width: 30, height: 30),
                    ),
                    Expanded(
                      child: Text(
                        '提醒',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                    _rightArrow(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 88,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text("暂无消息"),
                ),
              ),
              _dividerSpace(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "我的书籍",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: _VideoBookMusicWidget(),
                ),
              ),
              _dividerSpace(),
              _personItem('ic_me_journal.png', '我的发布', onTab: _onClick()),
              _personItem('ic_me_journal.png', '切换主题', onTab: () {
                controller.nextTheme();
              }),
              _personItem('ic_me_follows.png', '我的关注'),
              _personItem('ic_me_photo_album.png', '相册'),
              _personItem('ic_me_doulist.png', '豆列/收藏'),
              _dividerSpace(),
              _personItem('ic_me_wallet.png', '钱包'),
              _personItem('ic_me_wallet.png', '登录', onTab: login),
              _personItem('ic_me_wallet.png', '++', onTab: quit),
            ],
          ),
        ),
      ),
    );
  }

  quit() {
    counter.addCount();
  }

  login() {
    // requestLogin();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<Counter>.value(value: counter),
          ],
          child: LoginPage(),
        );
      }),
    );
  }

  _onClick() {}

  _rightArrow() {
    return Icon(
      Icons.chevron_right,
      color: const Color.fromARGB(255, 204, 204, 204),
    );
  }

  SliverToBoxAdapter _dividerSpace() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: Color.fromARGB(255, 247, 247, 247),
      ),
    );
  }

  SliverToBoxAdapter _personItem(String image, String title,
      {VoidCallback onTab}) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                Constant.ASSETS_IMG + image,
                width: 25,
                height: 25,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 15.0, color: Theme.of(context).buttonColor),
              ),
            ),
            _rightArrow()
          ],
        ),
        onTap: onTab,
      ),
    );
  }
}

class _VideoBookMusicWidget extends StatefulWidget {
  _VideoBookMusicWidgetState createState() {
    return _VideoBookMusicWidgetState();
  }
}

class _VideoBookMusicWidgetState extends State<_VideoBookMusicWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTxt.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: DefaultTabController(
          length: tabTxt.length,
          child: Column(
            children: <Widget>[
              Align(
                child: _TabBarWidget(),
                alignment: Alignment.centerLeft,
              ),
              _tableBarView(),
            ],
          )),
    );
  }

  Widget _tableBarView() {
    return Expanded(
      child: TabBarView(
        children: <Widget>[
          _tabBarItem('bg_videos_stack_default.png'),
          _tabBarItem('bg_videos_stack_default.png'),
          _tabBarItem('bg_videos_stack_default.png')
        ],
        controller: _tabController,
      ),
    );
  }

  _tabBarItem(String img) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTabViewItem(img, '想看'),
        getTabViewItem(img, '在看'),
        getTabViewItem(img, '看过'),
      ],
    );
  }

  Widget getTabViewItem(String image, String title) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              Constant.ASSETS_IMG + image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(title),
      ],
    );
  }
}

class _TabBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabBarWidgetState();
}

TabController _tabController;
final List<String> tabTxt = ['影视', '图书', '音乐'];

class _TabBarWidgetState extends State<_TabBarWidget> {
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;
  List<Widget> tabWidgets;
  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
    tabWidgets = tabTxt
        .map((item) => Text(
              item,
              style: TextStyle(fontSize: 15),
            ))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) {
      _tabController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabWidgets,
      isScrollable: true,
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,
    );
  }
}
