//
//  NbSquareViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define kOfficialCircle  1
#define kHotCircle       2

#import "NbSquareViewController.h"
#import "CircleListViewController.h"
#import "CircleDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "SquareTableViewCell.h"
#import "RefreshPageView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#import "SquareModel.h"
#import "JRDefine.h"

#import "NeighborService.h"

#import "UIColor+extend.h"


//#import "JRPropertyUntils.h"
@interface NbSquareViewController ()

@property (retain,nonatomic)  SquareModel             *squareModel; //广场model
@property (retain,nonatomic)  NeighborService         *neighborService;
@property (strong,nonatomic)  RefreshPageView         *refreshPage;  //“重新加载”错误页面
@property (assign,nonatomic)  BOOL   isPulling;  //下拉刷新标志

@end



@implementation NbSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //页面底色
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshForChangeCid) name:@"CHANGEPROPERTYINFO" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshForChangeCid) name:LOGIN_SUCCESS  object:nil];
    //初始化
    self.squareModel = [[SquareModel alloc]init];
    self.neighborService  = [[NeighborService alloc]init];
    //创建错误提示页面
    self.refreshPage = [[[NSBundle mainBundle] loadNibNamed:@"RefreshPageView" owner:self options:nil]objectAtIndex:0];
    [self.refreshPage initial];
    if (CURRENT_VERSION<7) {
        self.refreshPage.frame = CGRectMake(0,UIScreenHeight/2-150, UIScreenWidth, 200);
    }
    else {
        self.refreshPage.frame = CGRectMake(0,UIScreenHeight/2-90, UIScreenWidth, 200);
    }
    __weak NbSquareViewController * weakNbSquareViewController = self;
    self.refreshPage.callBackBlock = ^(){
        //错误页面的回调 重新请求数据  并隐藏自己
        [weakNbSquareViewController.refreshPage setHidden:YES];
        [weakNbSquareViewController requestSquare];
    };
    [self.refreshPage setHidden:YES];
    [self.view addSubview:self.refreshPage];
    //设置表格
    [self createSquareTableview];
    //请求广场数据
    [self requestSquare];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

/**
 *  设置表格
 */
- (void)createSquareTableview {
    //表格
    self.squareTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.squareTableView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.squareTableView.delegate = self;
    self.squareTableView.dataSource = self;
//    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
//        self.squareTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//        self.squareTableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
//    } else {
//        self.squareTableView.contentInset = UIEdgeInsetsMake(108, 0, 49, 0);
//        self.squareTableView.scrollIndicatorInsets = UIEdgeInsetsMake(108, 0, 49, 0);
//    }
    self.squareTableView.showsVerticalScrollIndicator = NO;
    [self.squareTableView setHidden:YES];
    //下拉刷新设置
    [self.squareTableView addHeaderWithCallback:^{
        // 重新请求广场数据
        self.isPulling = YES;
        [self requestSquare];
    }];
    
}
- (void)refreshForChangeCid {
    [self.squareTableView headerBeginRefreshing];
}
/**
 *  请求广场数据
 */
- (void)requestSquare {
    
    self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;

    if (!self.isPulling) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    [self.neighborService Bus300101:CID_FOR_REQUEST success:^(id responseObject) {
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
        self.squareModel = (SquareModel *)responseObject;
        if ([self.squareModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [SVProgressHUD dismiss];
            [self.squareTableView setHidden:NO];
            [self.squareTableView reloadData];
        }
        else {
            if (self.squareModel.ocArticleList.count == 0 && self.squareModel.ocList.count == 0 && self.squareModel.hcArticleList.count ==0 && self.squareModel.hcList.count == 0) {
                [SVProgressHUD dismiss];
                [self.refreshPage setHidden:NO];
            }
            else {
                [self.squareTableView setHidden:NO];
                [SVProgressHUD showErrorWithStatus:self.squareModel.retinfo];
            }
        }
        
    } failure:^(NSError *error) {
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;

        if (self.squareModel.ocArticleList.count == 0 && self.squareModel.ocList.count == 0 && self.squareModel.hcArticleList.count ==0 && self.squareModel.hcList.count == 0) {
            [SVProgressHUD dismiss];
            [self.refreshPage setHidden:NO];
        }
        else {
            [self.squareTableView setHidden:NO];
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }
    }];
    if (self.isPulling) {
        self.isPulling = NO;
        [self.squareTableView headerEndRefreshing];
    }
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNumber;
    if (self.squareModel.hcArticleList.count == 0 && self.squareModel.hcList.count == 0) {
        rowNumber =1;
    }
    else {
        rowNumber = 2;
    }
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHight ;
    switch (indexPath.row) {
            //行0 官方推荐 数据
        case 0:
            rowHight = [SquareTableViewCell heighWithCircleArray:self.squareModel.ocList articleArray:self.squareModel.ocArticleList];
            break;
            //行1 热门圈子 数据
        case 1:
            rowHight = [SquareTableViewCell heighWithCircleArray:self.squareModel.hcList articleArray:self.squareModel.hcArticleList];
            break;
        
        default:
            break;
    }
    return rowHight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identify = @"SquareTableViewCell";
    SquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SquareTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor getColor:@"eeeeee"];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"官方推荐";
        [cell.moreButton addTarget:self action:@selector(gotoOfficialList) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:self.squareModel.ocList:self.squareModel.ocArticleList ];
    }
    else  if (indexPath.row == 1){
        cell.titleLabel.text = @"热门圈子";
        [cell.moreButton addTarget:self action:@selector(gotoHotList) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:self.squareModel.hcList:self.squareModel.hcArticleList ];
    }
    return cell;
    
}



#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  0行更多按钮触发 跳转官方推荐列表
 */
- (void)gotoOfficialList {
    CircleListViewController *controller = [[CircleListViewController alloc]init];
    controller.circleType = kOfficialCircle;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 *  1行更多按钮触发 跳转热门列表
 */
- (void)gotoHotList {
    CircleListViewController *controller = [[CircleListViewController alloc]init];
    controller.circleType = kHotCircle;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  圈子图标 点击触发
 *
 *  @param circleId 圈子id 
 *  @param circleName 圈子名称
 */
- (void)imageClick:(SquareTableViewCell *)cellView withCircleId:(NSString *)circleId  circleName:(NSString *)circleName{
    CircleDetailViewController *controller = [[CircleDetailViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.circleId = circleId;
    controller.circleName = circleName;
    controller.fromMyPage = NO;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 *  话题整行 点击触发
 *
 *  @param articleId 话题id
 */
- (void)gotoArticleDetailPage:(NSString *)articleId {
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleId = articleId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
