//
//  TestViewController.m
//  Runner
//
//  Created by Leo on 2020/5/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "TestViewController.h"
#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface TestViewController () <FlutterStreamHandler>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 50, 20);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)backEvent {
//    [self checkImageType];

}

- (void)pushFlutterViewController_EventChannel {
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    flutterViewController.navigationItem.title = @"Demo";
    [flutterViewController setInitialRoute:@"home"];
    // 要与main.dart中一致
    NSString *channelName = @"com.pages.your/native_post";

    FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:flutterViewController];
    // 代理FlutterStreamHandler
    [evenChannal setStreamHandler:self];

    [self.navigationController pushViewController:flutterViewController animated:YES];
}

#pragma mark - <FlutterStreamHandler>
// // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (events) {
        events(@"push传值给flutter的vc");
    }
    return nil;
}

/// flutter不再接收
- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    NSLog(@"%@", arguments);
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self pushFlutterViewController_EventChannel];
}

- (void)checkImageType {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        //没有授权
        if (status == PHAuthorizationStatusRestricted) {
        } else if (status == PHAuthorizationStatusDenied) {
        } else {//已经授权
            [self showAlbum];
        }
    }];
}

- (void)showAlbum { //hiec图片格式转换
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetMediaType type =  PHAssetMediaTypeImage;

    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:type options:option];
    __weak typeof(self) weakSelf = self;
    __strong typeof(weakSelf) strongSelf = weakSelf;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            NSInteger type = asset.mediaType;
            [assets addObject:asset];
        }];
        __block BOOL isHEIF = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *resourceList = [PHAssetResource assetResourcesForAsset:assets[0]];
            [resourceList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                PHAssetResource *resource = obj;
                NSString *UTI = resource.uniformTypeIdentifier;
                if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
                    isHEIF = YES;
                    *stop = YES;
                }
            }];
            [[PHImageManager defaultManager] requestImageDataForAsset:assets[0] options:nil resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
                if (isHEIF) {
                    CIImage *ciImage = [CIImage imageWithData:imageData];
                    CIContext *context = [CIContext context];
                    NSData *jpgData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
                }
            }];
        });
    });
}

@end
