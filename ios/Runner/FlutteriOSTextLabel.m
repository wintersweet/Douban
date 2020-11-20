//
//  FlutteriOSTextLabel.m
//  Runner
//
//  Created by Leo on 2020/4/2.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutteriOSTextLabel.h"

@implementation FlutteriOSTextLabel{
  int64_t _viewId;
  UILabel * _uiLabel;
  //消息回调
  FlutterMethodChannel* _channel;
  FlutterEventChannel * _event;
  
}
//在这里只是创建了一个UILabel
-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        if (frame.size.width==0) {
            frame=CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 22);
        }
        _uiLabel =[[UILabel alloc] initWithFrame:frame];
        _uiLabel.textColor = [UIColor redColor];
        _uiLabel.text = @"iOS 原生的 ";
        _uiLabel.font = [UIFont systemFontOfSize:20];
        _uiLabel.textAlignment=NSTextAlignmentCenter;
        _uiLabel.backgroundColor = [UIColor cyanColor];
        
        _viewId = viewId;
        NSDictionary *dic = args;
        NSString *conten = dic[@"content"];
        if (conten!=nil) {
          _uiLabel.text = conten;
        }
        // 注册flutter 与 ios 通信通道
        NSString* channelName = [NSString stringWithFormat:@"my_flutter_to_native_%lld", viewId];
        NSLog(@"频道名字 =%@",channelName);

        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];

    
    }
    return self;
    
}
-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    if ([[call method] isEqualToString:@"updateText"]) {
    NSLog(@"回调的方法名 =%@",[call method]);
    //获取参数
    NSDictionary *dict = call.arguments;
    NSLog(@"回调的dict =%@",dict);
    NSString *content = dict[@"key"];
    if (content!=nil) {
        _uiLabel.text = content;
    }
    }else{
        //其他方法的回调
    }
}
-(void)sendMessage
{
}
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    self.eventSink = eventSink;
    return nil;
}/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    self.eventSink = nil;
    return nil;
}
- (nonnull UIView *)view {
    return _uiLabel;
}

@end
