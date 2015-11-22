//
//  PropertyServiceCommonPostViewController.h
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
@interface PropertyServiceCommonPostViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
//    NSArray *houseTableViewDataSourceArray;
}
@property (strong,nonatomic) dispatch_block_t propertyServiceCommentSuccessBlock;  // 意见反馈成功事件

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;      // 物业服务主视图

@property (weak, nonatomic) IBOutlet UILabel *houseAddressLabel;        // 房屋地址label
@property (weak, nonatomic) IBOutlet UIButton *selectHouseButton;       // 选择房屋按钮
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;       // 当前绑定房屋列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseTableViewHeightConstraint;    // 房屋列表高度约束

@property (weak, nonatomic) IBOutlet UILabel *contentPlaceholderLabel;      // 内容提示信息
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;           // 内容输入框
@property (weak, nonatomic) IBOutlet UILabel *wordsSumNumLabel;             // 字数统计


@property (weak, nonatomic) IBOutlet UIView *uploadImageView;               // 上传图片视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageViewHeightConstraint;   // 上传图片视图高度约束

@property (weak, nonatomic) IBOutlet UIButton *addImageViewButton;          // 添加图片按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonLeftConstraint;   // 添加图片按钮距左约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonTopConstraint;    // 添加图片按钮距顶部约束

@property (weak, nonatomic) IBOutlet UIView *addImageInfoView;              // 上传图片提示信息
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;                   // 上传图片提示信息1
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;                   // 上传图片提示信息2
@property (weak, nonatomic) IBOutlet UILabel *imageViewNumLabel;            // 上传图片统计张数


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;    // 底部视图高度约束
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;                      // 底部视图背景图片
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;                                 // 底部提示信息

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;                 // 主视图距顶部距离约束


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonWidthConstraint; // 添加图片按钮宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImageButtonHeightConstraint;// 添加图片按钮高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewWidthConstraint;       // 图片上传视图宽度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightConstraint;      // 图片上传视图高度约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadImageViewBottomHeightConstraint; // 上传图片视图距底部约束

@end
