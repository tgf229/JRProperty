//
//  UserPageViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-12-1.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  圈子 个人中心

#import "JRViewController.h"
#import "ArticleTableViewCell.h"
#import "PhotosViewController.h"
#import "ReportViewController.h"
#import "ShareView.h"
@interface UserPageViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ArticleTableViewViewDelegate,PhotosViewDatasource,PhotosViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//个人信息部分view
@property (weak, nonatomic) IBOutlet UIView *headView;
//列表部分 （话题列表，关注列表， 管理的圈子）
@property (weak, nonatomic) IBOutlet UITableView *myArticleTableView;
//个人信息部分距离底部距离 （待用）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
//返回按钮触发事件
- (IBAction)returnClick:(id)sender;
//设置按钮
@property (weak, nonatomic) IBOutlet UIButton *setButton;
//设置按钮触发事件
- (IBAction)setClick:(id)sender;
//tableview距离个人信息view 的距离 （解决7，8 bug）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopContraint;
//头像图片imageview
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//昵称label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//签名label
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//我的话题按钮
@property (weak, nonatomic) IBOutlet UIButton *articleButton;
//我的关注按钮
@property (weak, nonatomic) IBOutlet UIButton *joinListButton;
//我的管理按钮
@property (weak, nonatomic) IBOutlet UIButton *myCircleBuuton;
//我的话题按钮触发事件
- (IBAction)articleClick:(id)sender;
//我的管理按钮触发事件
- (IBAction)myCircleClick:(id)sender;
//我的关注按钮触发事件
- (IBAction)joinClick:(id)sender;
//要查询的用户的uid
@property (strong,nonatomic ) NSString *queryUid;
@property (weak, nonatomic) IBOutlet UIButton *daVip;

@end
