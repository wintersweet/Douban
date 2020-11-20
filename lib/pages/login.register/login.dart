import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_douban/models/User.dart';
import 'package:my_douban/models/counter.dart';
import 'package:my_douban/models/subject_entity.dart';
import 'package:my_douban/pages/login.register/register.dart';
import 'package:my_douban/router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    print('build loginPage');
    return Scaffold(
      appBar: AppBar(
        title: Text("登录", style: TextStyle(fontSize: 17)),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: buildLoginBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print('${_controller.text}');
    });
  }

  void requestLogin() async {
    final SubjectEntity entity = SubjectEntity();
    try {
      List<Subject> lists = await entity.getList();
      if (mounted) {
        print("登陆成功");
        String userName = "马云小兄弟";
        UserModel globalStore = Provider.of<UserModel>(context, listen: false);
        globalStore.user = userName;
        globalStore.isLogin = true;
        showMySimpleDialog(context);

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

  void showMySimpleDialog(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: Text("恭喜你！"),
            content: Text("登录成功了，去赚钱吧"),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text("确定", style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    print("111");
                    Navigator.of(context).pop(true);
                  }),
              CupertinoDialogAction(
                  child: Text("取消", style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  })
            ]);
      },
    ).then((value) {
      if (value == true) {
        print("222");
        Navigator.of(context).pop();
      } else {
        print("333");
      }
    });
  }

  void popVC() {
    Navigator.of(context);
  }

  testController() {
    _controller.text = "hello world!";
    _controller.selection =
        TextSelection(baseOffset: 2, extentOffset: _controller.text.length);
  }

  TextEditingController _controller = TextEditingController();
  Widget buildLoginBody() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: '用户名',
            hintText: '请输入用户名',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: '密码',
            hintText: '请输入密码',
            prefixIcon: Icon(Icons.lock),
            suffixStyle: TextStyle(color: Colors.green),
          ),
          onChanged: (xx) {
            print('密码为:$xx');
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            width: 330,
            height: 45,
            child: RaisedButton(
              clipBehavior: Clip.antiAlias,
              onPressed: () => showMySimpleDialog(context),
              child: Text(
                '登录',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget test() {
    Center(
        child: Column(
      children: <Widget>[
        Text(getCount(context)),
        RaisedButton(
          child: Text("counter 为:${getCount(context)}"),
          onPressed: () =>
              {Provider.of<Counter>(context, listen: false).addCount()},
        ),
        RaisedButton(
          child: Text("++"),
          onPressed: () => {
            Provider.of<Counter>(context, listen: false).addCount(),
          },
        ),
        RaisedButton(
          child: Text("去注册"),
          onPressed: () => {Routers.pushToWidget(context, RegisterPage())},
        ),
      ],
    ));
  }

  getCount(BuildContext context) {
    return Provider.of<Counter>(context, listen: false).count.toString();
  }
}
