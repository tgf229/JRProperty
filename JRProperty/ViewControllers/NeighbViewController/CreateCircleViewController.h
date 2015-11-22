//
//  CreateCircleViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里 创建圈子 编辑圈子
#define kCreateCircle     1
#define kEditCircle       2
#import "JRViewController.h"
#import "HPGrowingTextView.h"
#import "CommunityModel.h"


@interface CreateCircleViewController : JRViewControllerWithBackButton<UIScrollViewDelegate,UITextFieldDelegate,HPGrowingTextViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; //底部scrollView
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;       //圈子头像label
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;//圈子icon图片
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;//右侧尖号button
//点击圈子头像触发
- (IBAction)clickIcon:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//圈子名称输入框
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//圈子名称label

@property (weak, nonatomic) IBOutlet UILabel *descLabel;//圈子描述label
@property (weak, nonatomic) IBOutlet HPGrowingTextView *descTextView;//圈子描述输入框

@property (weak, nonatomic) IBOutlet UIView *contentView;//输入区域view

@property (nonatomic ,assign) NSInteger manageType; // 操作类型（1创建 2 编辑）

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeighCon;//输入view高度约束
@property (nonatomic,strong)  CommunityModel  *circleInfo;//圈子model
@end
