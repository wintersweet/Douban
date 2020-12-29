import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_douban/models/User.dart';
import 'package:my_douban/theme/src/data/app_theme.dart';
import 'package:my_douban/theme/src/provider/theme_consumer.dart';
import 'package:my_douban/theme/src/provider/theme_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'container_page.dart';

void main() {
  runApp(MyApp());
  print('第一次测试冲突修改');
  print('第一次测试冲突修改');
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
          body: ThemeProvider(
            saveThemesOnChange: true,
            loadThemeOnInit: false,
            onInitCallback: (controller, previouslySavedThemeFuture) async {
              String savedTheme = await previouslySavedThemeFuture;

              controller.setTheme('purple');

              if (savedTheme != null) {
                controller.setTheme(savedTheme);
              } else {
                Brightness platformBrightness =
                    SchedulerBinding.instance.window.platformBrightness;
                if (platformBrightness == Brightness.dark) {
                  controller.setTheme('dark');
                } else {
                  controller.setTheme('light');
                }
                controller.forgetSavedTheme();
              }
            },
            themes: <AppTheme>[
              AppTheme.light(id: 'light'),
              AppTheme.dark(id: 'dark'),
              AppTheme.purple(id: 'purple'),
              AppTheme.yellow(id: 'yellow'),
            ],
            child: ThemeConsumer(
              child: Builder(
                builder: (themeContext) => MaterialApp(
                  theme: ThemeProvider.themeOf(themeContext).data,
                  title: 'Material App',
                  home: ContainerPage(),
                ),
              ),
            ),
          ),
          resizeToAvoidBottomPadding: false,
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
