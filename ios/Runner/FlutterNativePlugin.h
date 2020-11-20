//
//  FlutterNativePlugin.h
//  Runner
//
//  Created by Leo on 2020/5/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterNativePlugin : NSObject <FlutterPlugin>
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

@end

NS_ASSUME_NONNULL_END
