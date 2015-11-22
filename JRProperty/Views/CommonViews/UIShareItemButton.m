//
//  UIShareSocialButton.m
//  CenterMarket
//
//  Created by liugt on 14-8-28.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "UIShareItemButton.h"
#import "UIColor+extend.h"

NSString *const ShareToCircle = @"圈子";
NSString *const ShareToWechat = @"微信";
NSString *const ShareToWechatTimeline = @"朋友圈";
NSString *const ShareToTencentBlog = @"腾讯微博";
NSString *const ShareToQQ = @"QQ";
NSString *const ShareToQzone = @"QQ空间";
NSString *const ShareToRenren = @"人人网";
NSString *const ShareToSms = @"短信";
NSString *const ShareToSinaBlog = @"微博";


@implementation UIShareItemButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *tempIconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 60, 60)];
        self.iconView = tempIconView;
        [self addSubview:_iconView];
        
        UILabel *tempNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 95, 16)];
        self.nameLabel = tempNameLabel;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor getColor:@"000000"];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
    }
    return self;
}

/**
 *  设置社区button的sns类型
 *
 *  @param snsName sns名称
 */
- (void)setItemButtonType:(NSString *)snsName
{
    if ([snsName isEqualToString:ShareToCircle]) {
        self.type = ZYSocialSnsTypeCircle;
    }
    else if ([snsName isEqualToString:ShareToWechat]){
        self.type = ZYSocialSnsTypeWechat;
    }
    else if ([snsName isEqualToString:ShareToWechatTimeline]){
        self.type = ZYSocialSnsTypeWechatCircle;
    }
    else if ([snsName isEqualToString:ShareToTencentBlog]){
        self.type = ZYSocialSnsTypeTencentBlog;
    }
    else if ([snsName isEqualToString:ShareToQQ]){
        self.type = ZYSocialSnsTypeQQ;
    }
    else if ([snsName isEqualToString:ShareToQzone]){
        self.type = ZYSocialSnsTypeQQZone;
    }
    else if ([snsName isEqualToString:ShareToRenren]){
        self.type = ZYSocialSnsTypeRenRen;
    }
    else if ([snsName isEqualToString:ShareToSms]){
        self.type = ZYSocialSnsTypeSms;
    }
    else if ([snsName isEqualToString:ShareToSinaBlog]){
        self.type = ZYSocialSnsTypeSina;
    }

}

/**
 *  设置社区button的正常和点击状态下的图片名称
 */
- (void)setItemButtonImageName
{
    switch (self.type) {
        case ZYSocialSnsTypeCircle:
            self.normalImgName = @"share_middle_ico_circle";
            self.selectImgName = @"share_middle_ico_circle_select";
            break;
        case ZYSocialSnsTypeWechat:
            self.normalImgName = @"share_middle_ico_wechat";
            self.selectImgName = @"share_middle_ico_wechat_select";
            break;
        case ZYSocialSnsTypeWechatCircle:
            self.normalImgName = @"share_middle_ico_wechatcircle";
            self.selectImgName = @"share_middle_ico_wechatcircle_select";
            break;
        case ZYSocialSnsTypeTencentBlog:
            self.normalImgName = @"share_middle_ico_tencentblog";
            self.selectImgName = @"share_middle_ico_tencentblog_select";
            break;
        case ZYSocialSnsTypeQQ:
            self.normalImgName = @"share_middle_ico_qq";
            self.selectImgName = @"share_middle_ico_qq_select";
            break;
        case ZYSocialSnsTypeQQZone:
            self.normalImgName = @"share_middle_ico_qqzone";
            self.selectImgName = @"share_middle_ico_qqzone_select";
            break;
        case ZYSocialSnsTypeRenRen:
//            self.normalImgName = @"share_middle_ico_renren";
//            self.selectImgName = @"share_middle_ico_renren_select";
            self.normalImgName = @"share_middle_ico_renren_gray"; // 不可用
            self.selectImgName = @"share_middle_ico_renren_gray";
            break;
        case ZYSocialSnsTypeSms:
            self.normalImgName = @"share_middle_ico_sms";
            self.selectImgName = @"share_middle_ico_sms_select";
            break;
        case ZYSocialSnsTypeSina:
//            self.normalImgName = @"share_middle_ico_sinablog";
//            self.selectImgName = @"share_middle_ico_sinablog_select";
            self.normalImgName = @"share_middle_ico_sinablog_gray"; // 不可用
            self.selectImgName = @"share_middle_ico_sinablog_gray";
            break;
        default:
            break;
    }
}

@end
