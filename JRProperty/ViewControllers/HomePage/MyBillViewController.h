//
//  MyBillViewController.h
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
#import "AccountManageViewController.h"
#import "PaymentSlipViewController.h"
@interface MyBillViewController : JRViewControllerWithBackButton

@property (strong, nonatomic) AccountManageViewController *accountManageVC; // 账单管理
@property (strong, nonatomic) PaymentSlipViewController *paymentSlipVC;     // 缴费清单
@property (strong, nonatomic) UIViewController *currentVC;                  // 当前展示视图


@property (weak, nonatomic) IBOutlet UIButton *accountManageButton;     // 账单管理按钮
@property (weak, nonatomic) IBOutlet UIButton *paymentSlipButton;       // 好、账单列表按钮
@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;       // 滑动图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideImageViewLeftLayoutConstraint;                                 // 滑动图片左侧约束
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint; // 主视图顶部约束

@property (strong, nonatomic) IBOutlet UIView *tabView;

@end
