//
//  MemberCenterViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "MyHouseTableViewCell.h"
#import "LoginViewController.h"
#import "RegisterCheckHouseViewController.h"
#import "MyInfoViewController.h"
#import "MySettingViewController.h"
#import "RegisterCheckHouseViewController.h"
#import "ResetPasswordViewController.h"
#import "HouseInfoViewController.h"
#import "UserService.h"
#import "HouseService.h"
#import "LoginManager.h"
#import "UserInfoModel.h"
#import "MyHouseListModel.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "JRPropertyUntils.h"
#import "UserCommunityListController.h"

@interface MemberCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL _isEditStatus;           // 是否是编辑我的房屋状态
}

@property (weak,nonatomic) IBOutlet UIScrollView   *mainScrollView;
@property (weak,nonatomic) IBOutlet UIView      *contentView;

@property (weak,nonatomic) IBOutlet UIView         *userinfoView;
@property (weak,nonatomic) IBOutlet UIImageView    *portraitImageview;
@property (weak,nonatomic) IBOutlet UILabel        *nickLabel;

@property (weak,nonatomic) IBOutlet UIView         *houseHeaderview;
@property (weak,nonatomic) IBOutlet UIButton       *headerAddButton;
@property (weak,nonatomic) IBOutlet UIImageView    *headerLineview;
@property (weak,nonatomic) IBOutlet UIButton       *headerEditButton;

@property (weak,nonatomic) IBOutlet UIView         *noHouseHeaderview;
@property (weak,nonatomic) IBOutlet UIButton       *noHouseAddButton;


@property (weak,nonatomic) IBOutlet UIView         *myArticleView;
@property (weak,nonatomic) IBOutlet UIView         *pwdSettingview;
@property (weak,nonatomic) IBOutlet UIView         *settingview;

@property (weak,nonatomic)   IBOutlet  NSLayoutConstraint *pwdSetViewTopCon;
@property (weak,nonatomic)   IBOutlet  NSLayoutConstraint *tableviewHightCon;

@property (strong,nonatomic) UserService                  *userService;
@property (strong,nonatomic) HouseService                 *houseService;

@property (strong,nonatomic) UserInfoModel                *userInfo;

@end

static NSString * const MyHouseTableViewCellIdentifier = @"MyHouseTableViewCell";

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wodejia"]];
    
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, -20, UIScreenWidth, 20)];
    [statusBar setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:statusBar];
    
    self.houseDataArray = [[NSMutableArray alloc] init];
    self.userService = [[UserService alloc] init];
    self.houseService = [[HouseService alloc] init];
    self.userInfo = [[UserInfoModel alloc] init];
    
    self.userInfo.username = [LoginManager shareInstance].loginAccountInfo.username;
    
    UITapGestureRecognizer *infoviewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userinfoViewTapped:)];
    [self.userinfoView addGestureRecognizer:infoviewTap];
    
    UITapGestureRecognizer *pwdTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pwdSettingViewTapped:)];
    [self.pwdSettingview addGestureRecognizer:pwdTap];
    
    UITapGestureRecognizer *settingTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingViewTapped:)];
    [self.settingview addGestureRecognizer:settingTap];
    
    UITapGestureRecognizer *myArticleViewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMyArticle:)];
    [self.myArticleView addGestureRecognizer:myArticleViewTap];
    
    
    self.contentView.backgroundColor = [UIColor getColor:@"eeeeee"];
//    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    
//    [self.headerAddButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateNormal];
//    [self.headerAddButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateHighlighted];
//    [self.headerAddButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateSelected];
//
//    [self.headerEditButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateNormal];
//    [self.headerEditButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateHighlighted];
//    [self.headerEditButton setTitleColor:[UIColor getColor:@"BB474D"] forState:UIControlStateSelected];
    
//    [self.noHouseAddButton setBackgroundImage:[UIImage imageNamed:@"myhome_nohouse_btn_addinformation"] forState:UIControlStateNormal];
//    [self.noHouseAddButton setBackgroundImage:[UIImage imageNamed:@"myhome_nohouse_btn_addinformation_press"] forState:UIControlStateHighlighted];
//    [self.noHouseAddButton setBackgroundImage:[UIImage imageNamed:@"myhome_nohouse_btn_addinformation_press"] forState:UIControlStateSelected];


    
//    if([LoginManager shareInstance].loginAccountInfo.isLogin)
//    {
//        // 请求个人房屋信息
//        [self refreshUserHouseInfo];
//    }
//    
//    [self updateViews];
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.mainScrollView.contentSize = CGSizeMake(UIScreenWidth, 800);
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if([LoginManager shareInstance].loginAccountInfo.isLogin)
    {
        [JRPropertyUntils refreshUserPortraitInView:self.portraitImageview];
        self.nickLabel.text = [LoginManager shareInstance].loginAccountInfo.nickName;
    }
    else{
        // 未登录展示默认头像
        [self.portraitImageview setImage:[UIImage imageNamed:@"default_portrait_140x140.png"]];
        self.nickLabel.text = @"请登录";
    }
    
    
    if ([LoginManager shareInstance].loginAccountInfo.isLogin)
    {
        if (![[LoginManager shareInstance].loginAccountInfo.username isEqualToString:self.userInfo.username]) {
            //更新本地信息
            self.userInfo.username = [LoginManager shareInstance].loginAccountInfo.username;
            
            // 登录账号已改变，刷新房屋信息
            if ([self.houseDataArray count] > 0) {
                [self.houseDataArray removeAllObjects];
                [self.houseTableview reloadData];
            }
        }
        
        // 重新请求房屋信息
        [self refreshUserHouseInfo];
    }
    else{
        // 清除房屋信息
        if ([self.houseDataArray count] > 0) {
            [self.houseDataArray removeAllObjects];
            [self.houseTableview reloadData];
        }
    }
    
    [self updateViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

/**
 *  请求房屋信息
 */
- (void)refreshUserHouseInfo
{
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.houseService Bus401201:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObj)
    {
        MyHouseListModel *houseListModel = (MyHouseListModel *)responseObj;
        
        if ([houseListModel.retcode isEqual:@"000000"]) {
            // 刷新房屋信息
            [SVProgressHUD dismiss];
            [self.houseDataArray removeAllObjects];
            [self.houseDataArray addObjectsFromArray:houseListModel.doc];
            [self updateViews];
            [self.houseTableview reloadData];
            [self updateTableviewConstraints];
        }
        else{
            //[SVProgressHUD showErrorWithStatus:houseListModel.retinfo];
        }
        
    }failure:^(NSError *error){
        // 请求失败
        //[SVProgressHUD showErrorWithStatus:@"房屋信息请求失败，请稍后重试"];
    }];
}


/**
 *  更新房屋列表约束
 */
- (void)updateTableviewConstraints
{
    self.tableviewHightCon.constant = 44 * [_houseDataArray count];
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_houseDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib=[UINib nibWithNibName:MyHouseTableViewCellIdentifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:MyHouseTableViewCellIdentifier];
        nibsRegistered = YES;
    }
    
    MyHouseModel *house = (MyHouseModel *)[_houseDataArray objectAtIndex:[indexPath row]];
    
    MyHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseTableViewCellIdentifier];
    
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile_bg_red"]];
    [cell setBackgroundColor:bgColor];
    
    cell.houseLabel.text = [NSString stringWithFormat:@"%@%@%@%@",house.cName,house.bName,house.dName,house.hName];
    cell.selectionStyle = _isEditStatus ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray ;
    cell.editButton.hidden = !_isEditStatus;
    
    [cell.editButton setBackgroundImage:[UIImage imageNamed:@"myhome_housing_information_btn_delet.png"] forState:UIControlStateNormal];
    [cell.editButton setBackgroundImage:[UIImage imageNamed:@"myhome_housing_information_btn_delet_press.png"] forState:UIControlStateHighlighted];
    [cell.editButton setBackgroundImage:[UIImage imageNamed:@"myhome_housing_information_btn_delet_press.png"] forState:UIControlStateSelected];
    //tableview 点击不变色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (!_isEditStatus) {
        
        cell.arrowImageView.hidden = NO;
        cell.statusImageView.hidden = YES;
        cell.statusLabel.hidden = NO;
        cell.editButton.hidden = YES;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.editButton setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
//        [cell.editButton setBackgroundImage:nil forState:UIControlStateNormal];
        if ([@"1" isEqualToString:house.flag]) {
            // 被冻结
            cell.statusLabel.text = @"冻结";
        }else if([@"2" isEqualToString:house.flag]) {
            //审核中
           cell.statusLabel.text = @"审核中";
        }
        else if([@"3" isEqualToString:house.flag]) {
            //审核失败
            cell.statusImageView.hidden = NO;
            cell.statusLabel.textColor = [UIColor getColor:@"b04734"];
            cell.statusLabel.text = @"验证失败";
        }
        else{
            cell.statusLabel.text = @"已绑定";
        }
    }
    else{
        cell.arrowImageView.hidden = YES;
        cell.statusImageView.hidden = YES;
        cell.statusLabel.hidden = YES;
        cell.editButton.hidden = NO;
        cell.editButton.enabled = YES;
        [cell.editButton setTitle:nil forState:UIControlStateNormal];
    }
    cell.editButtonPressedBlock = ^{
        // 解绑
        [self unbindHouseInAccount:[indexPath row]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_grey_foot_40x1"]];
    bottomView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 1);
    return bottomView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditStatus) {
        // 编辑状态下不处理
        return;
    }
    
    MyHouseModel *house = (MyHouseModel *)[_houseDataArray objectAtIndex:[indexPath row]];
    if ([@"1" isEqualToString:house.flag] || [@"2" isEqualToString:house.flag]){
        // 被冻结，不操作
        return;
    }
    
    //取消选中效果
    [self.houseTableview deselectRowAtIndexPath:[self.houseTableview indexPathForSelectedRow] animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    HouseInfoViewController *houseInfoController = [storyBoard instantiateViewControllerWithIdentifier:@"HouseInfoViewController"];
    houseInfoController.hidesBottomBarWhenPushed = YES;
    houseInfoController.title = @"房屋信息";
    [houseInfoController setMyHouseModel:[_houseDataArray objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:houseInfoController animated:YES];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    
}


#pragma  mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        // 登录页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //登录返回前需要请求圈子用户信息
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Actions

/**
 *  解绑账户下房屋
 */
- (void)unbindHouseInAccount:(NSInteger)houseIndex
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

    MyHouseModel *house = (MyHouseModel *)[_houseDataArray objectAtIndex:houseIndex];

    [self.houseService  Bus401501:[LoginManager shareInstance].loginAccountInfo.uId
                              hId:house.hId
                          success:^(id responseObj)
    {
          BaseModel *result = (BaseModel *)responseObj;
          if ([result.retcode isEqualToString:@"000000"]) {
              [SVProgressHUD dismiss];
              [self.houseDataArray removeObjectAtIndex:houseIndex];
              [self.houseTableview reloadData];
              [self updateViews];
          }
          else{
              [SVProgressHUD showErrorWithStatus:result.retinfo];
          }
    }failure:^(NSError *error){
      [SVProgressHUD showErrorWithStatus:@"解绑失败，请稍后重试"];
    }];
}

- (BOOL)checkLoginStatus
{
    if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
        return YES;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录"
                                                            message:@"您还未登录，是否登录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        [alertView show];
        
        return NO;
    }
}

/**
 *  个人信息
 *
 *  @param sender
 */
- (void)userinfoViewTapped:(id)sender
{
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        // 进入登录页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //登录返回前需要请求圈子用户信息
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        // 进入我的信息详情
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        MyInfoViewController *myInfoController = [storyBoard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        myInfoController.hidesBottomBarWhenPushed = YES;
        myInfoController.title = @"个人信息";
        [self.navigationController pushViewController:myInfoController animated:YES];
    }
}

/**
 *  添加房屋
 *
 *  @param sender
 */
- (IBAction)addNewHouse:(id)sender
{
    if ([self checkLoginStatus]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        RegisterCheckHouseViewController *houseController = [storyBoard instantiateViewControllerWithIdentifier:@"RegisterCheckHouseViewController"];
        houseController.hidesBottomBarWhenPushed = YES;
        houseController.isRegister = NO;
        houseController.title = @"添加房屋";
        [self.navigationController pushViewController:houseController animated:YES];
    }
}

/**
 *  编辑/完成编辑我的房屋信息
 *
 *  @param sender 
 */
- (IBAction)editMyHouses:(id)sender
{
    if (_isEditStatus) {
        // 完成编辑
        self.headerAddButton.hidden = NO;
        self.headerLineview.hidden = NO;
        [self.headerEditButton setTitle:@"编辑" forState:UIControlStateNormal];

    }
    else{
        // 编辑我的房屋
        self.headerAddButton.hidden = YES;
        self.headerLineview.hidden = YES;
        [self.headerEditButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    _isEditStatus = !_isEditStatus;
    [self.houseTableview reloadData];
}

/**
 *  密码管理
 *
 *  @param sender
 */
- (void)pwdSettingViewTapped:(id)sender
{
    if ([self checkLoginStatus]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
        
        ResetPasswordViewController *resetPwdController = [storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
        resetPwdController.isForgetPassword = NO;
        resetPwdController.title = @"密码管理";
        resetPwdController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:resetPwdController animated:YES];
    }
}

/**
 *  点击设置
 *
 *  @param sender
 */
- (void)settingViewTapped:(id)sender
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    MySettingViewController *settingController = [storyBoard instantiateViewControllerWithIdentifier:@"MySettingViewController"];
    settingController.hidesBottomBarWhenPushed = YES;
    settingController.title = @"设置";
    [self.navigationController pushViewController:settingController animated:YES];
}


/**
 *  更新视图，有房屋和无房屋的展示不同
 */
- (void)updateViews
{
    if ([self.houseDataArray count] > 0) {
        self.houseHeaderview.hidden = NO;
         self.houseTableview.hidden = NO;
        self.noHouseHeaderview.hidden = YES;
        self.pwdSetViewTopCon.constant = 12;
    }
    else{
        //没有房屋纪录，提示添加记录
        self.houseHeaderview.hidden = YES;
        self.noHouseHeaderview.hidden = NO;
        self.pwdSetViewTopCon.constant = 12;
        
        self.houseTableview.hidden = YES;
        self.headerAddButton.hidden = NO;
        self.headerLineview.hidden = NO;
        self.headerEditButton.titleLabel.text = @"编辑";
        _isEditStatus = NO;
    }
    
    if (CURRENT_VERSION < 7.0) {
        self.mainScrollView.contentOffset = CGPointZero;
    }

    [self updateTableviewConstraints];
    [self.view layoutIfNeeded];
}

//点击我发布的话题
-(void)clickMyArticle:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityStoryboard" bundle:nil];
    UserCommunityListController *userCommunityListController = [storyboard instantiateViewControllerWithIdentifier:@"UserCommunityListController"];
    userCommunityListController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userCommunityListController animated:YES];
}


#pragma mark - 测试数据

- (void)initTestHouseData
{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    [self.houseDataArray addObject:@"1栋2单元3室"];
    [self.houseDataArray addObject:@"1栋2单元3室1栋2单元3室1栋2单元3室"];
    [self.houseDataArray addObject:@"1栋2单元3室1栋2单元3室"];
    [self.houseDataArray addObject:@"1栋2单元3室"];
    [self.houseDataArray addObject:@"1栋2单元3室"];

    
    if (user.length > 0 && [_houseDataArray count] < 5) {
    }
    else{
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
