//
//  MyWorkOrderCommentViewController.h
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
@interface MyWorkOrderCommentViewController : JRViewControllerWithBackButton<UITextViewDelegate,UIActionSheetDelegate>
@property (strong,nonatomic) dispatch_block_t workOrderCommentSuccessBlock;  // 评论成功事件



@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollerView;        // 评论主视图
@property (strong, nonatomic) NSString * workID;                            // 工单号
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *commonTypeButtonArray;  // 评论类型按钮数组
@property (weak, nonatomic) IBOutlet UILabel *commonPlaceHolderLabel;       // 评论提示信息
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;           // 评论文本输入框
@property (weak, nonatomic) IBOutlet UILabel *commentWordsNumLabel;         // 评论字数统计

@property (weak, nonatomic) IBOutlet UIView *uploadImageView;               // 上传图片视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageViewHeightConstraint;   // 上传图片视图高度约束
@property (weak, nonatomic) IBOutlet UIButton *addImageViewButton;          // 添加图片按钮
@property (weak, nonatomic) IBOutlet UIView *imageInfoView;                 // 上传图片提示信息
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;                   // 上传图片提示信息1
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;                   // 上传图片提示信息2
@property (weak, nonatomic) IBOutlet UILabel *imageViewNumLabel;            // 上传图片统计张数


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonLeftConstraint;   // 添加按钮右边约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonTopConstraint;    // 添加按钮顶部约束

@property (weak, nonatomic) IBOutlet UIView *addImageInfoView;      // 上传图片提示信息视图

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;  // 底部视图背景图片

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint; // 主视图距顶部约束

@property (weak, nonatomic) IBOutlet UIButton *highLeverButton;
@property (weak, nonatomic) IBOutlet UIView *middleLeverButton;
@property (weak, nonatomic) IBOutlet UIView *lowLeverButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonHeightConstraint;    // 添加图片按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonWidthConstraint;     // 添加图片按钮宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightConstraint;          // 图片上传视图高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewWidthConstraint;           // 图片上传视图宽度约束


@end
