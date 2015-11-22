//
//  MyWorkOrderListViewController.m
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyWorkOrderListViewController.h"
#import "MyWorkOrderListTableViewCell.h"
#import "JRDefine.h"
#import "MJRefresh.h"
#import "MyWorkOrderDetailViewController.h"
#import "PropertyService.h"
#import "LoginManager.h"
#import "WorkOrderListModel.h"
#import "NoResultView.h"
#import "SVProgressHUD.h"
static NSString *cellIndentifer = @"MyWorkOrderListTableViewCellCellIndentifier";

@interface MyWorkOrderListViewController ()

@property (strong, nonatomic) NSMutableArray * dataSourceArray;     // 数据源
@property (strong, nonatomic) PropertyService * propertyService;    // 物业服务类
@property (assign, nonatomic) NSInteger     page;                   // 页数
@property (assign, nonatomic) BOOL          isPulling;              // 下拉标示
@property (assign, nonatomic) BOOL          hasMore;                // 更多标示
@property (nonatomic, strong) NoResultView * noResultView;          // 哭脸
@end

@implementation MyWorkOrderListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}


/**
 *  配置信息
 */
- (void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.propertyService = [[PropertyService alloc] init];
    _page = 1;
    _isPulling = YES;
    _hasMore = YES;
    
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
    
    [self requestMyWorkOrderListServiceWithPage:_page];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wodegongdan"]];

    UINib *cellNib = [UINib nibWithNibName:@"MyWorkOrderListTableViewCell" bundle:nil];
    [_workOrderTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifer];
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];

    [self config];
    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = _workOrderTableView;
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        _isPulling = YES;
        _page = 1;
        _hasMore = YES;
        [self requestMyWorkOrderListServiceWithPage:_page];
        if (_workOrderTableView.footerHidden) {
            [_workOrderTableView setFooterHidden:NO];
        }
    }];
    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        _isPulling = NO;
        if (_hasMore) {
            [self requestMyWorkOrderListServiceWithPage:++_page];
        }
    }];
}

/**
 *  工单列表请求
 *
 *  @param page 页数
 */
- (void)requestMyWorkOrderListServiceWithPage:(NSInteger)page{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    NSString * uID = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.propertyService Bus200201:CID_FOR_REQUEST uId:uID page:[NSString stringWithFormat:@"%d",page] num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[WorkOrderListModel class]]) {
            WorkOrderListModel *workOrderListModel = (WorkOrderListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:workOrderListModel.retcode]) {
                if (_isPulling) {
                    [_dataSourceArray removeAllObjects];
                    [_workOrderTableView headerEndRefreshing];
                    if(workOrderListModel.doc.count == 0) {
                        [self.noResultView initialWithTipText:@"暂无工单信息"];
                        [self.noResultView setHidden:NO];
                    }
                }else{
                    [_workOrderTableView footerEndRefreshing];
                }
                if (workOrderListModel.doc.count < 10) {
                    _hasMore = NO;
                    [_workOrderTableView footerEndRefreshing];
                    [_workOrderTableView setFooterHidden:YES];
                }
                [_dataSourceArray addObjectsFromArray:workOrderListModel.doc];
                [_workOrderTableView reloadData];
                [SVProgressHUD dismiss];
            }else{
                if ([_dataSourceArray count]) {
                    [SVProgressHUD showErrorWithStatus:workOrderListModel.retinfo];
                }else{
                    [self.noResultView initialWithTipText:workOrderListModel.retinfo];
                    [self.noResultView setHidden:NO];
                    [SVProgressHUD dismiss];
                }
                [self endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if ([_dataSourceArray count]) {
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }else{
            [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
            [self.noResultView setHidden:NO];
            [SVProgressHUD dismiss];
        }
        [self endRefreshing];
    }];
}


/**
 *  取消请求动画
 */
- (void)endRefreshing{
    if (_isPulling) {
        [_workOrderTableView headerEndRefreshing];
    }else{
        [_workOrderTableView footerEndRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataSourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell refrashDataWithWorkOrderModel:(WorkOrderModel *)_dataSourceArray[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    } else {
        return 12.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkOrderDetailViewController *myWorkOrderDetailVC = [[MyWorkOrderDetailViewController alloc] init];
    myWorkOrderDetailVC.title = @"我的工单";
    myWorkOrderDetailVC.workOrderModel = (WorkOrderModel *)self.dataSourceArray[indexPath.section];
    myWorkOrderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWorkOrderDetailVC animated:YES];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
