import 'dart:io'; 
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_douban/main.dart';
import 'package:my_douban/mywidgets/example_camera.dart';
import 'package:my_douban/pages/home_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;
CameraController controller;
Future<void> getCameras1() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();

    } on CameraException catch (e) {
      print(e.toString());
    }
}
class CameraPage extends StatefulWidget {

 final List<CameraDescription> _cameras;
  CameraPage(this._cameras){
    cameras = _cameras;
  }
  // CameraPage({ Key key,@required this.cameras}) 
  //  : super (key:key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller;

  Future<void> _initializeControllerFuture;
  String imagePath;

  @override
  void initState()  {
      init();    
      super.initState();
  }
 
   init() {
    // final firstCamera = cameras.first;
    // print("firstCamera==$firstCamera");

    // // 要显示摄像机的当前输出
    // // 创建一个CameraController
    // _controller = CameraController(
    //   // 从可用摄像头列表中获取特定摄像头
    //   firstCamera,
    //   ResolutionPreset.medium,
    // );
    // // 接下来，初始化控制器。 这将返回一个Future
    // _initializeControllerFuture = _controller.initialize();

    if(cameras != null){
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }else{
       print("camer为空");

    }

  }
 
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
 
  Widget build1(BuildContext context) {
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
            print("catch=$e");
          }
        },
      ),
      
      /*floatingActionButton: new FloatingActionButton(
          foregroundColor: Colors.white,
          elevation: 10.0,
          onPressed: onTakePictureButtonPressed,
          child: new Image.asset('assets/images/find_movie.png'),
        ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
      */
       body: FutureBuilder<void>(
         future: _initializeControllerFuture,
         builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },),
    );
  }
  
   void onTakePictureButtonPressed() {
    print("1111");
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) print('Picture saved to $filePath');
      }
    });
  }
  // 页面布局，上方显示 拍照预览，下方为按钮
   Widget build(BuildContext context) {
    return Scaffold(
      body:new Container(
        child:Stack(children: <Widget>[
          new Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _cameraPreviewWidget(),
              ),
              Expanded(
                flex: 1,
                child: testTakeView()
              )
            ],
          ),
           getPhotoPreview()
        ],)
      )
    );
  }
  //相机预览显示
  Widget _cameraPreviewWidget() {
    print(controller);
    if (controller == null || !controller.value.isInitialized) {
      return new Scaffold(
        appBar: AppBar(
          title: const Text('camera'),
        ),
       body: Center(child: CircularProgressIndicator()),
      );
    }
    return new Container(
      child:AspectRatio(
        aspectRatio:controller.value.aspectRatio,
        child: CameraPreview(controller),
      )
    );
  }
  // 拍照按钮布局
   Widget _takePictureLayout() {
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child:  new IconButton(
          iconSize: 50.0,
          onPressed: onTakePictureButtonPressed,
          icon: Icon(
            Icons.photo_camera,
            color: Colors.white,
          ),
        ),
        
    ));
  }
   Widget testTakeView() {
      return Align(
        alignment:Alignment.center,
        child: Container(
          color: Colors.black87,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
               Positioned(
                left: 15,
                bottom: 20,
                child: RaisedButton(
                 onPressed: (){
                  print("取消");
                },
                child: Text("取消"),
                ),
               ),
              Positioned(
                 bottom: 20,
                 child: IconButton(
                  icon: Icon(Icons.photo_camera,size: 35,color: Colors.white), 
                  onPressed: onTakePictureButtonPressed
                ),
              ),
               Positioned(
                right: 15,
                bottom: 20,
                child: RaisedButton(
                 onPressed: (){
                  print("确定");
                },
                child: Text("确定"),
                ),
               ),
            ],
          ),
        ),

      );
  }
  //拍完预览
  Widget getPhotoPreview() {
    if( null != imagePath){
      return new Container(
        width:double.infinity/2,
        height: double.infinity/2,
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.file(File(imagePath)),
      );
    }else{
      return new Container(
        height: 1.0,
        width: 1.0,
        color: Colors.black,
        alignment: Alignment.bottomLeft,
        child: Text("拍照失败了"),
      );
    }
  }
  /* */
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  Future<String> takePicture() async {
  
    if (!controller.value.isInitialized) {
      print('Error: srelect a camera first.');
      return null;
    }else{
    }
    print("444");
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
       // A capture is already pending, do nothing.
      return null;
    }
    try {

      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      print("e==$e");
       return null;
    }
    return filePath;
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