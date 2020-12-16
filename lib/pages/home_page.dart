import 'package:flutter/material.dart';
import 'package:my_douban/widgets/camera_page.dart';
import 'package:my_douban/pages/homes/home_tab.dart';
import 'package:camera/camera.dart';

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
