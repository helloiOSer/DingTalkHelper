//
//  LLPunchManager.m
//  test2
//
//  Created by fqb on 2017/12/21.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLPunchManager.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>

#define kArchiverFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"LLPunchManager"]

#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

@implementation LLPunchManager

+ (LLPunchManager *)shared{
    static LLPunchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LLPunchManager alloc] init];
    });
    return manager;
}

- (id)init{
    if (self = [super init]) {
        NSData *data = [NSData dataWithContentsOfFile:kArchiverFilePath];
//        [self showMessage:[NSString stringWithFormat:@"%@",data] completion:nil];
//        return self;
        @try{
        if(!(self.punchConfig = [NSKeyedUnarchiver unarchiveObjectWithData:data])){
            self.punchConfig = [[LLPunchConfig alloc] init];
        }
        }  @catch (NSException *exception) {
            
            return self;
            
        }
    }
    return self;
}

//- (id)init{
//    if (self = [super init]) {
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        _isOpenPunchHelper = [userDefaults boolForKey:kLLIsOpenPunchHelperKey];
//        _isLocationPunchMode = [userDefaults boolForKey:kLLIsLocationPunchModeKey];
//        _wifiName = [userDefaults stringForKey:kLLWifiNameKey];
//        _wifiMacIp = [userDefaults stringForKey:kLLWifiMacIpKey];
//        _accuracy = [userDefaults stringForKey:kLLAccuracyKey];
//        _latitude = [userDefaults stringForKey:kLLLatitudeKey];
//        _longitude = [userDefaults stringForKey:kLLLongitudeKey];
//    }
//    return self;
//}

//归档保存用户设置
- (void)saveUserSetting:(LLPunchConfig *)config{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kArchiverFilePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:kArchiverFilePath error:&error];
        if (error) {
            [self showMessage:[NSString stringWithFormat:@"%@",error] completion:nil];
            return;
        }
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
    if ([data writeToFile:kArchiverFilePath atomically:YES]) {
        _punchConfig = config;
    } else {
        [self showMessage:@"保存失败" completion:nil];
    }
}

//获取SSID信息
- (NSDictionary *)SSIDInfo
{
    NSArray *ifs = (NSArray *)CFBridgingRelease(CNCopySupportedInterfaces());
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (NSDictionary *)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

//是否有定位权限
- (BOOL)isLocationAuth{
    return ![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied ? NO : YES;
}

//显示提示消息
- (void)showMessage:(NSString *)message completion:(void(^)(BOOL isClickConfirm))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(YES);
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(NO);
        }
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

//跳转到系统wifi列表
- (void)jumpToWifiList{
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if (iOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}


@end
