//
//  CircularDetailViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "AnnounceListModel.h"
#import "HPGrowingTextView.h"
#import "AnnounceDetailModel.h"
@interface CircularDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *commentArray;     //  评论数据源
@property (strong, nonatomic) AnnounceModel *announceModel;     // 轮播MODEL
@property (strong, nonatomic) AnnounceDetailModel * announceDetailModel;    // 轮播详细MODEL
@property (strong, nonatomic) UITableViewCell *prototypeCell;   // 初始CELL
@property (weak, nonatomic) IBOutlet UITableView *circularDetailTableView; // 主视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;        // 底部视图
@property (strong, nonatomic) IBOutlet UIView *circularDetailHeadView;  // 通告详情头部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;  // 头部视图高度约束
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;        // 头部图片
@property (weak, nonatomic) IBOutlet UILabel *headViewTitleLabel;       // 头部标题
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;             // 内容
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtonArray; // 底部按钮数组

@property (weak, nonatomic) IBOutlet UIView *keyboardView; // 键盘视图
@property (weak, nonatomic) IBOutlet UIButton *sendButton; // 发送按钮
@property (weak, nonatomic) IBOutlet HPGrowingTextView *CommenInputView; // 评论输入框

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint; // 输入框高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint; // 输入框底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;     // 主视图距顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // 主视图距底部约束


@property (weak, nonatomic) IBOutlet UILabel *commentBumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
- (IBAction)commentBtnClick:(id)sender;

@end
