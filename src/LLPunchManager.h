//
//  LLPunchManager.h
//  test2
//
//  Created by fqb on 2017/12/21.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLPunchConfig.h"

@interface LLPunchManager : NSObject

@property (nonatomic, strong) LLPunchConfig *punchConfig; //打卡配置

+ (LLPunchManager *)shared;

//归档保存用户设置
- (void)saveUserSetting:(LLPunchConfig *)config;

//获取SSID信息
- (NSDictionary *)SSIDInfo;

//是否有定位权限
- (BOOL)isLocationAuth;

//显示提示消息
- (void)showMessage:(NSString *)message completion:(void(^)(BOOL isClickConfirm))completion;

//跳转到系统wifi列表
- (void)jumpToWifiList;

@end
