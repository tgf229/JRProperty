//
//  UIShareSocialButton.h
//  CenterMarket
//
//  Created by liugt on 14-8-28.
//  Copyright (c) 2014年 yurun. All rights reserved.
//
//  分享选择视图的社区按钮，带有社区图标和名称

#import <UIKit/UIKit.h>

extern NSString *const ShareToCircle; // 中央商场圈子

extern NSString *const ShareToWechat; // 微信好友

extern NSString *const ShareToWechatTimeline; // 微信朋友圈

extern NSString *const ShareToTencentBlog; // 腾讯微博

extern NSString *const ShareToQQ; // 手机QQ

extern NSString *const ShareToQzone; // QQ空间

extern NSString *const ShareToRenren; // 人人网

extern NSString *const ShareToSms; // 短信

extern NSString *const ShareToSinaBlog; // 新浪微博

typedef enum {
    ZYSocialSnsTypeNone = 0,
    ZYSocialSnsTypeCircle = 10,
    ZYSocialSnsTypeWechat = 11,
    ZYSocialSnsTypeWechatCircle = 12,
    ZYSocialSnsTypeTencentBlog = 13,
    ZYSocialSnsTypeQQ = 14,
    ZYSocialSnsTypeQQZone = 15,
    ZYSocialSnsTypeRenRen = 16,
    ZYSocialSnsTypeSms = 17,
    ZYSocialSnsTypeSina = 18
} ZYSocialSnsType;

@interface UIShareItemButton : UIButton

@property (nonatomic,strong)  UIImageView *iconView;      // 分享的社区图标
@property (nonatomic,strong)  UILabel     *nameLabel;     // 分享的社区名称
@property (nonatomic,assign)  ZYSocialSnsType type;       //社区类型
@property (nonatomic,copy)    NSString    *normalImgName; //普通状态下的图片名
@property (nonatomic,copy)    NSString    *selectImgName; //点击状态下的图片名

/**
 *  设置社区button的sns类型
 *
 *  @param snsName sns名称
 */
- (void)setItemButtonType:(NSString *)snsName;

/**
 *  设置社区button的正常和点击状态下的图片名称
 */
- (void)setItemButtonImageName;
@end
