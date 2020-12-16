import 'package:flutter/material.dart';
import 'package:my_douban/store/global.dart';

class RegisterPage extends StatelessWidget with CommonInterface {
  @override
  Widget build(BuildContext context) {
    print('build Page1');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("注册", style: TextStyle(fontSize: 17)),
          backgroundColor: Colors.green,
        ),
        body: Container(
            child: Center(
          child: ProgressRoute(),
        )));
  }
}

class ProgressRoute extends StatefulWidget {
  @override
  _ProgressRouteState createState() => _ProgressRouteState();
}

class _ProgressRouteState extends State<ProgressRoute>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    //动画执行时间3秒
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animationController.forward();
    _animationController.addListener(() => setState(() => {}));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50, left: 10, right: 10),
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: ColorTween(begin: Colors.grey, end: Colors.blue)
                  .animate(_animationController), // 从灰色变成蓝色
              value: _animationController.value,
            ),
          ),
        ],
      ),
    );
  }
}
