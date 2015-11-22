//
//  CircleListViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define kCreateCircle     1
#define kEditCircle       2
#define kDeleteCircleAlert  1
#define kCreateCircleNumberAlert 2

#import "CircleListViewController.h"
#import "CreateCircleViewController.h"
#import "CircleDetailViewController.h"
#import "CircleListTableViewCell.h"
#import "EditUserInfoViewController.h"
#import "NoResultView.h"
#import "SVProgressHUD.h"
#import "NoResultView.h"
#import "MJRefresh.h"

#import "SquareModel.h"
#import "CircleListModel.h"
#import "LoginManager.h"
#import "JRDefine.h"

#import "NeighborService.h"
#import "MemberService.h"

#import "UIColor+extend.h"


@interface CircleListViewController ()

@property (nonatomic,strong)  NSMutableArray     *circleArray;     // 圈子数组
@property (nonatomic,strong)  NoResultView       *noResultView;    // 报错页面
@property (nonatomic,assign)  BOOL               isPulling;        // 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMore;          // 还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMore;       // 上拉加载更多标志
@property (nonatomic,assign)  int          page;             // 页数
@property (strong,nonatomic)  NeighborService     *neighborService;
@property (strong,nonatomic)  MemberService       *memberService;
@property (nonatomic,strong)  CircleListModel     *circleListModel;//圈子列表model
@property (nonatomic,assign) NSInteger deleteRowNumber;//删除的行号
//@property (strong,nonatomic)  UIView  *footerView;//列表结束提示图片
@end

@implementation CircleListViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    //title
    switch (self.circleType) {
        case kMyJoinCircle:
            self.title = @"我加入的圈子";
            break;
        default:
            break;
    }
    [super viewDidLoad];
    switch (self.circleType) {
        case kMyManageCircle:
        {
            self.title = @"我管理的圈子";
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_woguanlidequanzi"]];
            self.navigationItem.titleView = iv;
            break;
        }
        case kOfficialCircle:
        {
            self.title = @"官方推荐";
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_guanfangtuijian"]];
            self.navigationItem.titleView = iv;
            break;
        }
        case kHotCircle:
        {
            self.title = @"热门圈子";
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_remenquanzi"]];
            self.navigationItem.titleView = iv;
            break;
        }
        case kMyJoinCircle:
            self.title = @"我加入的圈子";
            break;
        default:
            break;
    }
    [self.view setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    //新建圈子通知 （用于我管理的圈子）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestCircleListAfertCreate) name:CREATE_CRICLE_SUCCESS  object:nil];
    //初始化
    self.neighborService = [[NeighborService alloc]init];
    self.memberService = [[MemberService alloc]init];

    self.circleArray = [[NSMutableArray alloc]init];
    self.circleListModel = [[CircleListModel alloc]init];
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
//    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
//    UIImageView *endTip = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth/2-15, 4, 30, 21)];
//    endTip.image = [UIImage imageNamed:@"end_tips_60x42"];
//    [self.footerView addSubview:endTip];
    //创建圈子按钮（用于我管理的圈子）
    if (self.circleType == kMyManageCircle) {
        [self createAddButton];
    }
    //设置表格
    [self createTableView];
    //请求圈子列表  第一次请求 第一页
    [self requestCircleListWithPage:1 ];
}

/**
 *  设置表格
 */
- (void)createTableView {
    self.circleListTableView.delegate = self;
    self.circleListTableView.dataSource = self;
    self.circleListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.circleListTableView.backgroundColor = [UIColor clearColor];
    self.circleListTableView.showsVerticalScrollIndicator = YES;
    self.circleListTableView.userInteractionEnabled = YES;
    [self.circleListTableView addHeaderWithCallback:^{
        self.isPulling = YES;
        // 调用网络请求
        [self requestCircleListWithPage:1];
    }];
    [self.circleListTableView addFooterWithCallback:^{
        if (self.hasMore) {
            self.isLoadMore = YES;
            [self requestCircleListWithPage:self.page+1];
        }
    }];
   [self.circleListTableView setHidden:YES];
}

/**
 *  标题栏右侧按钮
 */
- (void)createAddButton {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [addButton setFrame:CGRectMake(0, 0, 22 + 22, 22)];
    } else {
        [addButton setFrame:CGRectMake(0, 0, 22, 22)];
    }
    [addButton setImage:[UIImage imageNamed:@"add_40x40"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"add_press_40x40"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(gotoAddCirclePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  添加圈子 按钮触发 跳转到添加页面
 */
- (void)gotoAddCirclePage {
    //为3个时 不允许再创建
    if (self.circleArray.count>=3) {
        UIAlertView   *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您最多只能创建三个圈子！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = kCreateCircleNumberAlert;
        [alert show];
    }
    else {
        CreateCircleViewController *controller = [[CreateCircleViewController alloc]init];
        controller.manageType = kCreateCircle;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - PrivateMethod RequestList join quit
/**
 *  请求圈子列表
 *
 *  @param page  页数
 */
- (void)requestCircleListWithPage:(int)page  {
    if (!self.isPulling && !self.isLoadMore) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString  *pageStr = [NSString stringWithFormat:@"%d",page];
    NSString  *typeStr = [NSString stringWithFormat:@"%d",self.circleType];
    NSString  *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.neighborService Bus300201:CID_FOR_REQUEST uId:uid type:typeStr page:pageStr num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        self.circleListModel = (CircleListModel *)responseObject;
        [self serviceSucceed:self.circleListModel];
    } failure:^(NSError *error) {
        [self serviceFailed];
    }];
}

/**
 *  请求圈子列表成功处理
 *
 */
- (void)serviceSucceed:(CircleListModel *)resultInfo {
    
    if ([resultInfo.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
        [SVProgressHUD dismiss];
        [self.circleListTableView setHidden:NO];
        //下拉刷新
        if (self.isPulling) {
            self.page = 1;
            //清空原数据  放入新数据  判断是否还有更多
            [self.circleArray removeAllObjects];
            
        }
        // 上滑加载更多
        else if (self.isLoadMore) {
            self.page = self.page +1 ;
        }
        //第一次请求
        else {
            self.page = 1;
        }
        if(resultInfo.doc.count < 10){
            self.hasMore = NO;
            [self.circleListTableView removeFooter];
            //self.circleListTableView.tableFooterView = self.footerView;
            
        }else{
            self.hasMore = YES;
            //self.circleListTableView.tableFooterView = nil;

            [self.circleListTableView addFooterWithCallback:^{
                if (self.hasMore) {
                    self.isLoadMore = YES;
                    [self requestCircleListWithPage:self.page+1];
                }
            }];
        }
        [self.circleArray addObjectsFromArray:resultInfo.doc];
        if(self.circleArray.count == 0) {
            [self.noResultView initialWithTipText:NONE_DATA_MESSAGE];
            [self.noResultView setHidden:NO];
        }
        else {
            [self.noResultView setHidden:YES];
            [self.circleListTableView setHidden:NO];
        }
        [self.circleListTableView reloadData];
    }
    //失败
    else {
        if (self.isLoadMore) {
            self.hasMore = YES;
        }
        if (self.circleArray.count == 0) {
            [SVProgressHUD dismiss];
            [self.noResultView setHidden:NO];
        }
        else {
            [self.circleListTableView setHidden:NO];
            [SVProgressHUD showErrorWithStatus:resultInfo.retinfo];
        }
    }
    if (self.isPulling) {
        // 请求回来后，停止刷新
        [self.circleListTableView headerEndRefreshing];
        self.isPulling = NO;
    }
    else if (self.isLoadMore) {
        [self.circleListTableView footerEndRefreshing];
        self.isLoadMore = NO;
    }
}

/**
 *  请求圈子列表s失败处理
 *
 */
- (void)serviceFailed  {
    if (self.isPulling) {
        // 请求回来后，停止刷新
        [self.circleListTableView headerEndRefreshing];
        self.isPulling = NO;
    }
    // 上滑加载更多
    else if (self.isLoadMore) {
        [self.circleListTableView footerEndRefreshing];
        self.isLoadMore = NO;
        self.hasMore = YES;
    }
    if(self.circleArray.count == 0) {
        [SVProgressHUD dismiss];
        [self.noResultView setHidden:NO];
    }
    else {
        [self.circleListTableView setHidden:NO];
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
    }
}
#pragma mark - UITableView DataSource
//右滑 删除功能
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.circleType == kMyManageCircle) {
        return YES;
    }
    else {
        return NO;
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //执行删除方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deleteRowNumber = indexPath.row;
        UIAlertView  *deleteAlert  = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此圈子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        deleteAlert.tag = kDeleteCircleAlert;
        [deleteAlert show];
        //
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0){
    return @" 删除 ";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 12.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"CircleListTableViewCell";
    CircleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleListTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置代理
    //cell.delegate = self;
    //获取数据
    CircleInfoModel * info = [self.circleArray objectAtIndex:indexPath.row];
    //设置圈子类型（我管理的圈子要特殊处理）
    [cell setType:self.circleType];
    if (indexPath.row == self.circleArray.count -1) {
         [cell isLastRow:YES];
    }else {
         [cell isLastRow:NO];
    }
   
    //设置圈子信息
    [cell setData:info];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleInfoModel * model = [self.circleArray objectAtIndex:indexPath.row];
    CircleDetailViewController *controller = [[CircleDetailViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.circleId = model.id;
    controller.circleName = model.name;
    controller.fromMyPage = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  删除圈子
 *  row 行号
 */
- (void)deleteCircleWithRow :(NSInteger)row {
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    CircleInfoModel  *model = [self.circleArray objectAtIndex:row];
    [self.memberService Bus301601:[LoginManager shareInstance].loginAccountInfo.uId sId:model.id success:^(id responseObject) {
        BaseModel *model = (BaseModel *)responseObject;
        if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.circleArray removeObjectAtIndex:row];
            [self.circleListTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_CRICLE_SUCCESS  object:self];

            if (self.circleArray.count == 0) {
                [self.noResultView initialWithTipText:NONE_DATA_MESSAGE];
                [self.noResultView setHidden:NO];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:model.retinfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
    }];
}

/**
 *  创建圈子后自动刷新列表
 */
- (void)requestCircleListAfertCreate {
    [self.circleListTableView headerBeginRefreshing];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kCreateCircleNumberAlert) {
        if (buttonIndex == 0) {
        }
    }
    else {
        if (buttonIndex == 1) {
            [self deleteCircleWithRow:self.deleteRowNumber];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
