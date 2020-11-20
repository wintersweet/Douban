//
//  MainViewController.m
//  Runner
//
//  Created by Leo on 2020/5/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "GeneratedPluginRegistrant.h"
/** 信号通道，须与flutter里一致*/
#define flutterMethodChannel  @"flutter_native_ios"
/** 交互方法字段名，须与flutter里一致*/
#define flutterMethodPush  @"flutter_push_to_ios"
#define flutterMethodPresent  @"flutter_present_to_ios"


@interface MainViewController ()

@property(nonatomic,strong) FlutterMethodChannel* methodChannel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self methodChannelFunction];
}
- (void)methodChannelFunction {
    //创建 FlutterMethodChannel
    self.methodChannel = [FlutterMethodChannel
                          methodChannelWithName:flutterMethodChannel binaryMessenger:self];
    //设置监听
    __weak typeof(self) weakSelf = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // TODO
        NSString *method=call.method;
        if ([method isEqualToString:flutterMethodPush]) {
            TestViewController *vc = [[TestViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            //此方法只能调用一次
            result(@"push返回到flutter");
        }else if ([method isEqualToString:flutterMethodPresent]) {
            TestViewController *vc = [[TestViewController alloc] init];
            [weakSelf presentViewController:vc animated:NO completion:nil];
            //此方法只能调用一次
            result(@"present返回到flutter");
        }
        
    }];
    [GeneratedPluginRegistrant registerWithRegistry:self];
}
- (void)pushFlutterViewController {
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    [flutterViewController setInitialRoute:@"myApp"];
    
    __weak __typeof(self) weakSelf = self;

    // 要与main.dart中一致
    
    NSString *channelName = flutterMethodChannel;
    
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterViewController];
    
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        // call.method 获取 flutter 给回到的方法名，要匹配到 channelName 对应的多个 发送方法名，一般需要判断区分
        // call.arguments 获取到 flutter 给到的参数，（比如跳转到另一个页面所需要参数）
        // result 是给flutter的回调， 该回调只能使用一次
        NSLog(@"method=%@ \narguments = %@", call.method, call.arguments);
        
        // method和WKWebView里面JS交互很像
        if ([call.method isEqualToString:@"iOSFlutter"]) {
            TestViewController *vc = [[TestViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([call.method isEqualToString:@"iOSFlutter1"]) {
            NSDictionary *dic = call.arguments;
            NSLog(@"arguments = %@", dic);
            NSString *code = dic[@"code"];
            NSArray *data = dic[@"data"];
            NSLog(@"code = %@", code);
            NSLog(@"data = %@",data);
            NSLog(@"data 第一个元素%@",data[0]);
            NSLog(@"data 第一个元素类型%@",[data[0] class]);
            
        }
        if ([call.method isEqualToString:@"iOSFlutter2"]) {
            if (result) {
                // iOSFlutter2 对应的方法flutter中主动出发 并且将下面的值（Native的值）传给flutter
                result(@"这里传值给flutter kongzichixiangjiao");
            }
        }
    }];
    
    [self.navigationController pushViewController:flutterViewController animated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self pushFlutterViewController];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
