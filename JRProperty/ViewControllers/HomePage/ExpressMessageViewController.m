//
//  ExpressMessageViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ExpressMessageViewController.h"
#import "ExpressMessageTableViewCell.h"
#import "JRDefine.h"
#import "PackageService.h"
#import "MJRefresh.h"
#import "LoginManager.h"
#import "PackageListModel.h"
#import "NoResultView.h"
#import "SVProgressHUD.h"
static NSString *cellIndentifier = @"ExpressMessageTableViewCellIndentifier";

@interface ExpressMessageViewController ()

@property (strong, nonatomic) NSMutableArray * dataSourceArray;     // 列表数据源
@property (strong, nonatomic) PackageService * packageService;      // 邮包查询服务类
@property (nonatomic, strong) NoResultView * noResultView;          // 哭脸
@property (assign, nonatomic) NSInteger page;                       // 页数
@property (assign, nonatomic) BOOL      isPulling;                  // 刷新标示
@property (assign, nonatomic) BOOL      hasMore;                    // 更多数据标示

@end

@implementation ExpressMessageViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

/**
 *  配置数据
 */
- (void)config{
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.packageService = [[PackageService alloc] init];
    _isPulling = YES;
    _page = 1;
    _hasMore = YES;
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
//    [self.noResultView setCenter:CGPointMake(self.view.center.x, self.view.center.y - 50)];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
    [self requestExpressMessageWithPage:_page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_kuaidi"]];

    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    UINib *cellNib = [UINib nibWithNibName:@"ExpressMessageTableViewCell" bundle:nil];
    [self.expressMsgTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    
    [self config];
    
    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = _expressMsgTableView;
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        _isPulling = YES;
        _page = 1;
        _hasMore = YES;
        [self requestExpressMessageWithPage:_page];
        if (_expressMsgTableView.footerHidden) {
            [_expressMsgTableView setFooterHidden:NO];
        }
    }];
    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        _isPulling = NO;
        if (_hasMore) {
            [self requestExpressMessageWithPage:++_page];
        }
    }];
    
}

/**
 *  快递信息请求服务器
 *
 *  @param page 页数
 */
- (void)requestExpressMessageWithPage:(NSInteger)page{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.packageService Bus100601:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId type:@"0" page:[NSString stringWithFormat:@"%d",page] num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[PackageListModel class]]) {
            PackageListModel *packageListModel = (PackageListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:packageListModel.retcode]) {
                [SVProgressHUD dismiss];
                if (_isPulling) {
                    [_dataSourceArray removeAllObjects];
                    [_expressMsgTableView headerEndRefreshing];
                    if(packageListModel.doc.count == 0) {
                        [self.noResultView initialWithTipText:@"暂无快递信息"];
                        [self.noResultView setHidden:NO];
                    }
                }else{
                    [_expressMsgTableView footerEndRefreshing];
                }
                if (packageListModel.doc.count < 10) {
                    _hasMore = NO;
                    [_expressMsgTableView setFooterHidden:YES];
                    [_expressMsgTableView footerEndRefreshing];
                }
                [_dataSourceArray addObjectsFromArray:packageListModel.doc];
                [_expressMsgTableView reloadData];
            }else{
                if ([_dataSourceArray count]) {
                    [SVProgressHUD showErrorWithStatus:packageListModel.retinfo];
                }else{
                    [SVProgressHUD dismiss];
                    [self.noResultView initialWithTipText:packageListModel.retinfo];
                    [self.noResultView setHidden:NO];
                }
                [self endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if ([_dataSourceArray count]) {
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }else{
            [SVProgressHUD dismiss];
            [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
            [self.noResultView setHidden:NO];
        }
        [self endRefreshing];
    }];
}

/**
 *  停止数据刷新UI
 */
- (void)endRefreshing{
    if (_isPulling) {
        [_expressMsgTableView headerEndRefreshing];
    }else{
        [_expressMsgTableView footerEndRefreshing];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataSourceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpressMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell refrashDataWithPackageModel:(PackageModel *)self.dataSourceArray[indexPath.section]];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
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
