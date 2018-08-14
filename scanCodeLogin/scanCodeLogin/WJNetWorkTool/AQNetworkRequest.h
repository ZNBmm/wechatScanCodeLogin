//
//  AQNetworkRequest.h
//  zhuawawa
//
//  Created by wjwl on 2017/10/23.
//  Copyright © 2017年 wjwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AQRequestSuccess)(id response);
typedef void (^AQRequestFailure)(NSError *error);
typedef void (^AQHttpProgress)(NSProgress *progress);
/** 请求成功的Block */
typedef void(^AQHttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^AQHttpRequestFailed)(NSError *error);

@interface AQNetworkRequest : NSObject
+ (NSURLSessionTask *)noCacheRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure;
+ (NSURLSessionTask *)requestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure;

+ (NSURLSessionTask *)postRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure;
+ (NSURLSessionTask *)upLoadImageWithURL:(NSString *)url parameters:(NSDictionary *)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType viewController:(UIView*)VCview progress:(AQHttpProgress )progress success:(AQRequestSuccess)success failure:(AQRequestFailure)failure;
@end

