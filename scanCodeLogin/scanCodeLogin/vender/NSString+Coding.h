//
//  NSString+Coding.h
//  yisuixing
//
//  Created by John on 15/6/29.
//  Copyright (c) 2015年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface NSString (Coding)

-(NSString *)sha1;
- (NSString *)sha1_base64;
-(NSString *)md5;
- (NSString *)md5_base64;
- (NSString *)base64;

@end
