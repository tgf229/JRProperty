//
//  ShareToSocialControllerService.m
//  CenterMarket
//
//  Created by liugt on 14-8-28.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "ShareToSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "CircleListModel.h"
#import "SVProgressHUD.h"

@interface ShareToSnsService ()
{
    BOOL  _isReuestCircleFinished;    // 我的圈子数据请求是否完成
    BOOL  _isCircleItemSelected;      // 是否选择了分享到圈子
}

@property (nonatomic,weak)   JRViewController  *basedViewController;  // 依赖的controller

@end


@implementation ShareToSnsService

- (void)dealloc
{
}


-(id) init
{
    if (self = [super init]) {
        // 初始化httpRequest和des3Util对象，并设置代理对象
        self.circleArray = [NSArray array];
    }
    return self;
}

- (void)showSocialPlatformIn:(JRViewController *)controller
                  shareTitle:(NSString *)shareTitle
                   shareText:(NSString *)shareText
                    shareUrl:(NSString *)shareUrl
             shareSmallImage:(NSData *)smallImageData
               shareBigImage:(NSData *)bigImageData
            shareFullMessage:(NSString *)fullMessage
              shareToSnsType:(ZYSocialSnsType)platformType
{
    self.basedViewController = controller;
    __weak ShareToSnsService * bself = self;
    UIImage *defaultImage = [UIImage imageNamed:@"community_default.png"];
        
    switch (platformType) {
        case ZYSocialSnsTypeWechat:
        {
            // 微信好友，活动名称、活动描述、活动图片（小图）、活动详情网址
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareText;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = smallImageData ? smallImageData : defaultImage;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    // 分享成功
                    [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];
                    if (bself.delegate && [bself.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
                        [bself.delegate shareToSnsPlatformSuccessed];
                    }
                }
                else if(response.responseCode == UMSResponseCodeCancel){
                    [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:SHARE_FAILED];
                }
                
            }];
            
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = nil;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareText = nil;
            [UMSocialData defaultData].extConfig.wechatSessionData.shareImage=nil;
            [UMSocialData defaultData].extConfig.wechatSessionData.url=nil;
        }
            break;
        case ZYSocialSnsTypeWechatCircle:
        {
            // 微信朋友圈,活动描述、活动图片（小图）、活动详情网址
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = shareText;
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = smallImageData ? smallImageData : defaultImage;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url=shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];
                    if (bself.delegate && [bself.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
                        [bself.delegate shareToSnsPlatformSuccessed];
                    }
                }
                else if(response.responseCode == UMSResponseCodeCancel){
                    [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];

                }
                else{
                    [SVProgressHUD showErrorWithStatus:SHARE_FAILED];
                }
                
            }];
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = nil;
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage=nil;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = nil;
        }
            break;
        case ZYSocialSnsTypeTencentBlog:
        {
            // 腾讯微博：活动描述+活动地址+活动时间+活动详情网址+活动图片（大图）
            if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToTencent]) {
                // 已授权 直接分享到腾讯微博
                [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
            }else{
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        // 授权成功 直接分享到腾讯微博
                        [SVProgressHUD showSuccessWithStatus:AUTHORIZE_SUCCESSFUL];

                        [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                        
                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
                    }
                    else if(response.responseCode == UMSResponseCodeCancel){
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_CANCEL];
                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_FAILED];

                    }
                });
            }
            
        }
            break;
        case ZYSocialSnsTypeQQ:
        {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
            {
                // 未安装qq
                [SVProgressHUD showErrorWithStatus:@"您还未安装QQ，无法打开"];
                return;
            }
            // QQ好友:活动名称、活动描述、活动图片（小图）、活动详情网址
            [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
            [UMSocialData defaultData].extConfig.qqData.shareText = shareText;
            [UMSocialData defaultData].extConfig.qqData.shareImage = smallImageData ? smallImageData : defaultImage;
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];

                    if (bself.delegate && [bself.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
                        [bself.delegate shareToSnsPlatformSuccessed];
                    }
                }
                else if(response.responseCode == UMSResponseCodeCancel){
                    [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:SHARE_FAILED];
                    
                }
                
            }];
        }
            break;
        case ZYSocialSnsTypeQQZone:
        {
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
            {
                // 未安装qq
                [SVProgressHUD showErrorWithStatus:@"您还未安装qq空间，无法打开"];
                return;
            }

            // QQ空间:活动名称、活动描述、活动图片（大图）、活动详情网址
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [UMSocialData defaultData].extConfig.qzoneData.shareText = shareText;
            [UMSocialData defaultData].extConfig.qzoneData.shareImage = bigImageData ? bigImageData : defaultImage;
            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:nil image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];

                    if (bself.delegate && [bself.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
                        [bself.delegate shareToSnsPlatformSuccessed];
                    }
                }
                else if(response.responseCode == UMSResponseCodeCancel){
                    [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];

                }
                else{
                    [SVProgressHUD showErrorWithStatus:SHARE_FAILED];

                }
                
            }];
        }
            break;
        case ZYSocialSnsTypeRenRen:
        {
            // 人人网：活动描述+活动地址+活动时间+活动详情网址+活动图片（大图）
            if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToRenren]) {
                // 已授权 直接分享到人人网
                [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
            }else{
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        // 授权成功 直接分享到人人网
                        [SVProgressHUD showSuccessWithStatus:AUTHORIZE_SUCCESSFUL];

                        [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                        
                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
                    }
                    else if(response.responseCode == UMSResponseCodeCancel){
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_CANCEL];

                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_FAILED];

                    }
                });
            }
            
        }
            break;
        case ZYSocialSnsTypeSms:
        {
            // 短信：活动描述+活动地址+活动时间+活动详情网址
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:fullMessage image:nil location:nil urlResource:nil presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];

                    if (bself.delegate && [bself.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
                        [bself.delegate shareToSnsPlatformSuccessed];
                    }
                }
                else if(response.responseCode == UMSResponseCodeCancel){
                    [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];

                }
                else{
                    [SVProgressHUD showErrorWithStatus:SHARE_FAILED];

                }
            }];
        }
            break;
        case ZYSocialSnsTypeSina:
        {
            // 新浪微博：活动描述+活动地址+活动时间+活动详情网址+活动图片（大图）
            if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
                // 已授权 直接分享到新浪微博
                [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
            }else{
                //进入授权页面
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        // 授权成功 直接分享到新浪微博
                        [SVProgressHUD showSuccessWithStatus:AUTHORIZE_SUCCESSFUL];

                        [[UMSocialControllerService defaultControllerService] setShareText:fullMessage shareImage:bigImageData ? bigImageData : defaultImage socialUIDelegate:self];
                        
                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
                    }
                    else if(response.responseCode == UMSResponseCodeCancel){
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_CANCEL];

                    }
                    else{
                        [SVProgressHUD showErrorWithStatus:AUTHORIZE_FAILED];

                    }
                });
            }
        }
            break;
        default:
            break;
    }
}


#pragma - mark UMSocialUIDelegate
/**
 *  使用直接分享方式
 *
 *  @param response
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        [SVProgressHUD showSuccessWithStatus:SHARE_SUCCESSFUL];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareToSnsPlatformSuccessed)]) {
            [self.delegate shareToSnsPlatformSuccessed];
        }
    }
    else if(response.responseCode == UMSResponseCodeCancel){
        [SVProgressHUD showErrorWithStatus:SHARE_CANCEL];
        
    }
    else{
        [SVProgressHUD showErrorWithStatus:SHARE_FAILED];
        
    }
}

@end
