import 'package:flutter/material.dart';
import 'package:my_douban/main.dart';
import 'package:my_douban/mywidgets/camera_page.dart';
import 'package:my_douban/pages/homes/home_tab.dart';
import 'package:quiver/io.dart';
import 'package:my_douban/mywidgets/GradientButton.dart';
import 'package:camera/camera.dart';
import 'package:my_douban/mywidgets/example_camera.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: HomeTabPage(),
    );
  }

  Future showCameraPage() async {
    getCameras().then((e) {
      print("开始跳转");
      Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return CameraPage(cameras);
      }));
    });
  }

  List<CameraDescription> cameras;
  Future<void> getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    print("camera存在$cameras");
  }

  onTap(BuildContext context) {}
}
