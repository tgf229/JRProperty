//
//  ArticleDetailViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里 话题详情页面

#import "JRViewController.h"
#import "ArticleListModel.h"
#import "ArticleDetailHeadView.h"
#import "HPGrowingTextView.h"
#import "PhotosViewController.h"
#import "CommentTableViewCell.h"
#import "ArticleBottomView.h"
@interface ArticleDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,ArticleHeadViewDelegate,UITextViewDelegate,HPGrowingTextViewDelegate,UIAlertViewDelegate,PhotosViewDatasource,PhotosViewDelegate,CommentTableViewCellDelegate,ArticleBottomViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView; //tableview
@property (weak, nonatomic) IBOutlet UIView *keyboardView;//输入区域view
@property (weak, nonatomic) IBOutlet UIButton *sendButton;//发送按钮
@property (weak, nonatomic) IBOutlet HPGrowingTextView *CommenInputView;//评论输入框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContraint;//输入区域距离屏幕底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomContraint;//tableview距离屏幕底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightContraint;//输入区域高度约束


@property (strong,nonatomic) ArticleDetailModel *articleDetailModel;//话题model
@property (strong,nonatomic) NSString  *articleId;//话题id
@property (assign,nonatomic) BOOL       onlyComment;
@property (assign,nonatomic) BOOL       onlyOfficial;
@end
