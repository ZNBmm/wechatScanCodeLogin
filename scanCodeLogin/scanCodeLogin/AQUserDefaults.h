//
//  AQUserDefaults.h
//  zhuawawa
//
//  Created by wjwl on 2017/10/18.
//  Copyright © 2017年 wjwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQUserDefaults : NSObject
+ (void)setBool:(BOOL)value forKey:(NSString *)key;
+ (BOOL)getBoolForKey:(NSString *)key;
+ (NSString *)getStringForKey:(NSString *)key;
+ (void)setString:(NSString *)str forKey:(NSString *)key;
@end
