//
//  FlutteriOSPlugin.m
//  Runner
//
//  Created by Leo on 2020/4/2.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "FlutteriOSPlugin.h"
#import "FlutteriOSTextLabel.h"
#import "FlutterFacotory.h"

@implementation FlutteriOSPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
  //注册插件
  //注册 FlutterIosTextLabelFactory
  //my_flutter_to_native 为flutter 调用此  textLabel 的标识
  [registrar registerViewFactory:[[FlutterFacotory alloc] initWithMessenger:registrar.messenger] withId:@"my_flutter_to_native"];

}
@end
