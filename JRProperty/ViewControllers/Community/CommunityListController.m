//
//  CommunityListController.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityListController.h"
#import "CommunityListCell.h"
#import "CommunityListOfficialCell.h"
#import "ArticleListModel.h"
#import "ArticleDetailViewController.h"

#import "SVProgressHUD.h"   //
#import "MJRefresh.h"   //上啦下拉刷新
#import "RefreshPageView.h" //错误页

#import "LoginManager.h"
#import "CommunityService.h"
#import "PublicTopicViewController.h"

@interface CommunityListController ()

@property (strong,nonatomic) ArticleListModel *response;
@property (strong,nonatomic) NSMutableArray *doc;

@property (strong,nonatomic) NSMutableDictionary *dict;
@property (strong,nonatomic) NSArray *dictKeys;

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CommunityService *communityService;
@property (strong,nonatomic) RefreshPageView *refreshPage; //重新加载 错误页面
@property (strong,nonatomic) UIView *footerView;  //列表结束提示图片

@property (assign,nonatomic) BOOL isPulling;  //下拉刷新标志
@property (assign,nonatomic) BOOL isLoadMore;  //加载更多标志
@property (assign,nonatomic) BOOL hasMore;  //还有更多

@property (assign,nonatomic) int page; //页数

@property (nonatomic,strong) NSMutableArray          *largeImageArray;    //大图地址列表

@end

@implementation CommunityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_linli_big"]];
    
    //初始化
    self.communityService = [[CommunityService alloc]init];
    self.response = [[ArticleListModel alloc]init];
    self.doc = [[NSMutableArray alloc]init];
//    self.dict = [[NSMutableDictionary alloc]init];
    
    
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
    

    [self initRightBarButtonItem];
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

/**
 *  设置导航栏右键
 */
- (void)initRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 50 + 22, 20)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 50, 20)];
    }
    [editButton setImage:[UIImage imageNamed:@"title_red_fahuati"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"title_red_fahuati"] forState:UIControlStateHighlighted];

//    [editButton addTarget:self action:@selector(submitDataToService) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 10000;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    [editButton addTarget:self action:@selector(gotoPostArticle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)gotoPostArticle{
        PublicTopicViewController *publicTopicController = [[PublicTopicViewController alloc] init];
        publicTopicController.title = @"发话题";
        [self.navigationController pushViewController:publicTopicController animated:YES];
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
        [self.refreshPage setHidden:YES];
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
        [self filterData];
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

//将接口返回的列表 过滤数据
-(void)filterData{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSArray *valueArray;
    NSString *tempDate;
    
    self.dict = [[NSMutableDictionary alloc]init];
    for (int i=0; i<[self.doc count]; i++) {
        ArticleDetailModel *model =  (ArticleDetailModel *)[self.doc objectAtIndex:i];
        if (tempDate != nil && ![tempDate isEqualToString:model.date]) {
            valueArray = [[NSArray alloc]initWithArray:tempArray];
            [self.dict setObject:valueArray forKey:tempDate];
            tempDate = nil;
            [tempArray removeAllObjects];
        }
        tempDate = model.date;
        [tempArray addObject:model];
    }
    
    [self.dict setObject:tempArray forKey:tempDate];
    //倒叙排序
    NSArray * tempList = [self.dict allKeys];
    self.dictKeys = [tempList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 floatValue]< [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//大图预览
- (void)imageClick:(NSUInteger)index withInfo:(NSArray *)info {
    [self.largeImageArray removeAllObjects];
    [self.largeImageArray addObjectsFromArray:info];
    PhotosViewController      *photos = [[PhotosViewController alloc] init];
    photos.delegate = self;
    photos.datasource = self;
    photos.currentPage = (int)index;
    [self.navigationController pushViewController:photos animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dictKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.dictKeys objectAtIndex:section];
    NSArray *array = [self.dict objectForKey:key];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSString *key = [self.dictKeys objectAtIndex:section];
    NSArray *array = [self.dict objectForKey:key];
    ArticleDetailModel *model = [array objectAtIndex:row];
//    ArticleDetailModel *model = [self.doc objectAtIndex:row];
    CGFloat rowHight = [CommunityListCell height:model];
    return rowHight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *key = [self.dictKeys objectAtIndex:section];
    NSArray *array = [self.dict objectForKey:key];
    ArticleDetailModel *detail = [array objectAtIndex:row];
    
    if ([@"4" isEqualToString:detail.type]) {
        CommunityListOfficialCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CommunityListOfficialCell" owner:self options:nil]objectAtIndex:0];

        [cell showCell:detail];
        return cell;
        
    }else{
        CommunityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityListCell" forIndexPath:indexPath];
        
        [cell showCell:detail];
        return cell;
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *key = [self.dictKeys objectAtIndex:section];
//    return key;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor= [UIColor getColor:@"f2f2f2"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth/2-35, 9, 70, 14)];
    NSString *key = [self.dictKeys objectAtIndex:section];
    NSString *year = [key substringToIndex:4];
    NSString *month = [key substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [key substringFromIndex:6];
    NSString *showKey = [[NSString alloc]initWithFormat:@"%@.%@.%@",year,month,day];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor getColor:@"999999"];
    titleLabel.text = showKey;
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"community_title_time_line"]];
    titleImage.frame = CGRectMake(10, 14, UIScreenWidth-20, 2);
    
    [myView addSubview:titleImage];
    [myView addSubview:titleLabel];
    
    return myView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    NSString *key = [self.dictKeys objectAtIndex:section];
    NSArray *array = [self.dict objectForKey:key];
    ArticleDetailModel *model = [array objectAtIndex:row];
    
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleId = model.aId;
    controller.hidesBottomBarWhenPushed = YES;
    
    if ([@"4" isEqualToString:model.type]) {
        controller.onlyOfficial = YES;
    }

    [self.navigationController pushViewController:controller animated:YES];
}


@end
