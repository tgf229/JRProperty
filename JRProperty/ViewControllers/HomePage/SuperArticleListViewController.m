//
//  SuperArticleListViewController.m
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "SuperArticleListViewController.h"
#import "SuperArticleTableViewCell.h"
#import "JRDefine.h"
#import "CircleListModel.h"
#import "NeighborService.h"
#import "MoveArticleService.h"
#import "LoginManager.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

static NSString *cellIndentifier = @"SuperArticleTableViewCellIdentifier";
@interface SuperArticleListViewController ()<SuperArticleTableViewCellDelegate>
@property (nonatomic, strong) NeighborService * neighborService;
@property (nonatomic, strong) MoveArticleService * moveArticleService;
@property (nonatomic, strong) NSMutableArray * dataSourceArray;
@property (nonatomic, strong) CircleInfoModel * tempModel;

@property (assign, nonatomic) NSInteger page;                       // 页数
@property (assign, nonatomic) BOOL      isPulling;                  // 刷新标示
@property (assign, nonatomic) BOOL      hasMore;                    // 更多数据标示
@end

@implementation SuperArticleListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:@"SuperArticleTableViewCell" bundle:nil];
    [self.mainTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [postButton setFrame:CGRectMake(0, 0, 50+ 22, 24)];
    }
    else{
        [postButton setFrame:CGRectMake(0, 0,50, 20)];
    }
    
    [postButton setTitle:@"确定"  forState:UIControlStateNormal];
    [postButton setTitle:@"确定"  forState:UIControlStateHighlighted];
    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    postButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [postButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.neighborService = [[NeighborService alloc] init];
    self.moveArticleService = [[MoveArticleService alloc] init];
    _isPulling = YES;
    _page = 1;
    _hasMore = YES;
    
    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = _mainTableView;
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        _isPulling = YES;
        _page = 1;
        _hasMore = YES;
        [self requestExpressMessageWithPage:_page];
        if (_mainTableView.footerHidden) {
            [_mainTableView setFooterHidden:NO];
        }
    }];
    
    [weaktb addFooterWithCallback:^{
        // 调用网络请求
        _isPulling = NO;
        if (_hasMore) {
            [self requestExpressMessageWithPage:++_page];
        }
    }];
    
    [self requestExpressMessageWithPage:_page];
}

- (void)requestExpressMessageWithPage:(NSInteger)page{
    NSString  *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.neighborService Bus300201:CID_FOR_REQUEST uId:uid type:@"5" page:[NSString stringWithFormat:@"%ld",(long)page] num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[CircleListModel class]]) {
            CircleListModel *packageListModel = (CircleListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:packageListModel.retcode]) {
                [SVProgressHUD dismiss];
                if (_isPulling) {
                    [_dataSourceArray removeAllObjects];
                    [_mainTableView headerEndRefreshing];
                    if(packageListModel.doc.count == 0) {
//                        [self.noResultView initialWithTipText:@"暂无快递信息"];
//                        [self.noResultView setHidden:NO];
                    }
                }else{
                    [_mainTableView footerEndRefreshing];
                }
                if (packageListModel.doc.count < 10) {
                    _hasMore = NO;
                    [_mainTableView setFooterHidden:YES];
                    [_mainTableView footerEndRefreshing];
                }
                [_dataSourceArray addObjectsFromArray:packageListModel.doc];
                [_mainTableView reloadData];
            }else{
                if ([_dataSourceArray count]) {
                    [SVProgressHUD showErrorWithStatus:packageListModel.retinfo];
                }else{
                    [SVProgressHUD dismiss];
//                    [self.noResultView initialWithTipText:packageListModel.retinfo];
//                    [self.noResultView setHidden:NO];
                }
                [self endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if ([_dataSourceArray count]) {
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }else{
            [SVProgressHUD dismiss];
//            [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
//            [self.noResultView setHidden:NO];
        }
        [self endRefreshing];

    }];

}

/**
 *  停止数据刷新UI
 */
- (void)endRefreshing{
    if (_isPulling) {
        [_mainTableView headerEndRefreshing];
    }else{
        [_mainTableView footerEndRefreshing];
    }
}



- (void)clickSureButton{
    if (!self.tempModel) {
        [SVProgressHUD showErrorWithStatus:@"请选择圈子"];
        return;
    }
    
    NSString  *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.moveArticleService Bus101301:_formID toId:self.tempModel.id articleId:_articleID uId:uid success:^(id responseObject) {
        BaseModel * baseModel = (BaseModel *)responseObject;
        if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
            [SVProgressHUD showSuccessWithStatus:baseModel.retinfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGECIDNOTICE" object:nil];
            if (self.callBackBlock) {
                self.callBackBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuperArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CircleInfoModel * circleInfoModel = (CircleInfoModel *)[self.dataSourceArray objectAtIndex:indexPath.row];
    [cell refrashDataWithCircleInfoModel:circleInfoModel];
    if ([circleInfoModel.id isEqualToString:self.tempModel.id]) {
        cell.singleButton.selected = YES;
    }else{
        cell.singleButton.selected = NO;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    [view setBackgroundColor:RGB(238, 238, 238)];
    
//    UIImageView * lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
//    [lineIV setImage:[UIImage imageNamed:@"line_grey_top_40x1"]];
//    [view addSubview:lineIV];
    
    UIImageView * lineIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 34, tableView.frame.size.width, 1)];
    [lineIV1 setImage:[UIImage imageNamed:@"line_grey_foot_40x1"]];
    [view addSubview:lineIV1];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 30, 35)];
    titleLab.text = @"将此话题移动到";
    [titleLab setTextColor:UIColorFromRGB(0x000000)];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [view addSubview:titleLab];
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tempModel = nil;
    self.tempModel = (CircleInfoModel *)[self.dataSourceArray objectAtIndex:indexPath.row];
    [_mainTableView reloadData];
}

#pragma mark - SuperArticleTableViewCellDelegate

- (void)cellSingleButtonClickWithIndexPath:(NSIndexPath *)_indexPath{
//    self.tempModel = nil;
//    self.tempModel = (CircleInfoModel *)[self.dataSourceArray objectAtIndex:_indexPath.row];
//    [_mainTableView reloadData];
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
