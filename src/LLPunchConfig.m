//
//  LLPunchConfig.m
//  test2
//
//  Created by fqb on 2017/12/22.
//  Copyright © 2017年 kevliule. All rights reserved.
//

#import "LLPunchConfig.h"

static NSString * const kLLIsOpenPunchHelperKey = @"LLIsOpenPunchHelper";
static NSString * const kLLIsLocationPunchModeKey = @"LLIsLocationPunchMode";
static NSString * const kLLWifiNameKey = @"LLWifiName";
static NSString * const kLLWifiMacIpKey = @"LLWifiMacIp";
static NSString * const kLLAccuracyKey = @"LLAccuracy";
static NSString * const kLLLatitudeKey = @"LLLatitude";
static NSString * const kLLLongitudeKey = @"LLLongitude";

@implementation LLPunchConfig

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _isOpenPunchHelper = [coder decodeBoolForKey:kLLIsOpenPunchHelperKey];
        _isLocationPunchMode = [coder decodeBoolForKey:kLLIsLocationPunchModeKey];
        _wifiName = [[coder decodeObjectForKey:kLLWifiNameKey] copy];
        _wifiMacIp = [[coder decodeObjectForKey:kLLWifiMacIpKey] copy];
        _accuracy = [[coder decodeObjectForKey:kLLAccuracyKey] copy];
        _latitude = [[coder decodeObjectForKey:kLLLatitudeKey] copy];
        _longitude = [[coder decodeObjectForKey:kLLLongitudeKey] copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:_isOpenPunchHelper forKey:kLLIsOpenPunchHelperKey];
    [coder encodeBool:_isLocationPunchMode forKey:kLLIsLocationPunchModeKey];
    [coder encodeObject:_wifiName forKey:kLLWifiNameKey];
    [coder encodeObject:_wifiMacIp forKey:kLLWifiMacIpKey];
    [coder encodeObject:_accuracy forKey:kLLAccuracyKey];
    [coder encodeObject:_latitude forKey:kLLLatitudeKey];
    [coder encodeObject:_longitude forKey:kLLLongitudeKey];
}

- (id)copyWithZone:(nullable NSZone *)zone{
    LLPunchConfig *config = [[[self class] alloc] init];
    config.isOpenPunchHelper = self.isOpenPunchHelper;
    config.isLocationPunchMode = self.isLocationPunchMode;
    config.wifiName = self.wifiName;
    config.wifiMacIp = self.wifiMacIp;
    config.accuracy = self.accuracy;
    config.latitude = self.latitude;
    config.longitude = self.longitude;
    return config;
}

#pragma mark - SET METHOD

//- (void)setIsOpenPunchHelper:(BOOL)isOpenPunchHelper{
//    _isOpenPunchHelper = isOpenPunchHelper;
//}
//
//- (void)setIsLocationPunchMode:(BOOL)isLocationPunchMode{
//    _isLocationPunchMode = isLocationPunchMode;
//}
//
//- (void)setWifiName:(NSString *)wifiName{
//    _wifiName = [wifiName copy];
//}
//
//- (void)setWifiMacIp:(NSString *)wifiMacIp{
//    _wifiMacIp = [wifiMacIp copy];
//}
//
//- (void)setAccuracy:(NSString *)accuracy{
//    _accuracy = [accuracy copy];
//}
//
//- (void)setLatitude:(NSString *)latitude{
//    _latitude = [latitude copy];
//}
//
//- (void)setLongitude:(NSString *)longitude{
//    _longitude = [longitude copy];
//}

@end
