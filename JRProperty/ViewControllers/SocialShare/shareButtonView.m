//
//  shareButtonView.m
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "shareButtonView.h"
#import "UIColor+extend.h"
#import "JRDefine.h"

@implementation shareButtonView

- (IBAction)shareWeixinClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialButton:)]) {
        [_delegate didSelectSocialButton:ZYSocialSnsTypeWechat];
    }
}

- (IBAction)shareFriendClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialButton:)]) {
        [_delegate didSelectSocialButton:ZYSocialSnsTypeWechatCircle];
    }
}

- (IBAction)shareSinaClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialButton:)]) {
        [_delegate didSelectSocialButton:ZYSocialSnsTypeSina];
    }
}

- (IBAction)shareQQClcik:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialButton:)]) {
        [_delegate didSelectSocialButton:ZYSocialSnsTypeQQ];
    }
}

- (IBAction)shareKongjianClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialButton:)]) {
        [_delegate didSelectSocialButton:ZYSocialSnsTypeQQZone];
    }
}

- (void)initial {
    self.backgroundColor = [UIColor getColor:@"f8f8f8"];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.backgroundColor = [UIColor getColor:@"f8f8f8"];
    if (CURRENT_VERSION<8) {
        self.scrollView.contentSize = CGSizeMake(366,73);
    }
    else {
        self.scrollView.contentSize = CGSizeMake(366,73);
    }
    self.scrollView.scrollEnabled=YES;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
 
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.weiboLabel.textColor = [UIColor getColor:@"444444"];
     self.wenxinLabel.textColor = [UIColor getColor:@"444444"];
    self.qqLabel.textColor = [UIColor getColor:@"444444"];
     self.kongjianLabel.textColor = [UIColor getColor:@"444444"];
     self.friendLabel.textColor = [UIColor getColor:@"444444"];
}

@end
