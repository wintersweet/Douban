import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
//  let winodw = UIWindow?.self
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  
//    window = UIWindow.init(frame: UIScreen.main.bounds)
//    let vc = MainViewController.init()
//    let naviVc = UINavigationController.init(rootViewController: vc)
//    window.rootViewController = naviVc
//    window.makeKeyAndVisible()
   
    GeneratedPluginRegistrant.register(with: self)
//    FlutterIosTextLabelRegistran.register(with: self)
//    FlutterNativeRegistran.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
