//
//  ArticleListViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleDetailViewController.h"
#import "UserPageViewController.h"
#import "WebViewController.h"
#import "RefreshPageView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "ShareView.h"
#import "JRDefine.h"

#import "ArticleListModel.h"
#import "LoginManager.h"

#import "ArticleService.h"
#import "NeighborService.h"
#import "ShareToSnsService.h"

#import "UIColor+extend.h"
#import "SuperArticleListViewController.h"
#import "PlotSomethingNewTableViewCell.h"
#import "NewsListModel.h"
static NSString *cellIndentifier = @"PlotSomethingNewTableViewCellIndentifierlalal";

@interface ArticleListViewController ()<ShareToSnsServiceDelegate,SocialShareViewDelegate>

@property (strong,nonatomic) ArticleService          *articleService;
@property (strong,nonatomic) NeighborService         *neighborService;
@property (nonatomic,strong) ShareToSnsService       *shareService;

@property (nonatomic,strong) NSMutableArray          *largeImageArray;    //大图地址列表
@property (nonatomic,strong) NSMutableArray          *articleArray;       //话题列表

@property (strong,nonatomic) ArticleListModel        *articleListModel;   //话题列表model

@property (nonatomic,assign)  BOOL               isPulling;        // 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMore;          // 动态页面 还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMore;      // 上拉加载更多标志
@property (nonatomic,assign)  int                page;            // 页数
@property (nonatomic,strong)  NSIndexPath        *sharedIndexPath;// 分享的话题所在行号
@property (nonatomic,assign)  long clickRow;

@property (strong,nonatomic)  RefreshPageView       *refreshPage; // 重新加载 错误页面
@property (nonatomic,strong)  ShareView    *shareView;// 分享页面
@property (strong,nonatomic)  UIView  *footerView;//列表结束提示图片


@end

@implementation ArticleListViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //换小区通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshForChangeCid) name:@"CHANGEPROPERTYINFO" object:nil];
    //登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshForChangeCid) name:LOGIN_SUCCESS  object:nil];
    //页面底色
    [self.view setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    UINib *cellNib = [UINib nibWithNibName:@"PlotSomethingNewTableViewCell" bundle:nil];
    [self.articleTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];

    //初始化
    self.articleArray = [[NSMutableArray alloc]init];
    self.largeImageArray = [[NSMutableArray alloc]init];

    self.articleService = [[ArticleService alloc]init];
    self.neighborService = [[NeighborService alloc]init];
    self.articleListModel = [[ArticleListModel alloc]init];
    self.shareService = [[ShareToSnsService alloc] init];
    self.sharedIndexPath = [[NSIndexPath alloc] init];
    //创建错误提示页面
    self.refreshPage = [[[NSBundle mainBundle] loadNibNamed:@"RefreshPageView" owner:self options:nil]objectAtIndex:0];
    [self.refreshPage initial];
    if (CURRENT_VERSION<7) {
        self.refreshPage.frame = CGRectMake(0,UIScreenHeight/2-150, UIScreenWidth, 200);
    }
    else {
        self.refreshPage.frame = CGRectMake(0,UIScreenHeight/2-90, UIScreenWidth, 200);
    }    __weak ArticleListViewController * weakArticleListViewController = self;
    self.refreshPage.callBackBlock = ^(){
        //[weakArticleListViewController.refreshPage setHidden:YES];
        [weakArticleListViewController requestArticleWithPage:@"1" Time:nil];
    };
    [self.refreshPage setHidden:YES];
    [self.view addSubview:self.refreshPage];
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
    UIImageView *endTip = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth/2-18, 7.5, 36, 15)];
    endTip.image = [UIImage imageNamed:@"end_tips_60x42"];
    [self.footerView addSubview:endTip];
    //设置表格
    [self createTableview];
    //请求话题 第一次请求 第一页
    [self requestArticleWithPage:@"1" Time:nil];

}

- (void)refreshForChangeCid {
    [self.articleTableView headerBeginRefreshing];
}


/**
 *  设置表格
 */
- (void)createTableview {
    //表格
    self.articleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.articleTableView.backgroundColor = [UIColor clearColor];
    self.articleTableView.delegate = self;
    self.articleTableView.dataSource = self;
//    self.articleTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    self.articleTableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    self.articleTableView.showsVerticalScrollIndicator = YES;

    [self.articleTableView addHeaderWithCallback:^{
        [self.refreshPage setHidden:YES];
        [self.footerView setHidden:YES];
        self.isPulling = YES;
        // 调用网络请求
        [self requestArticleWithPage:@"1" Time:nil];
    }];
    [self.articleTableView addFooterWithCallback:^{
        if (self.hasMore) {
            self.isLoadMore = YES;
            NSString *page = [NSString stringWithFormat:@"%d",self.page+1];
            [self requestArticleWithPage:page Time:self.articleListModel.queryTime];
        }
    }];
    [self.articleTableView setHidden:YES];
}

/**
 *  请求话题
 *
 *  @param page 页数
 *  @param queryTime 时间
 */
- (void) requestArticleWithPage:(NSString *)page Time:(NSString *)queryTime {
    self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (!self.isPulling &&!self.isLoadMore) {
        [self.refreshPage setHidden:YES];
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.neighborService Bus300301:CID_FOR_REQUEST uId:uid queryTime:queryTime page:page num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;

        self.articleListModel= (ArticleListModel *)responseObject;
        [self success];
    } failure:^(NSError *error) {
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
        [SVProgressHUD dismiss];
        if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
            [self.articleTableView setHidden:YES];
            [self.refreshPage setHidden:NO];
            self.refreshPage.tipLabel.text = @"暂无圈子动态，点击重试";
        }
        else {
            if(self.articleArray.count == 0) {
                //列表为空
                [SVProgressHUD dismiss];
                [self.refreshPage setHidden:NO];
            }
            else {
                [self.articleTableView setHidden:NO];
                [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
            }
        }
        if (self.isPulling) {
            // 请求回来后，停止刷新
            [self.articleTableView headerEndRefreshing];
            self.isPulling = NO;
        }
        else if (self.isLoadMore) {
            self.isLoadMore = NO;
            self.hasMore = YES;
            [self.articleTableView footerEndRefreshing];
        }
    }];
}

/**
 *  请求话题成功处理
 */
- (void)success {
    if ([self.articleListModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
        [SVProgressHUD dismiss];
        if (self.isPulling) {
            self.page = 1;
            //清空原数据  放入新数据  判断是否还有更多
            [self.articleArray removeAllObjects];
        }
        // 上滑加载更多
        else if (self.isLoadMore) {
            self.page = self.page +1 ;
        }
        //第一次请求
        else {
            self.page = 1;
        }
        if(self.articleListModel.doc.count < 10){
            self.hasMore = NO;
            [self.articleTableView removeFooter];
            self.articleTableView.tableFooterView = self.footerView;
            [self.articleTableView.tableFooterView setHidden:NO];
        }
        else{
            self.hasMore = YES;
            [self.articleTableView.tableFooterView setHidden:YES];
            [self.articleTableView addFooterWithCallback:^{
                if (self.hasMore) {
                    self.isLoadMore = YES;
                    NSString *page = [NSString stringWithFormat:@"%d",self.page+1];
                    [self requestArticleWithPage:page Time:self.articleListModel.queryTime];
                }
            }];
        }
        [self.articleArray addObjectsFromArray:self.articleListModel.doc];
        if(self.articleArray.count == 0) {
            //列表为空
            [self.refreshPage setHidden:NO];
            self.refreshPage.tipLabel.text = @"暂无圈子动态，点击重试";
            [self.footerView setHidden:YES];
        }
        else {
            [self.refreshPage setHidden:YES];
            [self.articleTableView setHidden:NO];
        }
        [self.articleTableView reloadData];
    }
    else {
        if (self.isLoadMore) {
            self.hasMore = YES;
        }
        if(self.articleArray.count == 0) {
            //列表为空
            [SVProgressHUD dismiss];
            [self.refreshPage setHidden:NO];
            self.refreshPage.tipLabel.text = self.articleListModel.retinfo;

        }
        else {
            [self.articleTableView setHidden:NO];
            [SVProgressHUD showErrorWithStatus:self.articleListModel.retinfo];
        }
    }
    if (self.isPulling) {
        // 请求回来后，停止刷新
        [self.articleTableView headerEndRefreshing];
        self.isPulling = NO;
    }
    else if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.articleTableView footerEndRefreshing];
    }
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        [self.articleArray removeAllObjects];
        [self.articleTableView setHidden:YES];
        [self.refreshPage setHidden:NO];
    }
}




#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    CGFloat rowHight = [ArticleTableViewCell height:model];
    return 136;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * identify = @"ArticleTableViewCell";
//
//    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    
//    if (cell == nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]objectAtIndex:0];
//    }
//    cell.backgroundColor = [UIColor getColor:@"eeeeee"];
//    cell.delegate = self;
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setIsDetailPage:NO];
//    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
//    [cell setData:model createUid:nil];
//    return cell;
    
    PlotSomethingNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell refrashDataSourceWithNewsModel:(NewsModel *)[self.articleArray objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}



#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleId = model.articleId;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ArticleTableViewcell Delegate

/**
 *  投票
 *
 *  @param articleId 话题id
 *  @param   type   0 反对  1 支持
 */
- (void)voteClick:(ArticleVoteView *)voteView atIndex:(NSUInteger)index withArticleId:(NSString *)articleId type:(NSString *)type {
    ArticleDetailModel *model = [self.articleArray objectAtIndex:index];
    
    //反对
    if ([type integerValue]==0) {
        model.voteFlag = @"2";
        model.no = [NSString stringWithFormat:@"%d",[model.no intValue]+1];
    }
    //支持
    else  {
        model.voteFlag = @"1";
        model.yes = [NSString stringWithFormat:@"%d",[model.yes intValue]+1];
    }
    [self.articleTableView reloadData];
    [self.articleService Bus301001:[LoginManager shareInstance].loginAccountInfo.uId aId:articleId type:type success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  评论触发  跳转到话题详情页面
 *
 *  @param article  话题
 */
-(void) commentClick:(ArticleDetailModel*) data {
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
    controller.articleDetailModel = data;
    controller.articleId = data.articleId;
    controller.hidesBottomBarWhenPushed = YES;
    controller.onlyComment = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  点赞
 *
 *  @param articleId   话题id
 *  @param indexPath 行号
 */
- (void)praise:(NSString *)articleId forIndexPath:(NSIndexPath *)indexPath {
    //设置UI 点赞取消 再发请求 不管请求失败与否
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    model.flag = @"1";
    int number = [model.praiseNum intValue]+1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    model.praiseNum =numberStr;
    [self.articleTableView reloadData];
    //请求服务 赞
    NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;
   
    [self.articleService Bus300801:uid aId:articleId type:@"1" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  取消赞
 *
 *  @param articleId   话题id
 *  @param indexPath 行号
 */
- (void)cancelPraise:(NSString *)articleId forIndexPath:(NSIndexPath *)indexPath {
    //设置UI 点赞取消 再发请求 不管请求失败与否
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    model.flag = @"0";
    int number = [model.praiseNum intValue]-1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    model.praiseNum =numberStr;
    [self.articleTableView reloadData];
    //请求服务 取消赞

    [self.articleService Bus300801:[LoginManager shareInstance].loginAccountInfo.uId aId:articleId type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  话题发布者头像 触发 跳转到用户个人中心页面
 *
 *  @param userId   uid
 */
- (void)userHeadClick:(NSString *)userId {
    UserPageViewController *controller = [[UserPageViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.queryUid = userId;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  打图预览
 *
 *  @param index   图片下标
 *  @param info   大图地址列表
 */
- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    [self.largeImageArray removeAllObjects];
    [self.largeImageArray addObjectsFromArray:info];

    PhotosViewController      *photos = [[PhotosViewController alloc] init];
    photos.delegate = self;
    photos.datasource = self;
    photos.currentPage = (int)index;
    photos.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photos animated:YES];
}

/**
 *  分享触发 弹出分享页面
 *
 *  @param articleId   话题id
 *  @param indexPath   话题行号
 */
- (void)shareArticle:(NSString *)articleId forIndexPath:(NSIndexPath *)indexPath {
    self.sharedIndexPath = indexPath;
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue] == 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:NO isTop:NO];
    self.shareView.delegate = self;
    [self.shareView show];
}

- (void)selectUrl:(NSURL *)url {
  
    WebViewController *controller = [[WebViewController alloc]init];
    controller.url = url;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark - 分享  SocialShareViewDelegate

//分享
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType {
    [self.shareView dismissPage];
    
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:self.clickRow];
    
    self.shareService.actID = articleModel.articleId;
    self.shareService.delegate = self;
    NSData *imageData = nil;
    NSData *bigImageData=nil;
    if (articleModel.imageList.count>0) {
        ImageModel *image = [articleModel.imageList objectAtIndex:0];
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlS]];
        bigImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlL]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_ARTICLE_URL,articleModel.articleId];
    
    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",articleModel.name,articleModel.content,urlStr];
    
    [self.shareService showSocialPlatformIn:self
                                 shareTitle:articleModel.name
                                  shareText:articleModel.content
                                   shareUrl:urlStr
                            shareSmallImage:imageData
                              shareBigImage:bigImageData
                           shareFullMessage:fullMessage
                             shareToSnsType:platformType];
}

//举报 移动
- (void)didSelectOperationButton:(ArticleOperationType)operationType {
    [self.shareView dismissPage];
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:self.clickRow];
    //举报话题
    if (operationType == ArticleReport) {
        if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
            ReportViewController *controller = [[ReportViewController alloc]init];
            controller.articleId = articleModel.articleId;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            loginAlert.tag = 1;
            
            [loginAlert show];
        }
    }
    //移动话题
    else {
        // dw add
        SuperArticleListViewController  * vc = [[SuperArticleListViewController alloc] init];
        vc.title = @"移动";
        vc.formID = articleModel.id;
        vc.articleID = articleModel.articleId;
        vc.callBackBlock = ^(){
            // 刷新吗？
//            [self.articleArray removeObjectAtIndex:self.sharedIndexPath.row];
//            [self.articleTableView reloadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        // dw end
    }
}
#pragma  mark - ShareToSnsServiceDelegate

/**
 *  分享成功
 */
- (void)shareToSnsPlatformSuccessed
{
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:self.clickRow];

    [self.articleService Bus300901:articleModel.articleId success:^(id responseObj){
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            // 分享次数+1
            ArticleDetailModel *model = [self.articleArray objectAtIndex:self.clickRow];
            model.shareNum =[NSString stringWithFormat:@"%d",[model.shareNum intValue]+1] ;
            [self.articleTableView reloadData];
        }
        
    }failure:^(NSError *error){
        
    }];

}

#pragma mark - PlotSonethingNewTableViewCellDelegate


/**
 *  举报新鲜事儿
 *
 *  @param indexPath
 */
- (void)reportImageViewSelected:(NSIndexPath *)indexPath
{
    [SVProgressHUD showSuccessWithStatus:@"您的举报已受理，我们会尽快处理您的举报"];
}

/**
 *  新鲜事儿来自哪儿
 *
 *  @param indexPath
 */
- (void)fromHereButtonSelected:(NSIndexPath *)indexPath
{
    
}


// 点赞触发
-(void) praiseClick:(NSString*) articleId withSection:(NSInteger)section
{
    //设置UI 点赞取消 再发请求 不管请求失败与否
    ArticleDetailModel *model = [self.articleArray objectAtIndex:section];
    model.flag = @"1";
    int number = [model.praiseNum intValue]+1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    model.praiseNum =numberStr;
    [self.articleTableView reloadData];
    //请求服务 赞
    NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;
    
    [self.articleService Bus300801:uid aId:articleId type:@"1" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}
// 取消赞触发
-(void) cancelPraiseClick:(NSString*) articleId withSection:(NSInteger)section
{
    //设置UI 点赞取消 再发请求 不管请求失败与否
    ArticleDetailModel *model = [self.articleArray objectAtIndex:section];
    model.flag = @"0";
    int number = [model.praiseNum intValue]-1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    model.praiseNum =numberStr;
    [self.articleTableView reloadData];
    //请求服务 取消赞
    
    [self.articleService Bus300801:[LoginManager shareInstance].loginAccountInfo.uId aId:articleId type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}
// 分享
- (void)shareArticle:(NSString *)articleId withSection:(NSInteger)section
{
    self.clickRow = section;
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue] == 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:NO isTop:NO];
    self.shareView.delegate = self;
    [self.shareView show];
}


#pragma mark - PhotosViewsDelgate's  and PhotosViewsDatasource's  methods

- (void)photosViewBackAtIndex:(NSInteger)index
{
    
}


- (NSInteger)photosViewNumberOfCount {
    return self.largeImageArray.count;
}


- (NSString *)photosViewUrlAtIndex:(NSInteger)index {
    return [self.largeImageArray objectAtIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
