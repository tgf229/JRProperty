//
//  CircleDetailViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里 圈子详情
#define kEditCircle       2

#import "JRViewController.h"
#import "ArticleTableViewCell.h"
#import "PhotosViewController.h"

@interface CircleDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,ArticleTableViewViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,PhotosViewDelegate,PhotosViewDatasource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *circleDetailTableView; //tableview

@property (strong, nonatomic) IBOutlet UIView    *HeadView;        //上部分view 信息部分
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;   //圈子icon图片
@property (weak, nonatomic) IBOutlet UILabel     *circleNameLabel; //圈主名称label
@property (weak, nonatomic) IBOutlet UIButton    *memberButton;    //查看成员 按钮
@property (weak, nonatomic) IBOutlet UIButton    *joinButton;      //关注或取消关注 按钮
@property (weak, nonatomic) IBOutlet UIButton    *editButton;      //编辑 按钮
@property (weak, nonatomic) IBOutlet UILabel     *numberLabel;     //关注数量发帖数量 label
//编辑按钮触发
- (IBAction)gotoEditPage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel     *descLabel;//描述label
//关注按钮触发
- (IBAction)joinCircle:(id)sender;
//查看成员按钮触发事件
- (IBAction)gotoMemberPage:(id)sender;
@property (retain,nonatomic) NSString *circleId;//圈子id
@property (retain,nonatomic) NSString *circleName;//圈子名称
  
@property (assign,nonatomic) BOOL fromMyPage;
@end
