//
//  AQNetworkRequest.m
//  zhuawawa
//
//  Created by wjwl on 2017/10/23.
//  Copyright © 2017年 wjwl. All rights reserved.
//

#import "AQNetworkRequest.h"
#import "AQNetWorkHelper.h"
@implementation AQNetworkRequest
+ (NSURLSessionTask *)noCacheRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure{
    
    return [AQNetWorkHelper GET:url parameters:parameter success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
+ (NSURLSessionTask *)requestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure{
    
    return [AQNetWorkHelper GET:url parameters:parameter responseCache:^(id responseCache) {
        success(responseCache);
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
+ (NSURLSessionTask *)postRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameter viewController:(UIView*)VCview success:(AQRequestSuccess)success failure:(AQRequestFailure)failure{
    
    return [AQNetWorkHelper POST:url parameters:parameter responseCache:^(id responseCache) {
        success(responseCache);
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}
+ (NSURLSessionTask *)upLoadImageWithURL:(NSString *)url parameters:(NSDictionary *)parameters name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType viewController:(UIView*)VCview progress:(AQHttpProgress )progress success:(AQRequestSuccess)success failure:(AQRequestFailure)failure {
    return [AQNetWorkHelper uploadImagesWithURL:url parameters:parameters name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progress:^(NSProgress *progressdd) {
        progress(progressdd);
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
// http://118.31.164.217:9001/get_post_info?account=wx_oRDXAwINN28aWwB-hcMia8n1RWtA&orderid=BK1510305202292797256

