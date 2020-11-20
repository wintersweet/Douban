//
//  FlutterNativeRegistran.h
//  Runner
//
//  Created by Leo on 2020/6/15.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterNativeRegistran : NSObject<FlutterPlugin>
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry;

@end

NS_ASSUME_NONNULL_END
