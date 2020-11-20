//
//  FlutterNativePlugin.m
//  Runner
//
//  Created by Leo on 2020/5/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutterNativePlugin.h"

@implementation FlutterNativePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{

    [FlutterNativePlugin registerWithRegistrar:registrar];

    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"com.xxx.xxx" binaryMessenger:[registrar messenger]];
    FlutterNativePlugin *instance = [[FlutterNativePlugin alloc]init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if ([@"isChinese" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:YES]);
    }else if([@"reportErrorMethod" isEqualToString:call.method]){
        //flutter传给原生的参数
        NSString * para = call.arguments;
        if (para.length != 0) {
            //OC传参给Flutter
            result([NSString stringWithFormat:@"从原生返回过来的==>%@",para]);
        }else{
      //向flutter抛出异常
        result([FlutterError errorWithCode:@"404" message:[NSString stringWithFormat:@"我是异常信息"] details:@"我是异常描述"]);
        }
    }else{
        result (FlutterMethodNotImplemented);
    }
}
@end
