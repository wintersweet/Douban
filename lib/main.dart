import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_douban/global.dart';
import 'package:my_douban/models/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'mywidgets/splash_widget.dart';

void main1() => Global.init().then((e) => runApp(MyApp()));
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = new UserModel();
    return MultiProvider(
      providers: [
        ListenableProvider<UserModel>.value(value: userModel),
      ],
      child: MaterialApp(
        theme: ThemeData(backgroundColor: Colors.white),
        home: Scaffold(
          // body: ContainerPage(),
          resizeToAvoidBottomPadding: false,
          body: SplashWidget(),
        ),
      ),
    );
  }
}

List<CameraDescription> cameras;
// void main() async {
//   /// 获取设备上可用摄像头的列表。
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    /// 从可用摄像头列表中获取特定摄像头。
    final firstCamera = cameras.first;

    // 要显示摄像机的当前输出
    // 创建一个CameraController
    _controller = CameraController(
      // 从可用摄像头列表中获取特定摄像头
      firstCamera,
      // 定义要使用的分辨率。
      ResolutionPreset.medium,
    );

    // 接下来，初始化控制器。 这将返回一个Future
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            // 确保已初始化摄像机。
            await _initializeControllerFuture;

            final path = join(
                (await getTemporaryDirectory()).path, '${DateTime.now()}.png');
            await _controller.takePicture(path);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return AspectRatio(
              aspectRatio: 0.2, // _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
