//
//  ScanCodeLoginViewController.m
//  scanCodeLogin
//
//  Created by wjwl on 2018/8/14.
//  Copyright © 2018年 wjwl. All rights reserved.
//

#import "ScanCodeLoginViewController.h"
#import "AQNetworkRequest.h"
#import <WechatAuthSDK.h>
#import "AQUserDefaults.h"
#import "NSString+Coding.h"

static NSString *kAccessToken = @"access_token";
static NSString *KAccessExpires_in = @"KAccessExpires_in";
static NSString *kTicket = @"kTicket";
static NSString *KTicketExpires_in = @"KTicketExpires_in";

NSString *const kWXAppID = @"wx0a194d2bed6ab1ae";
NSString *const kWXAppSecret = @"1b8f31188942eca7b2fa2d9bbbc9d0b2";

@interface ScanCodeLoginViewController ()<WechatAuthAPIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) WechatAuthSDK *authSDK;
@end

@implementation ScanCodeLoginViewController
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.authSDK = [[WechatAuthSDK alloc] init];
    self.authSDK.delegate = self;

    [self getAccessToken:^(NSString *token) {
        NSLog(@"%@",token);
        [self loadSDKTicket:token];
    }];
}

- (void)getAccessToken:(void(^)(NSString *token))completHandle {
    
    NSString *token = [AQUserDefaults getStringForKey:kAccessToken];
    if (!token.length) {
        [self getAccessTokenFromNet:completHandle];
    }else {
        NSTimeInterval expires_in = [[AQUserDefaults getStringForKey:KAccessExpires_in] floatValue];
        NSTimeInterval curTimeInterval = [NSDate date].timeIntervalSince1970;
        NSTimeInterval time = curTimeInterval - expires_in;
        if (time > 7100) {
            [self getAccessTokenFromNet:completHandle];
        }else {
            
            completHandle(token);
        }
    }
    
}
- (void)getAccessTokenFromNet:(void(^)(NSString *token))completHandle {
    NSDictionary *dict = @{
                           @"grant_type":@"client_credential",
                           @"appid":kWXAppID,
                           @"secret":kWXAppSecret
                           };
    
    [AQNetworkRequest noCacheRequestWithURL:@"https://api.weixin.qq.com/cgi-bin/token" parameters:dict viewController:nil success:^(id response) {
        [AQUserDefaults setString:response[kAccessToken] forKey:kAccessToken];
        [AQUserDefaults setString:[NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970] forKey:KAccessExpires_in];
        completHandle(response[kAccessToken]);
    } failure:^(NSError *error) {
        
    }];
}
// https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=2
- (void)loadSDKTicket:(NSString *)token {
    
    NSString *ticket = [AQUserDefaults getStringForKey:kTicket];
    if (!ticket.length) {
        [self loadTicketFromNet:token complet:^(NSString *ticket) {
            [self createSignature:ticket];
        }];
    }else {
        NSTimeInterval expires_in = [[AQUserDefaults getStringForKey:KTicketExpires_in] floatValue];
        NSTimeInterval curTimeInterval = [NSDate date].timeIntervalSince1970;
        NSTimeInterval time = curTimeInterval - expires_in;
        if (time > 7100) {
            [self loadTicketFromNet:token complet:^(NSString *ticket) {
                [self createSignature:ticket];
            }];
        }else {
            [self createSignature:ticket];
            
        }
    }
    
}
- (void)loadTicketFromNet:(NSString *)token complet:(void(^)(NSString *ticket))completHandle {
    NSDictionary *dict = @{
                           @"access_token":token,
                           @"type":@(2)
                           };
    [AQNetworkRequest noCacheRequestWithURL:@"https://api.weixin.qq.com/cgi-bin/ticket/getticket" parameters:dict viewController:nil success:^(id response) {
        NSString *ticket = response[@"ticket"];
        [AQUserDefaults setString:ticket forKey:kTicket];
        [AQUserDefaults setString:[NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970] forKey:KTicketExpires_in];
        completHandle(ticket);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createSignature:(NSString *)ticket {
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSince1970];
    NSString *sinStr = [[NSString stringWithFormat:@"appid=%@&noncestr=%@&sdk_ticket=%@&timestamp=%@",kWXAppID,timeStr,ticket,timeStr]sha1];
    // appid=appid&noncestr=noncestr&sdk_ticket=-p3A5zVP95IuafPhzA6lRR95_F9nZEBfJ_n4E9t8ZFWKJTDPOwccVQhHCwDBmvLkayF_jh-m9HOExhumOziDWA&timestamp=1417508194
    NSLog(@"%@",sinStr);
    [self loadQRCode:sinStr timeStamp:timeStr];
}
- (void)loadQRCode:(NSString *)signature timeStamp:(NSString *)timeStamp {
    
    [self.authSDK Auth:kWXAppID nonceStr:timeStamp timeStamp:timeStamp scope:@"snsapi_userinfo," signature:signature schemeData:nil];
    
}
- (void)onAuthGotQrcode:(UIImage *)image {
    self.codeImage.image = image;
}
-(void)onAuthFinish:(int)errCode AuthCode:(NSString *)authCode {
    if (errCode == 0) {
        NSDictionary *dict = @{
                               @"appid":kWXAppID,
                               @"secret":kWXAppSecret,
                               @"code":authCode,
                               @"grant_type":@"authorization_code"
                               };
        [AQNetworkRequest noCacheRequestWithURL:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:dict viewController:nil success:^(id response) {
            NSDictionary *dict = @{
                                   @"unionid" : response[@"unionid"],
                                   @"openid" : response[@"openid"],
                                   @"access_token" : response[@"access_token"]
                                   };
            
            
            [self creatUser:dict];
        } failure:^(NSError *error) {
            
        }];
    }else {
        
    }
}
- (void)onQrcodeScanned {
    
    self.tipLabel.text = @"扫描成功\n请在微信中点击确认即可登录";
}
#pragma mark --创建用户
- (void)creatUser:(NSDictionary *)dict {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"挂掉了");
}
@end
