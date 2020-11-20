//
//  FlutterNativeRegistran.m
//  Runner
//
//  Created by Leo on 2020/6/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutterNativeRegistran.h"
#import "FlutteriOSPlugin.h"
@implementation FlutterNativeRegistran
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry{
    //注册插件
    [FlutteriOSPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNativeRegistran"]];
}

@end
