//
//  ReplyMessageViewController.m
//  JRProperty
//
//  Created by tingting zuo on 15-3-31.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "ReplyMessageViewController.h"

#import "NoResultView.h"
#import "ReplyListModel.h"
#import "UIColor+extend.h"
#import "SVProgressHUD.h"
#import "NewReplyTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "MemberService.h"
#import "LoginManager.h"
#import "JRDefine.h"
#import "MJRefresh.h"
#import "MessageDataManager.h"

@interface ReplyMessageViewController ()

@property (nonatomic,strong)  NoResultView       *noResultView;    // 报错页面
@property (strong,nonatomic)  MemberService      *memberService;
@property (nonatomic,strong)  ReplyListModel     *replyListModel;
@property (nonatomic,strong)  NSMutableArray     *showArray;
@property (nonatomic,strong)  NSMutableArray     *localArray;
@property (nonatomic,assign)  BOOL               isPulling;        // 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMore;          //   还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMore;      // 上拉加载更多标志
@property (nonatomic,assign)  int                page;            // 页数
@property (nonatomic,assign)  int                currentShowNumber;            //当前

@end

@implementation ReplyMessageViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}



- (void)viewDidLoad {
    self.title = @"评论消息";
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"circleMessageNumber"];
    [super viewDidLoad];
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_pinglunxiaoxi"]];
    self.navigationItem.titleView = iv;
    self.showArray = [[NSMutableArray alloc]init];
    self.localArray = [[NSMutableArray alloc]init];
    self.memberService = [[MemberService alloc]init];
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
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
    //设置表格
    [self createTableView];
    [self requestMessageList];  
}
/**
 *  设置表格
 */
- (void)createTableView {
    self.page = 1;
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (CURRENT_VERSION<8) {
        self.topConstraint.constant = 0;
    }
    else {
        self.topConstraint.constant = 64;
    }
    self.messageTableView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.messageTableView.showsVerticalScrollIndicator = YES;
    self.messageTableView.userInteractionEnabled = YES;
    [self.messageTableView addHeaderWithCallback:^{
        self.isPulling = YES;
        self.page = 1;
        [self requestMessageList];
    }];
    [self.messageTableView addFooterWithCallback:^{
        if (self.hasMore) {
            self.isLoadMore = YES;
            self.page = self.page+1;
            [self loadMoreLocalData:self.page];
        }
    }];
    [self.messageTableView setHidden:YES];
}

- (void)requestMessageList {
    if (!self.isPulling ) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString  *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.memberService Bus302101:uid cId:CID_FOR_REQUEST success:^(id responseObject) {
        self.replyListModel = (ReplyListModel *)responseObject;
        if ([self.replyListModel.retcode isEqualToString:@"000000"]) {
            [SVProgressHUD dismiss];
            if (self.replyListModel.doc.count != 0) {
                [[MessageDataManager defaultManager]insertCircleReply:self.replyListModel userId:uid cId:CID_FOR_REQUEST];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:self.replyListModel.retinfo];
        }
        if (self.isPulling) {
            // 请求回来后，停止刷新
            [self.messageTableView headerEndRefreshing];
            self.isPulling = NO;
        }
        self.localArray = [[MessageDataManager defaultManager]queryCircleReply:[LoginManager shareInstance].loginAccountInfo.uId cId:CID_FOR_REQUEST Page:1];
        NSLog(@"self.loca num %d",self.localArray.count);
//        if (self.localArray.count<10) {
//            self.hasMore = NO;
//            [self.messageTableView removeFooter];
//        }
//        else {
//            self.hasMore = YES;
//            [self.messageTableView addFooterWithCallback:^{
//                if (self.hasMore) {
//                    self.isLoadMore = YES;
//                    self.page = self.page+1;
//                    [self loadMoreLocalData:self.page];
//                }
//            }];
//        }
        if(self.localArray.count == 0) {
            [self.noResultView initialWithTipText:NONE_DATA_MESSAGE];
            [self.noResultView setHidden:NO];
        }
        else {
            [self.noResultView setHidden:YES];
            [self.messageTableView setHidden:NO];

            [self.showArray removeAllObjects];
            if (self.localArray.count<=10) {
                [self.showArray addObjectsFromArray:self.localArray];
                self.hasMore = NO;
                [self.messageTableView removeFooter];
            }
            else {

                for (int i=0; i<10; i++) {
                    [self.showArray addObject:[self.localArray objectAtIndex:i]];
                }
                self.currentShowNumber = 10;
                self.hasMore = YES;
                [self.messageTableView addFooterWithCallback:^{
                    if (self.hasMore) {
                        self.isLoadMore = YES;
                        self.page = self.page+1;
                        [self loadMoreLocalData:self.page];
                    }
                }];
            }
            
        }
        [self.messageTableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        if (self.isPulling) {
            // 请求回来后，停止刷新
            [self.messageTableView headerEndRefreshing];
            self.isPulling = NO;
        }
        self.localArray = [[MessageDataManager defaultManager]queryCircleReply:[LoginManager shareInstance].loginAccountInfo.uId cId:CID_FOR_REQUEST Page:1];
        if(self.localArray.count == 0) {
            [self.noResultView initialWithTipText:NONE_DATA_MESSAGE];
            [self.noResultView setHidden:NO];
        }
        else {
            [self.noResultView setHidden:YES];
            [self.messageTableView setHidden:NO];
            
            [self.showArray removeAllObjects];
            if (self.localArray.count<=10) {
                [self.showArray addObjectsFromArray:self.localArray];
                self.hasMore = NO;
                [self.messageTableView removeFooter];
            }
            else {
                for (int i=0; i<10; i++) {
                    [self.showArray addObject:[self.localArray objectAtIndex:i]];
                }
                self.currentShowNumber = 10;

                self.hasMore = YES;
                [self.messageTableView addFooterWithCallback:^{
                    if (self.hasMore) {
                        self.isLoadMore = YES;
                        self.page = self.page+1;
                        [self loadMoreLocalData:self.page];
                    }
                }];
            }
        }
        [self.messageTableView reloadData];
    }];
    
}

- (void)loadMoreLocalData:(int)page {

    if (self.localArray.count-self.currentShowNumber<=10) {
        for (int i=self.currentShowNumber; i<self.localArray.count; i++) {
            [self.showArray addObject:[self.localArray objectAtIndex:i]];
        }
        self.currentShowNumber = self.localArray.count;
        self.hasMore = NO;
        [self.messageTableView removeFooter];
    }
    else {
        self.hasMore = YES;
        for (int i=self.currentShowNumber; i<self.currentShowNumber+10; i++) {
            [self.showArray addObject:[self.localArray objectAtIndex:i]];
        }
        self.currentShowNumber = self.showArray.count;

        [self.messageTableView addFooterWithCallback:^{
            if (self.hasMore) {
                self.isLoadMore = YES;
                self.page = self.page+1;
                [self loadMoreLocalData:self.page];
            }
        }];
    }
    if (self.isLoadMore) {
        [self.messageTableView footerEndRefreshing];
        self.isLoadMore = NO;
    }
    [self.messageTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NewReplyTableViewCell height:(ReplyModel*)[self.showArray objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"ReplyTableViewCell";
    NewReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewReplyTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置代理
    //cell.delegate = self;
    //获取数据
    ReplyModel * info = (ReplyModel*)[self.showArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.showArray.count -1) {
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
    ReplyModel *model = (ReplyModel*)[self.showArray objectAtIndex:indexPath.row];
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleId = model.articleId;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
