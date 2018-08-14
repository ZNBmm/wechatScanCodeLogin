//
//  AQUserDefaults.m
//  zhuawawa
//
//  Created by wjwl on 2017/10/18.
//  Copyright © 2017年 wjwl. All rights reserved.
//

#import "AQUserDefaults.h"

@implementation AQUserDefaults
+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:value forKey:key];
    [userDefault synchronize];
}
+ (BOOL)getBoolForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault synchronize];
    return [userDefault boolForKey:key];
}
+ (void)setString:(NSString *)str forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:str forKey:key];
    [userDefault synchronize];
}
+ (NSString *)getStringForKey:(NSString *)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault synchronize];
    return [userDefault objectForKey:key];
}
@end
