//
//  FlutterFacotory.h
//  Runner
//
//  Created by Leo on 2020/4/2.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlutteriOSTextLabel.h"
#import <Flutter/Flutter.h>


@interface FlutterFacotory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;

@end


