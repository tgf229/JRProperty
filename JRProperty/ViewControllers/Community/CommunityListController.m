//
//  CommunityListController.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityListController.h"
#import "CommunityListCell.h"
#import "ArticleListModel.h"
#import "ArticleDetailViewController.h"

#import "SVProgressHUD.h"   //
#import "MJRefresh.h"   //上啦下拉刷新
#import "RefreshPageView.h" //错误页

#import "LoginManager.h"
#import "CommunityService.h"

@interface CommunityListController ()

@property (strong,nonatomic) ArticleListModel *response;
@property (strong,nonatomic) NSMutableArray *doc;

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CommunityService *communityService;
@property (strong,nonatomic) RefreshPageView *refreshPage; //重新加载 错误页面
@property (strong,nonatomic) UIView *footerView;  //列表结束提示图片

@property (assign,nonatomic) BOOL isPulling;  //下拉刷新标志
@property (assign,nonatomic) BOOL isLoadMore;  //加载更多标志
@property (assign,nonatomic) BOOL hasMore;  //还有更多

@property (assign,nonatomic) int page; //页数


@end

@implementation CommunityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.communityService = [[CommunityService alloc]init];
    self.response = [[ArticleListModel alloc]init];
    self.doc = [[NSMutableArray alloc]init];
    
    
    //错误页面初始化
    self.refreshPage = [[[NSBundle mainBundle]loadNibNamed:@"RefreshPageView" owner:self options:nil] objectAtIndex:0];
    [self.refreshPage initial];
    if (CURRENT_VERSION<7) {
        self.refreshPage.frame = CGRectMake(0, UIScreenHeight/2-150, UIScreenWidth, 200);
    }else{
        self.refreshPage.frame = CGRectMake(0, UIScreenHeight/2 -120, UIScreenWidth, 200);
    }
    __weak CommunityListController *weakCommunityListController = self;
    self.refreshPage.callBackBlock = ^(){
        [weakCommunityListController reqList:@"1" time:nil];
    };
    [self.refreshPage setHidden:YES];
    [self.view addSubview:self.refreshPage];
    
    //列表底部tips初始化
    self.footerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
    UIImageView *endTip = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth/2-18, 7.5, 36, 15)];
    endTip.image = [UIImage imageNamed:@"end_tips_60x42"];
    [self.footerView addSubview:endTip];
    

    //初始化列表view
    [self initView];
    [self reqList:@"1" time:nil];
    
}

-(void)initView{
    //去掉底部多余的分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //页面底色
    [self.tableView setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //表格
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.showsVerticalScrollIndicator = YES;
}

-(void)initHeaderAndFooter{
    [self.tableView addHeaderWithCallback:^{
        [self.footerView setHidden:YES];
        self.isPulling = YES;
        [self reqList:@"1" time:nil];
    }];
//    [self.tableView addFooterWithCallback:^{
//        NSLog(@"上拉分页");
//    }];
}

-(void)reqList:(NSString *)page time:(NSString *)queryTime{
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    
    NSString *uId = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus302301:uId cId:CID_FOR_REQUEST page:page num:NUMBER_FOR_REQUEST queryTime:queryTime success:^(id responseObject) {
        self.response = (ArticleListModel *)responseObject;
        [self showList];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (self.isPulling) {
            self.isPulling = NO;
            //头部停止刷新
            [self.tableView headerEndRefreshing];
        }else if (self.isLoadMore){
            self.isLoadMore = NO;
            //底部停止刷新
            [self.tableView footerEndRefreshing];
        }else{
            //如果是第一次进列表，失败了则展示
            [self.refreshPage setHidden:NO];
            self.refreshPage.tipLabel.text = OTHER_ERROR_MESSAGE;
        }
    }];
}

-(void)showList{
    [SVProgressHUD dismiss];
    if ([self.response.retcode isEqualToString: RETURN_CODE_SUCCESS]) {
        if (self.isPulling) {
            //如果是下拉刷新，重置page，并清空doc
            self.page = 1;
            [self.doc removeAllObjects];
        }else if (self.isLoadMore){
            //如果是加载更多
            self.page = self.page+1;
        }else{
            //第一次请求
            self.page = 1;
            [self initHeaderAndFooter];
        }
        if (self.response.doc.count  < [NUMBER_FOR_REQUEST intValue]) {
            self.hasMore = NO;
            [self.tableView removeFooter];
            self.tableView.tableFooterView = self.footerView;
            [self.tableView.tableFooterView setHidden:NO];
        }else{
            self.hasMore = YES;
            [self.tableView.tableFooterView setHidden:YES];
            [self.tableView addFooterWithCallback:^{
                if (self.hasMore) {
                    self.isLoadMore = YES;
                    NSString *page = [NSString stringWithFormat:@"%d",self.page+1];
                    [self reqList:page time:self.response.queryTime];
                }
            }];
        }
        [self.doc addObjectsFromArray:self.response.doc];
        [self.tableView reloadData];
    }else {
        //如果retcode失败
        if (!self.isPulling && !self.isLoadMore) {
            //如果是第一次进列表，失败了则展示错误页面
            [self.refreshPage setHidden:NO];
            self.refreshPage.tipLabel.text = OTHER_ERROR_MESSAGE;
        }else{
            [SVProgressHUD showErrorWithStatus:self.response.retinfo];
        }
    }
    
    if (self.isPulling) {
        self.isPulling = NO;
        //头部停止刷新
        [self.tableView headerEndRefreshing];
    }else if (self.isLoadMore){
        self.isLoadMore = NO;
        //底部停止刷新
        [self.tableView footerEndRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.doc count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    ArticleDetailModel *model = [self.doc objectAtIndex:row];
    CGFloat rowHight = [CommunityListCell height:model];
    return rowHight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityListCell" forIndexPath:indexPath];
    
    //cell赋值
    NSInteger row = [indexPath row];
    ArticleDetailModel *detail = [self.doc objectAtIndex:row];
    [cell showCell:detail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailModel *model = [self.doc objectAtIndex:indexPath.row];
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleId = model.aId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
