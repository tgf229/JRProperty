//
//  ShareView.m
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "ShareView.h"
#import "JRDefine.h"
#import "UIColor+extend.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // self.automaticallyAdjustsScrollViewInsets = NO;

    }
    return self;
}

- (id)initViewIsAdmin:(BOOL)isAdmin isCreator:(BOOL)isCreator isTop:(BOOL)isTop {
    if (self = [super init]) {
        if (CURRENT_VERSION <7) {
            self.frame = CGRectMake(0, UIScreenHeight-282, UIScreenWidth, 282);
        }
        else {
            self.frame = CGRectMake(0, UIScreenHeight-282, UIScreenWidth, 282);
        }
        self.backgroundColor = [UIColor whiteColor];
        UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 233)];
        upView.backgroundColor = [UIColor getColor:@"f8f8f8"];
        [self addSubview:upView];
        self.shareButtonView = [[[NSBundle mainBundle] loadNibNamed:@"shareButtonView" owner:self options:nil]objectAtIndex:0];
        self.shareButtonView.frame = CGRectMake(0, 0, UIScreenWidth, 127);
        [self.shareButtonView initial];
       
        self.shareButtonView.delegate = self;
        [self addSubview:self.shareButtonView];
        self.operationView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleOperationView" owner:self options:nil]objectAtIndex:0];
        self.operationView.frame = CGRectMake(0, 128, UIScreenWidth, 106);
        [self.operationView initialIsAdmin:isAdmin isCreator:isCreator isTop:isTop];
        self.operationView.delegate = self;
        [self addSubview:self.operationView];
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(0,233,UIScreenWidth,49);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor getColor:@"000000"] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelButton addTarget:self action:@selector(dismissPage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)show
{
    UIWindow *shareWindow = [UIApplication sharedApplication].keyWindow;
    // 阴影
    UIView * shadeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreenWidth, UIScreenHeight)];
    shadeView.backgroundColor = [UIColor blackColor];
    shadeView.alpha = 0.6;
    self.shadeView = shadeView;
    shadeView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPage)];
    [shadeView addGestureRecognizer:singleTap];
    
    [shareWindow addSubview:shadeView];
    [shareWindow addSubview:self];
}

/**
 *  去除页面
 */
- (void)dismissPage {
    [self.shadeView removeFromSuperview];
    [self removeFromSuperview];
}
/**
 *  分享
 */
- (void)didSelectSocialButton:(ZYSocialSnsType)platformType {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialPlatform:)]) {
        [_delegate didSelectSocialPlatform:platformType];
    }
}
/**
 *  话题操作
 */
- (void)didSelectOperationButton:(ArticleOperationType)operationType {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:operationType];
    }
}
@end
