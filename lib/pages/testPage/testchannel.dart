import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(TestMyApp());
}

class TestMyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestMyHomePage(title: 'Flutter native iOS'),
    );
  }
}

class TestMyHomePage extends StatefulWidget {
  TestMyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*<与原生交互信号通道 >*/
const methodChannel = const MethodChannel('flutter_native_ios');

class _MyHomePageState extends State<TestMyHomePage> {
  //封装 Flutter 向 原生中 发送消息 的方法
  //method 为方法标识
  //arguments 为参数
  static Future<dynamic> tokNative(String method, {Map arguments}) async {
    if (arguments == null) {
      //无参数发送消息
      return await methodChannel.invokeMethod(method);
    } else {
      //有参数发送消息
      return await methodChannel.invokeMethod(method, arguments);
    }
  }

  static const EventChannel eventChannel =
      const EventChannel('com.pages.your/native_post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new ListTile(
              title: new Text('flutter与原生交互,(push)'),
              trailing: FlatButton(
                  onPressed: () {
                    tokNative('flutter_push_to_ios',
                        arguments: {'key': 'value'})
                      ..then((result) {
                        print('$result');
                      });
                    print('push');
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )),
            ),
            new ListTile(
              title: new Text('flutter与原生交互,(present)'),
              trailing: FlatButton(
                  onPressed: () {
                    tokNative('flutter_present_to_ios')
                      ..then((result) {
                        print('$result');
                      });
                    print('present');
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
