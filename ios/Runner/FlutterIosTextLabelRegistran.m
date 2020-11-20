//
//  FlutterIosTextLabelRegistran.m
//  Runner
//
//  Created by Leo on 2020/4/2.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutterIosTextLabelRegistran.h"
#import "FlutteriOSPlugin.h"
@implementation FlutterIosTextLabelRegistran
+(void)registerWithRegistry:(NSObject<FlutterPluginRegistry> *)registry{
    //注册插件
    [FlutteriOSPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutteriOSPlugin"]];
}

@end
