//
//  EditUserInfoViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-30.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里 设置个人信息

#import "JRViewController.h"
#import "HPGrowingTextView.h"

@interface EditUserInfoViewController : JRViewControllerWithBackButton<HPGrowingTextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView; //输入区域view
@property (weak, nonatomic) IBOutlet HPGrowingTextView *inputView;//输入框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heihtCon;//输入区域view的高度约束
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//昵称输入框

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraint;//输入区域view距离顶部的距离约束（解决系统不同造成的位置偏移）

@property (strong ,nonatomic) NSString *nickName;//昵称（上页面传递）
@property (strong ,nonatomic) NSString *desc;//签名（上页面传递）


@end
