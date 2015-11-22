//
//  PopShareBtnView.h
//  SinaDonghua
//
//  Created by qug on 14-8-6.
//  Modified by liugt on 14-8-18
//  Copyright (c) 2014年 ysb. All rights reserved.
//
//  有抖动动画效果的分享页面

#import <UIKit/UIKit.h>
#import "UIShareItemButton.h"

#define SHARE_SUCCESSFUL   @"分享成功"
#define SHARE_CANCEL       @"取消分享"
#define SHARE_FAILED       @"分享失败"
#define AUTHORIZE_SUCCESSFUL   @"授权成功，请继续分享"
#define AUTHORIZE_CANCEL       @"取消授权"
#define AUTHORIZE_FAILED       @"授权失败"

@protocol PopSocialShareViewDelegate <NSObject>

/**
 *  点击社交平台
 *
 *  @param ZYSocialSnsType 社交平台类型
 */
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType;

@end

@interface PopSocialShareView : UIView{
    
}

@property (nonatomic,weak) id<PopSocialShareViewDelegate>   delegate;
@property (nonatomic,copy)  NSString                        *articleID;


/**
 *  根据传入的sns平台数组展示
 *
 *  @param frame       view的frame
 *  @param socialArray sns平台数组，包括：ShareToCircle,ShareToWechat,ShareToWechatTimeline,ShareToTencentBlog,ShareToQQ,
 *  ShareToQzone,ShareToRenren,ShareToSms,ShareToSinaBlog
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame snsArray:(NSArray *)socialArray;

/**
 *  移除社区分享视图，带有移动动画；
 *  社区按钮和关闭按钮参与动画，背景按钮不做移动
 */
- (void)removeShareSubView;

@end
