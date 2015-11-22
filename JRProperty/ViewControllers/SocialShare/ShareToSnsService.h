//
//  ShareToSocialControllerService.h
//  CenterMarket
//
//  Created by liugt on 14-8-28.
//  Copyright (c) 2014年 yurun. All rights reserved.
//
//  分享到第三方平台的服务类

#import <Foundation/Foundation.h>
#import "PopSocialShareView.h"
#import "JRViewController.h"
#import "UMSocialControllerService.h"
#import "ShareView.h"

@protocol ShareToSnsServiceDelegate<NSObject>

@optional
/**
 *  成功分享到社区
 */
- (void)shareToSnsPlatformSuccessed;

@end

@interface ShareToSnsService : NSObject<UMSocialUIDelegate>

@property (nonatomic,copy) NSString  *actID;
@property (nonatomic,copy) NSString  *skuID;
@property (nonatomic,copy) NSArray   *circleArray;
@property (nonatomic,weak) id<ShareToSnsServiceDelegate> delegate;

/**
 *  打开分享编辑页面
 *
 *  @param controller   所在控制器
 *  @param shareTitle   分享的标题
 *  @param shareText    分享内容
 *  @param shareUrl     分享地址
 *  @param smallImageData    分享小图
 *  @param bigImageData 分享大图
 *  @param fullMessage  分享的全拼内容
 *  @param platformType 分享平台
 */
- (void)showSocialPlatformIn:(JRViewController *)controller
                  shareTitle:(NSString *)shareTitle
                   shareText:(NSString *)shareText
                    shareUrl:(NSString *)shareUrl
             shareSmallImage:(NSData *)smallImageData
               shareBigImage:(NSData *)bigImageData
            shareFullMessage:(NSString *)fullMessage
              shareToSnsType:(ZYSocialSnsType)platformType;
@end
