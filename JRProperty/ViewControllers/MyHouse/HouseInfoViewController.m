//
//  HouseInfoViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HouseInfoViewController.h"
#import "HouseInfoTableViewCell.h"
#import "HouseService.h"
#import "UserInfoModel.h"
#import "LoginManager.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface HouseInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isEditStatus;  // 是否在编辑状态
}

@property (weak,nonatomic)  IBOutlet  UIScrollView   *mainScrollView;
@property (weak,nonatomic)  IBOutlet  UILabel        *houseInfoLabel;  // 基本信息

@property (weak,nonatomic)  IBOutlet  UITableView    *userTableView;
@property (weak,nonatomic)  IBOutlet  UIButton       *editButton;

@property (weak,nonatomic)  IBOutlet  NSLayoutConstraint *tableviewHightCon;

@property (strong,nonatomic) HouseService                 *houseService;
@property (strong,nonatomic) NSMutableArray               *userDataArray;


@end

@implementation HouseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_fangwuxinxi"]];
    self.navigationItem.titleView = iv;
    // Do any additional setup after loading the view.
    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.editButton.hidden = YES;
    self.userTableView.hidden = YES;
    
    self.houseService = [[HouseService alloc] init];
    self.userDataArray = [[NSMutableArray alloc] init];
    
    self.houseInfoLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.myHouseModel.cName,self.myHouseModel.bName,self.myHouseModel.dName,self.myHouseModel.hName];
    
//    [self.editButton setTitleColor:[UIColor getColor:@"3D8CE8"] forState:UIControlStateNormal];
//    [self.editButton setTitleColor:[UIColor getColor:@"3D8CE8"] forState:UIControlStateHighlighted];
//    [self.editButton setTitleColor:[UIColor getColor:@"3D8CE8"] forState:UIControlStateSelected];

    
    [self requestAccountsInHouse];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [SVProgressHUD dismiss];
}


- (void)setHouseModel:(MyHouseModel *)houseModel
{
    if (self.myHouseModel == nil) {
        self.myHouseModel = [[MyHouseModel alloc] init];
    }
    
    self.myHouseModel = houseModel;
}

/**
 *  更新列表约束
 */
- (void)updateTableviewConstraints
{
    self.tableviewHightCon.constant = 63 * [_userDataArray count];
    
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HouseInfoTableViewCellIdentifier = @"HouseInfoTableViewCell";
    HouseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseInfoTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserInfoModel *userInfo =  (UserInfoModel *)[_userDataArray objectAtIndex:[indexPath row]];
    [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:userInfo.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140.png"]];
    cell.nickNameLabel.text = userInfo.nickName;
    cell.phoneLabel.text = userInfo.phone;
    if (_isEditStatus) {
        cell.statuButton.enabled = YES;
        cell.statuButtonBlock = ^{
            [self freezeOrRecoverUser:userInfo.status withUser:userInfo];
        };
    }
    else{
        cell.statuButton.enabled = NO;
        cell.statuButtonBlock = ^{
            
        };
    }
    
    [cell updateUserLevel:userInfo.level withStatus:userInfo.status];
    [cell updateUserCellEditView:_isEditStatus withStatus:userInfo.status];
    [cell updateSperatorLineLeadingConstraint:15];
    if ([indexPath row] + 1 == [_userDataArray count]) {
        [cell updateSperatorLineLeadingConstraint:0];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0f;
}

#pragma  mark - Actions

- (IBAction)editButtonPressed:(id)sender
{
    _isEditStatus = !_isEditStatus;
    
    if(_isEditStatus)
    {
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.editButton setImage:nil forState:UIControlStateNormal];
        [self.editButton setImage:nil forState:UIControlStateHighlighted];
    }
    else{
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editButton setImage:[UIImage imageNamed:@"myhome_textico_edit"] forState:UIControlStateNormal];
        [self.editButton setImage:[UIImage imageNamed:@"myhome_textico_edit_press"] forState:UIControlStateHighlighted];
    }
    
    [self.userTableView reloadData];
}


/**
 *  请求房屋下账号
 */
- (void)requestAccountsInHouse
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.houseService Bus401301:[LoginManager shareInstance].loginAccountInfo.uId
                             hId:_myHouseModel.hId
                         success:^(id responseObj)
     {
         [SVProgressHUD dismiss];
         
         UserInfoListModel *userListModel = (UserInfoListModel *)responseObj;
         // 刷新头像和昵称
         if ([userListModel.retcode isEqual:@"000000"]) {
             // 刷新账户列表
             [self.userDataArray addObjectsFromArray:userListModel.doc];
             
             if ([self.userDataArray count] > 0) {
                 self.userTableView.hidden = NO;
                 [self.userTableView reloadData];
                 [self updateTableviewConstraints];
             }
             
             for (UserInfoModel *user in self.userDataArray) {
                 if ([user.level isEqualToString:@"1"]
                     && [user.phone isEqualToString:[LoginManager shareInstance].loginAccountInfo.username])
                 {
                     // 业主身份，允许编辑操作
                     self.editButton.hidden = NO;
                 }
             }
         }
         else{
             [SVProgressHUD showErrorWithStatus:userListModel.retinfo];
         }
         
     }failure:^(NSError *error){
         [SVProgressHUD dismiss];
     }];
}

/**
 *  冻结或者恢复住户状态
 *
 *  @param status 状态 "0":冻结 "1":正常
 */
- (void)freezeOrRecoverUser:(NSString *)status withUser:(UserInfoModel *)userInfo
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];

    [self.houseService Bus401401:[LoginManager shareInstance].loginAccountInfo.uId
                             hId:_myHouseModel.hId
                          optUId:userInfo.uId
                            type:[status isEqualToString:@"0"] ? @"1" : @"0"
                         success:^(id responseObj)
    {
        [SVProgressHUD dismiss];
        
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            //  成功
            userInfo.status = [status isEqualToString:@"0"] ? @"1" : @"0";  // 更改操作：可冻结变恢复，恢复变可冻结
            [self.userTableView reloadData];
        }
        else{
            // 失败
            NSLog(@"%@ %@",resultModel.retcode,resultModel.retinfo);
            [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"操作失败，请稍后重试"];
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
