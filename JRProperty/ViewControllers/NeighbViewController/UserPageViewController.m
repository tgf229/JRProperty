//
//  UserPageViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-12-1.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  圈子 个人中心

#define karticleListType   0  //话题列表
#define kCircleListType   1    //关注列表
#define kMyCircleType     2    //管理的列表

#import "UserPageViewController.h"
#import "CircleListViewController.h"
#import "CircleListTableViewCell.h"
#import "EditUserInfoViewController.h"
#import "ArticleDetailViewController.h"
#import "CircleDetailViewController.h"
#import "LoginViewController.h"
#import "ArticleTableViewCell.h"
#import "WebViewController.h"
 
#import "NoResultView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "JRPropertyUntils.h"

#import "NeighborService.h"
#import "MemberService.h"
#import "ArticleService.h"
#import "UserService.h"

#import "CircleListModel.h"
#import "ArticleListModel.h"
#import "CommunityModel.h"
#import "LoginManager.h"

#import "UIImageView+WebCache.h"
//#import "PopSocialShareView.h"
#import "ShareToSnsService.h"
#import "SuperArticleListViewController.h"
#import "PlotSomethingNewTableViewCell.h"
#import "NewsListModel.h"
static NSString *cellIndentifier = @"PlotSomethingNewTableViewCellIndentifierlalal";


@interface UserPageViewController ()<ShareToSnsServiceDelegate,SocialShareViewDelegate>


@property (nonatomic,strong)  NSMutableArray     *circleArray;        // 关注的圈子数组
@property (nonatomic,strong)  NSMutableArray     *hisManageArray;     // 管理的管子数组
@property (nonatomic,strong)  NSMutableArray     *articleArray;       // 话题数组
@property (nonatomic,strong)  NSMutableArray      *largeImageArray;    //大图地址列表（用于大图预览）

@property (nonatomic,assign)  BOOL               isPullArticle;         // 话题 下拉刷新标志
@property (nonatomic,assign)  BOOL               isPullJoinCircle;      // 关注圈子 下拉刷新标志
@property (nonatomic,assign)  BOOL               isPullManageCircle;    // 管理的圈子 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMoreArticle;        // 话题 还有更多
@property (nonatomic,assign)  BOOL               isLoadMoreArticle;     // 话题上拉加载标志
@property (nonatomic,assign)  int                pagForArticle;         // 话题页数
@property (nonatomic,assign)  BOOL               hasMoreCircle;         // 关注的圈子页面 还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMoreCircle;      // 关注的圈子上拉加载更多标志
@property (nonatomic,assign)  int                pagForCircle;          // 关注的圈子页数

@property (strong,nonatomic)  NeighborService     *neighborService; //邻里service
@property (strong,nonatomic)  MemberService       *memberService;
@property (strong,nonatomic)  ArticleService      *articleService;
@property (strong,nonatomic)  UserService         *userService;


@property (nonatomic,strong) CircleListModel      *circleListModel;  //关注的圈子列表model
@property (nonatomic,strong) ArticleListModel     *articleListModel; //话题列表model
@property (nonatomic,strong) MemberModel          *memberModel;      //用户信息model

@property (nonatomic,assign) NSInteger            tableViewType;   //表格type   0话题列表  1关注列表  2管理的列表
@property (nonatomic,retain) UIImageView          *slideImageView;       // 游动的红线切换指示视图

//@property (nonatomic,assign)    int contentOffsetY;         //滚动初始点

@property (nonatomic,strong) ShareView      *shareView;  //分享页面
@property (nonatomic,strong) ShareToSnsService       *shareService; //分享service
@property (nonatomic,strong) NSIndexPath             *sharedIndexPath;//分享的话题所在行号
@property (nonatomic,strong)  NoResultView     *articleNoResultView;//话题错误页面
@property (nonatomic,strong)  NoResultView     *circleNoResultView; //关注列表错误页面
@property (nonatomic,strong)  NoResultView     *manageNoResultView; //管理列表错误页面

@property (nonatomic,assign)  BOOL               hasRequestCircle;       //已经请求过关注列表
@property (nonatomic,assign)  BOOL               hasRequestManager;      //已经请求过管理列表
@property (nonatomic,assign)  long clickRow;


@end

@implementation UserPageViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES]; //隐藏导航栏
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];

//    [[self navigationController] setNavigationBarHidden:NO animated:YES];//显示导航栏
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 *  标题栏右侧按钮
 */
- (void)createPostButton {
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [postButton setFrame:CGRectMake(0, 0, 32+ 22, 24)];
    }
    else{
        [postButton setFrame:CGRectMake(0, 0,32, 20)];
    }
    
//    [postButton setTitle:@"设置"  forState:UIControlStateNormal];
//    [postButton setTitle:@"设置"  forState:UIControlStateHighlighted];
    [postButton setImage:[UIImage imageNamed:@"title_red_shezhi"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"title_red_shezhi"] forState:UIControlStateHighlighted];
//    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
//    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
//    postButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [postButton addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)viewDidLoad {
    self.title = @"个人中心";
    [super viewDidLoad];
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_gerenzhongxin"]];
    self.navigationItem.titleView = iv;
    [self createPostButton];
    //接收通知 修改用户信息通知 登陆成功通知 关注或取消关注通知 创建新圈子通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestUserInfoAfertSet) name:UPDATE_USERINFO_SUCCESS  object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestUserInformationAfertLogin) name:LOGIN_SUCCESS  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestJoinList) name:UPDATE_FOR_JOINORQUIT  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestJoinCircleListAfertCreate) name:CREATE_CRICLE_SUCCESS  object:nil];
    if (CURRENT_VERSION>=7.0) {
//        self.tableViewTopContraint.constant = -20;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UINib *cellNib = [UINib nibWithNibName:@"PlotSomethingNewTableViewCell" bundle:nil];
    [self.myArticleTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];

    self.neighborService = [[NeighborService alloc]init];
    self.memberService = [[MemberService alloc]init];
    self.articleService = [[ArticleService alloc]init];
    self.userService = [[UserService alloc]init];

    self.circleArray = [[NSMutableArray alloc]init];
    self.articleArray = [[NSMutableArray alloc]init];
    self.articleListModel = [[ArticleListModel alloc]init];
    self.circleListModel = [[CircleListModel alloc]init];
    self.memberModel = [[MemberModel alloc]init];
    self.largeImageArray = [[NSMutableArray alloc]init];
    self.shareService = [[ShareToSnsService alloc] init];
    self.sharedIndexPath = [[NSIndexPath alloc] init];
    //红色滑动线
    self.slideImageView= [[UIImageView alloc] initWithFrame:CGRectMake(10, 142,( UIScreenWidth-60)/3, 2)];
    self.slideImageView.backgroundColor = [UIColor getColor:@"bb474d"];
//    self.slideImageView.image = [UIImage imageNamed:@"red_line_160x4"];
    [self.headView addSubview:self.slideImageView];
    //头像设置白色圆形外圈
//    self.headImageView.layer.masksToBounds = YES;
//    self.headImageView.layer.cornerRadius = 35;
//    CALayer *layer = [self.headImageView layer];
//    layer.borderColor = [UIColor whiteColor].CGColor;
//    layer.borderWidth = 2.0f;
    //[self.headView setHidden:YES];
    //表格
    [self createTableView];
    //进入后展示话题页面
    [self changeButtonState:karticleListType];
    //请求用户信息
    [self requestUserInformation];
    self.tableViewType = karticleListType;
    //话题哭脸视图 默认先隐藏
    self.articleNoResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.articleNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.articleNoResultView.frame = CGRectMake(0,UIScreenHeight/2-210, UIScreenWidth, 140);
    }
    else {
        self.articleNoResultView.frame = CGRectMake(0,UIScreenHeight/2-190, UIScreenWidth, 140);
    }
    [self.articleNoResultView setHidden:YES];
    [self.myArticleTableView addSubview:self.articleNoResultView];
    //关注列表哭脸视图
    self.circleNoResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.circleNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.circleNoResultView.frame = CGRectMake(0,UIScreenHeight/2-210, UIScreenWidth, 140);
    }
    else {
        self.circleNoResultView.frame = CGRectMake(0,UIScreenHeight/2-190, UIScreenWidth, 140);
    }
    [self.circleNoResultView setHidden:YES];
    [self.myArticleTableView addSubview:self.circleNoResultView];
    //管理列表哭脸视图
    self.manageNoResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.manageNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.manageNoResultView.frame = CGRectMake(0,UIScreenHeight/2-210, UIScreenWidth, 140);
    }
    else {
        self.manageNoResultView.frame = CGRectMake(0,UIScreenHeight/2-190, UIScreenWidth, 140);
    }
    [self.manageNoResultView setHidden:YES];
    [self.myArticleTableView addSubview:self.manageNoResultView];
    
    self.hasRequestCircle = NO;
    self.hasRequestManager = NO;
    
}
/**
 *  设置tableview
 */
- (void)createTableView {
    self.myArticleTableView.delegate = self;
    self.myArticleTableView.dataSource =self;
    self.myArticleTableView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.myArticleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myArticleTableView setHidden:YES];
    //下拉刷新设置
    [self.myArticleTableView addHeaderWithCallback:^{
        if (self.tableViewType == karticleListType) {
            [self.articleNoResultView setHidden:YES];
            self.isPullArticle = YES;
            [self requestUserInformationForRefresh];
//            [self requestArticleListWithPage:1 quertTime:nil];
            
        }
        else if (self.tableViewType == kCircleListType){
            [self.circleNoResultView setHidden:YES];
            self.isPullJoinCircle = YES;
            [self requestCircleListWithPage:1];
            
        }
        else {
            [self.manageNoResultView setHidden:YES];
            self.isPullManageCircle = YES;
            [self requestCircleListWithPage:1];
        }
    }];
    //上滑加载设置
    [self.myArticleTableView addFooterWithCallback:^{
        if (self.tableViewType == karticleListType) {
            if (self.hasMoreArticle) {
                self.isLoadMoreArticle = YES;
                [self requestArticleListWithPage:self.pagForArticle +1 quertTime:self.articleListModel.queryTime];
            }
        }
        else if (self.tableViewType == kCircleListType){
            if (self.hasMoreCircle) {
                self.isLoadMoreCircle = YES;
                [self requestCircleListWithPage:self.pagForCircle+1];
            }
        }
    }];
}

/**
 *  进入页面  请求用户信息
 */
- (void)requestUserInformation {
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.memberService Bus301301:[LoginManager shareInstance].loginAccountInfo.uId queryUId:self.queryUid success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.memberModel = (MemberModel *)responseObject;
        if ([self.memberModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [self.headView setHidden:NO];
            [self updateUserInformation];
            [self requestArticleListWithPage:1 quertTime:nil];
        }
        else {
            UIAlertView  *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:self.memberModel.retinfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            tipAlert.tag = 0;
            [tipAlert show];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView  *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"很抱歉，信息获取失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        tipAlert.tag =0;
        [tipAlert show];
    }];
}
/**
 *  下拉刷新  请求用户信息
 */
- (void)requestUserInformationForRefresh  {
    [self.memberService Bus301301:[LoginManager shareInstance].loginAccountInfo.uId queryUId:self.queryUid success:^(id responseObject) {
        self.memberModel = (MemberModel *)responseObject;
        if ([self.memberModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [self updateUserInformation];
            [self requestArticleListWithPage:1 quertTime:nil];
        }
        else {
            [SVProgressHUD  showErrorWithStatus:self.memberModel.retinfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD  showErrorWithStatus:@"很抱歉，信息更新失败！"];
    }];
}
/**
 *  登录成功  请求用户信息
 */
- (void)requestUserInformationAfertLogin {
    [self.myArticleTableView headerBeginRefreshing];
}
/**
 *  用户信息修改成功后刷新  请求用户信息
 */
-(void)requestUserInfoAfertSet {
    [self.memberService Bus301301:[LoginManager shareInstance].loginAccountInfo.uId queryUId:self.queryUid success:^(id responseObject) {
        self.memberModel = (MemberModel *)responseObject;
        if ([self.memberModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [self updateUserInformation];
        }
        else {
            [SVProgressHUD  showErrorWithStatus:self.memberModel.retinfo];
        }
    } failure:^(NSError *error) {
       [SVProgressHUD  showErrorWithStatus:@"很抱歉，信息更新失败！"];
    }];
}
/**
 *  创建新圈子  刷新关注的圈子列表
 */
- (void)requestJoinCircleListAfertCreate {
    if (self.tableViewType == karticleListType) {
        
    }
    else if ( self.tableViewType == kCircleListType){
        [self.myArticleTableView headerBeginRefreshing];
    }
}
/**
 *  关注或取消关注 刷新关注的圈子列表
 */
- (void)requestJoinList {
    [self.myArticleTableView headerBeginRefreshing];
}
/**
 *  填充用户信息部分
 */
- (void)updateUserInformation {
    self.nameLabel.text = self.memberModel.nickName;
    self.descLabel.text = self.memberModel.desc;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.memberModel.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    if ([self.memberModel.userLevel isEqualToString:@"1"]) {
        [self.daVip setHidden:NO];
    }
    else {
        [self.daVip setHidden:YES];
    }
    //她的个人中心
    if (![[LoginManager shareInstance].loginAccountInfo.uId isEqualToString:self.queryUid]) {
        self.headImageView.userInteractionEnabled = NO;
        [self.articleButton setTitle:@"他的话题" forState:UIControlStateNormal];
        [self.joinListButton setTitle:@"他的关注" forState:UIControlStateNormal];
        [self.myCircleBuuton setTitle:@"他管理的圈子" forState:UIControlStateNormal];
//        [self.setButton setHidden:YES];
        self.navigationItem.rightBarButtonItem = nil;
        self.hisManageArray = [[NSMutableArray alloc]init];
        
    }
    //自己的个人中心
    else {
//        [self.setButton setHidden:NO];
        [self createPostButton];
        [self.articleButton setTitle:@"我的话题" forState:UIControlStateNormal];
        [self.joinListButton setTitle:@"我的关注" forState:UIControlStateNormal];
        [self.myCircleBuuton setTitle:@"我管理的圈子" forState:UIControlStateNormal];
        self.headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
        [self.headImageView addGestureRecognizer:singleTap];
    }
}
/**
 *  请求话题列表
 */
- (void) requestArticleListWithPage:(int) page quertTime:(NSString *)queryTime {
    [self.myArticleTableView setHidden:NO];
    if (!self.isPullArticle && !self.isLoadMoreArticle) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString  *pageStr = [NSString stringWithFormat:@"%d",page];
    [self.memberService Bus301401:[LoginManager shareInstance].loginAccountInfo.uId queryUId:self.queryUid queryTime:queryTime page:pageStr num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.articleListModel = (ArticleListModel *)responseObject;
        if ([self.articleListModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            if (self.isPullArticle) {
                self.pagForArticle = 1;
                [self.articleArray removeAllObjects];
            }
            else if (self.isLoadMoreArticle) {
                self.pagForArticle = self.pagForArticle +1;
            }
            else {
                self.pagForArticle = 1;
            }
            [self.articleArray addObjectsFromArray:self.articleListModel.doc];
            if (self.articleListModel.doc.count<10) {
                self.hasMoreArticle = NO;
                [self.myArticleTableView removeFooter];
            }
            else {
                self.hasMoreArticle = YES ;
                [self.myArticleTableView addFooterWithCallback:^{
                    if (self.tableViewType == karticleListType) {
                        if (self.hasMoreArticle) {
                            self.isLoadMoreArticle = YES;
                            [self requestArticleListWithPage:self.pagForArticle +1 quertTime:self.articleListModel.queryTime];
                        }
                    }
                    else if (self.tableViewType == kCircleListType){
                        if (self.hasMoreCircle) {
                            self.isLoadMoreCircle = YES;
                            [self requestCircleListWithPage:self.pagForCircle+1];
                        }
                    }
                }];

            }
            if (self.articleArray.count == 0) {
                [self.articleNoResultView initialWithTipText:NONE_DATA_MESSAGE];
                [self.articleNoResultView setHidden:NO];
            }
            else {
                [self.articleNoResultView setHidden:YES];
            }
            [self.myArticleTableView reloadData];
        }
        else {
            [SVProgressHUD showErrorWithStatus:self.articleListModel.retinfo];
            if (self.articleArray.count == 0) {
                [self.articleNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
                [self.articleNoResultView setHidden:NO];
            }
            else {
                [self.articleNoResultView setHidden:YES];
            }
        }
        if (self.isPullArticle) {
            self.isPullArticle = NO;
            [self.myArticleTableView headerEndRefreshing];
        }
        else if (self.isLoadMoreArticle) {
            self.isLoadMoreArticle = NO;
            [self.myArticleTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        if (self.isPullArticle) {
            self.isPullArticle = NO;
            [self.myArticleTableView headerEndRefreshing];
        }
        else if (self.isLoadMoreArticle) {
            self.isLoadMoreArticle = NO;
            [self.myArticleTableView footerEndRefreshing];
        }
        if (self.articleArray.count == 0) {
            [self.articleNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
            [self.articleNoResultView setHidden:NO];
        }
        else {
            [self.articleNoResultView setHidden:YES];
        }
    }];
    
}

/**
 *  请求圈子列表
 *
 *  @param page      页数
 */
- (void)requestCircleListWithPage:(int)page  {
    //关注的圈子列表
    if (self.tableViewType == kCircleListType) {
        NSString  *pageStr = [NSString stringWithFormat:@"%d",page];
        if (!self.isPullJoinCircle &&!self.isLoadMoreCircle) {
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        }
        [self.neighborService Bus300201:CID_FOR_REQUEST uId:self.queryUid type:@"3" page:pageStr num:NUMBER_FOR_REQUEST success:^(id responseObject) {
            self.circleListModel = (CircleListModel *)responseObject;
            [self requestCircleListSucceed:self.circleListModel];
        } failure:^(NSError *error) {
            [self  requestCircleListFail];
        }];
    }
    //管理的圈子
    else if (self.tableViewType == kMyCircleType) {
        if (!self.isPullManageCircle ) {
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        }
         [self.neighborService Bus300201:CID_FOR_REQUEST uId:self.queryUid type:@"4" page:@"1" num:NUMBER_FOR_REQUEST success:^(id responseObject) {
            CircleListModel *circleList = (CircleListModel *)responseObject;
            if([circleList.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                [SVProgressHUD dismiss];
                [self.hisManageArray removeAllObjects];
                [self.hisManageArray addObjectsFromArray:circleList.doc];
                if (self.hisManageArray.count == 0) {
                    [self.manageNoResultView initialWithTipText:NONE_DATA_MESSAGE];
                    [self.manageNoResultView setHidden:NO];
                }
                else {
                    [self.manageNoResultView setHidden:YES];
                }
                [self.myArticleTableView reloadData];

            }else {
                if (self.hisManageArray.count == 0) {
                    [self.manageNoResultView initialWithTipText:circleList.retinfo];
                    [self.manageNoResultView setHidden:NO];
                }
                else {
                    [self.manageNoResultView setHidden:YES];
                }
                [SVProgressHUD showErrorWithStatus:circleList.retinfo];
            }
           
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
            if (self.hisManageArray.count == 0) {
                [self.manageNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
                [self.manageNoResultView setHidden:NO];
            }
            else {
                [self.manageNoResultView setHidden:YES];
            }
        }];
        if (self.isPullManageCircle) {
            self.isPullManageCircle = NO;
            [self.myArticleTableView headerEndRefreshing];
        }
    }
    
}
/**
 *  关注的列表 返回成功处理
 */
- (void)requestCircleListSucceed:(CircleListModel *)resultInfo {
    if ([resultInfo.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
        [SVProgressHUD dismiss];
        if (self.isPullJoinCircle) {
            self.pagForCircle = 1;
            [self.circleArray removeAllObjects];
        }
        // 上滑加载更多
        if (self.isLoadMoreCircle) {
            self.pagForCircle = self.pagForCircle +1 ;
        }
        //第一次请求
        else {
            self.pagForCircle = 1;
        }
        if(resultInfo.doc.count < 10){
            self.hasMoreCircle = NO;
            [self.myArticleTableView removeFooter];;
            
        }else{
            self.hasMoreCircle = YES;
            [self.myArticleTableView addFooterWithCallback:^{
                if (self.tableViewType == karticleListType) {
                    if (self.hasMoreArticle) {
                        self.isLoadMoreArticle = YES;
                        [self requestArticleListWithPage:self.pagForArticle +1 quertTime:self.articleListModel.queryTime];
                    }
                }
                else if (self.tableViewType == kCircleListType){
                    if (self.hasMoreCircle) {
                        self.isLoadMoreCircle = YES;
                        [self requestCircleListWithPage:self.pagForCircle+1];
                    }
                }
            }];

            
        }
        [self.circleArray addObjectsFromArray:resultInfo.doc];
        if (self.circleArray.count == 0) {
            [self.circleNoResultView initialWithTipText:NONE_DATA_MESSAGE];
            [self.circleNoResultView setHidden:NO];
        }
        else {
            [self.circleNoResultView setHidden:YES];
        }
        [self.myArticleTableView reloadData];
    }
    //失败
    else {
        [SVProgressHUD showErrorWithStatus:resultInfo.retinfo];
        if (self.circleArray.count == 0) {
            [self.circleNoResultView initialWithTipText:resultInfo.retinfo];
            [self.circleNoResultView setHidden:NO];
        }
        else {
            [self.circleNoResultView setHidden:YES];
        }
    }
    if (self.isPullJoinCircle) {
        self.isPullJoinCircle = NO;
        [self.myArticleTableView headerEndRefreshing];
    }
    else if (self.isLoadMoreCircle) {
        self.isLoadMoreCircle = NO;
        [self.myArticleTableView footerEndRefreshing];
    }
}

/**
 *  关注的列表 返回失败处理
 */
- (void)requestCircleListFail  {
    if (self.isPullJoinCircle) {
        self.isPullJoinCircle = NO;
        [self.myArticleTableView headerEndRefreshing];
    }
    else if (self.isLoadMoreCircle) {
        self.isLoadMoreCircle = NO;
        [self.myArticleTableView footerEndRefreshing];
    }
    [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
    if (self.circleArray.count == 0) {
        [self.circleNoResultView initialWithTipText:OTHER_ERROR_MESSAGE];
        [self.circleNoResultView setHidden:NO];
    }
    else {
        [self.circleNoResultView setHidden:YES];
    }
}


/**
 *  改变标题栏button展示
 *
 *  @param buttonType 0 动态按钮被选中 1 关注按钮被选中 2 我的
 */
- (void)changeButtonState :(NSInteger) buttonType{
    if (buttonType == karticleListType) {
        [self.articleButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
        [self.joinListButton  setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
        [self.myCircleBuuton  setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];

    }
    else if (buttonType == kCircleListType){
        [self.articleButton setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
        [self.joinListButton  setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
        [self.myCircleBuuton  setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
    }
    else {
        [self.articleButton setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
        [self.myCircleBuuton  setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
        [self.joinListButton  setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger  rowNumber;
    if (self.tableViewType == karticleListType) {
        rowNumber = self.articleArray.count;
    }
    else if (self.tableViewType == kCircleListType) {
        rowNumber = self.circleArray.count;
    }
    else  if (![[LoginManager shareInstance].loginAccountInfo.uId isEqualToString:self.queryUid] && self.tableViewType == kMyCircleType){
        rowNumber = self.hisManageArray.count;
    }
    return rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat  rowHeight;
    if (self.tableViewType == karticleListType) {
        rowHeight = [ArticleTableViewCell height:[self.articleArray objectAtIndex:indexPath.row]];
        rowHeight = 136.0f;
    }
    else {
        rowHeight = 97.0;
    }
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 12.0f)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableViewType == karticleListType) {
//        static NSString * identify = @"ArticleTableViewCell";
//
//        ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        
//        if (cell== nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]objectAtIndex:0];
//        }
//        cell.backgroundColor = [UIColor getColor:@"eeeeee"];
//        cell.delegate = self;
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell setIsDetailPage:NO];
//        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
//        [cell setData:model createUid:nil];
//        return cell;
        PlotSomethingNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell refrashDataSourceWithNewsModel:(NewsModel *)[self.articleArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;

    }
    else {
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
        CircleInfoModel * info;
        if (self.tableViewType == kMyCircleType) {
            [cell setType:kMyJoinCircle];
            info = [self.hisManageArray objectAtIndex:indexPath.row];
        }
        else {
            [cell setType:kMyManageCircle];
            info = [self.circleArray objectAtIndex:indexPath.row];
        }
        //设置圈子类型（我管理的圈子要特殊处理）
        [cell setType:NO];
        if (indexPath.row == self.circleArray.count -1) {
            [cell isLastRow:YES];
        }else {
            [cell isLastRow:NO];
        }
        
        //设置圈子信息
        [cell setData:info];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //关注列表
    if (self.tableViewType == kCircleListType) {
        CircleInfoModel * model = [self.circleArray objectAtIndex:indexPath.row];
        CircleDetailViewController *controller = [[CircleDetailViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.circleId = model.id;
        controller.circleName = model.name;
        controller.fromMyPage = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    //管理列表
    else if (self.tableViewType == kMyCircleType){
        CircleInfoModel * model = [self.hisManageArray objectAtIndex:indexPath.row];
        CircleDetailViewController *controller = [[CircleDetailViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.circleId = model.id;
        controller.circleName = model.name;
        controller.fromMyPage = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (self.tableViewType == karticleListType) {
        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
        ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
        controller.articleId = model.articleId;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  返回按钮触发事件  返回上一页面
 */
- (IBAction)returnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  设置按钮触发事件  去设置页面
 */
- (IBAction)setClick:(id)sender {
    EditUserInfoViewController *controller = [[EditUserInfoViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.nickName = self.memberModel.nickName;
    controller.desc = self.memberModel.desc;
    [self.navigationController pushViewController:controller animated:YES];
}
/**
 *  话题按钮触发事件
 */
- (IBAction)articleClick:(id)sender {
    [self.circleNoResultView setHidden:YES];
    [self.manageNoResultView setHidden:YES];
    self.tableViewType = karticleListType;
    [self changeButtonState:karticleListType];
    //红色的线游动
    if( self.slideImageView.frame.origin.x>self.view.frame.size.width/3){
        [UIView animateWithDuration:0.3f animations:^{
            self.slideImageView.frame=CGRectMake(10, 142,(UIScreenWidth-60)/3, 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    if (self.articleArray.count == 0) {
        [self.articleNoResultView setHidden:NO];
    }
    else {
        [self.articleNoResultView setHidden:YES];
    }
    [self.myArticleTableView reloadData];
    if (self.hasMoreArticle) {
        [self.myArticleTableView addFooterWithCallback:^{
            if (self.tableViewType == karticleListType) {
                if (self.hasMoreArticle) {
                    self.isLoadMoreArticle = YES;
                    [self requestArticleListWithPage:self.pagForArticle +1 quertTime:self.articleListModel.queryTime];
                }
            }
            else if (self.tableViewType == kCircleListType){
                if (self.hasMoreCircle) {
                    self.isLoadMoreCircle = YES;
                    [self requestCircleListWithPage:self.pagForCircle+1];
                }
            }
        }];
    }

}
/**
 *  我的按钮触发事件
 */
- (IBAction)myCircleClick:(id)sender {
    
    //她的个人中心
    if (![[LoginManager shareInstance].loginAccountInfo.uId isEqualToString:self.queryUid]) {
        [self.articleNoResultView setHidden:YES];
        [self.circleNoResultView setHidden:YES];
        self.tableViewType = kMyCircleType;
        [self changeButtonState:kMyCircleType];
        if( self.slideImageView.frame.origin.x<2*self.view.frame.size.width/3){
            [UIView animateWithDuration:0.3f animations:^{
                self.slideImageView.frame=CGRectMake(2*UIScreenWidth/3+10, 142, (UIScreenWidth-60)/3, 2);
            }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
        if (self.hasRequestManager) {
            if (self.hisManageArray.count == 0) {
                [self.manageNoResultView setHidden:NO];
            }
            else {
                [self.manageNoResultView setHidden:YES];
            }
            [self.myArticleTableView reloadData];

        }
        else {
             [self requestCircleListWithPage:1];
            self.hasRequestManager = YES;
        }
    }
    //自己的个人中心
    else {
        CircleListViewController *controller = [[CircleListViewController alloc]init];
        controller.circleType = kMyManageCircle;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
/**
 *  关注按钮触发事件
 */
- (IBAction)joinClick:(id)sender {
    [self.articleNoResultView setHidden:YES];
    [self.manageNoResultView setHidden:YES];
    self.tableViewType = kCircleListType;
    [self changeButtonState:kCircleListType];
    if (self.hasRequestCircle) {
        if (self.circleArray.count == 0) {
            [self.circleNoResultView setHidden:NO];
        }
        else {
            [self.circleNoResultView setHidden:YES];
        }
        [self.myArticleTableView reloadData];

    }
    else {
        [self requestCircleListWithPage:1];
        self.hasRequestCircle = YES;
    }

    if (self.hasMoreCircle) {
        [self.myArticleTableView addFooterWithCallback:^{
            if (self.tableViewType == karticleListType) {
                if (self.hasMoreArticle) {
                    self.isLoadMoreArticle = YES;
                    [self requestArticleListWithPage:self.pagForArticle +1 quertTime:self.articleListModel.queryTime];
                }
            }
            else if (self.tableViewType == kCircleListType){
                if (self.hasMoreCircle) {
                    self.isLoadMoreCircle = YES;
                    [self requestCircleListWithPage:self.pagForCircle+1];
                }
            }
        }];
    }
    if(self.slideImageView.frame.origin.x<self.view.frame.size.width/3 ||self.slideImageView.frame.origin.x>2*self.view.frame.size.width/3){
        [UIView animateWithDuration:0.3f animations:^{
            self.slideImageView.frame=CGRectMake(UIScreenWidth/3+10, 142, (UIScreenWidth-60)/3, 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }

}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            //返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        if (buttonIndex == 1) {
            //跳转到登陆页面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
            loginViewController.loginButtonBlock = ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:nav animated:YES completion:nil];
        }
    }

}


//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    _contentOffsetY = scrollView.contentOffset.y;
//
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//
//    [UIView beginAnimations:nil context:nil];
//    //设定动画持续时间
//    [UIView setAnimationDuration:0.3];
//
//    if ((self.myArticleTableView.contentOffset.y - _contentOffsetY) > 20 ){
//        //self.viewTopConstraint.constant = -100;
//        self.headView.frame = CGRectMake(0, -100, UIScreenWidth, 234);
//        self.myArticleTableView.frame = CGRectMake(0, 134, UIScreenWidth, UIScreenHeight - 134);
//
//    }
//    else if ((self.myArticleTableView.contentOffset.y - _contentOffsetY) < -20 ) {
//        //self.viewTopConstraint.constant = 0;
//        self.headView.frame = CGRectMake(0, 0, UIScreenWidth, 234);
//        self.myArticleTableView.frame = CGRectMake(0, 234, UIScreenWidth, UIScreenHeight - 234);
//    }
//    [UIView commitAnimations];
//}
//

#pragma mark - ArticleTableViewcell Delegate
/**
 *  投票、
 *
 *  @param articleId 话题id
 *  @param   type   0 反对  1 支持
 */
 

- (void)voteClick:(ArticleVoteView *)voteView atIndex:(NSUInteger)index withArticleId:(NSString *)articleId type:(NSString *)type {
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = 1;
        
        [loginAlert show];
    }
    else {
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
        [self.myArticleTableView reloadData];
        [self.articleService Bus301001:[LoginManager shareInstance].loginAccountInfo.uId aId:articleId type:type success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];

    }
}


/**
 *  评论触发
 *
 *  @param article  话题
 */
-(void) commentClick:(ArticleDetailModel*) data {
    ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
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
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = 1;

        [loginAlert show];
    }
    else {
        //设置UI 点赞取消 再发请求 不管请求失败与否
        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
        model.flag = @"1";
        int number = [model.praiseNum intValue]+1;
        NSString *numberStr = [NSString stringWithFormat:@"%d",number];
        model.praiseNum =numberStr;
        [self.myArticleTableView reloadData];
        //请求服务 赞
        NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;
        
        [self.articleService Bus300801:uid aId:articleId type:@"1" success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
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
    [self.myArticleTableView reloadData];
    //请求服务 取消赞

    [self.articleService Bus300801:[LoginManager shareInstance].loginAccountInfo.uId aId:articleId type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)selectUrl:(NSURL *)url {
    //[[UIApplication sharedApplication] openURL:url];
    WebViewController *controller = [[WebViewController alloc]init];
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)userHeadClick:(NSString *)userId {

}
/**
 *  大图预览
 *
 *  @param index   图片下标
 *  @param info 大图地址列表
 */
- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    [self.largeImageArray removeAllObjects];
    [self.largeImageArray addObjectsFromArray:info];
    PhotosViewController      *photos = [[PhotosViewController alloc] init];
    photos.delegate = self;
    photos.datasource = self;
    photos.currentPage = (int)index;
    [self.navigationController pushViewController:photos animated:YES];
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
/**
 *  分享
 *
 *  @param indexPath   话题行号
 *  @param articleId  话题id
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
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        // dw end
    }
}


#pragma  mark - 分享成功 ShareToSnsServiceDelegate

/**
 *  分享成功
 */
- (void)shareToSnsPlatformSuccessed
{
//    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:self.clickRow];
//
//    [self.articleService Bus300901:articleModel.articleId success:^(id responseObj){
//        BaseModel *resultModel = (BaseModel *)responseObj;
//        if ([resultModel.retcode isEqualToString:@"000000"]) {
//            // 分享次数+1 self.sharedindexPath
//            ArticleDetailModel *model = [self.articleArray objectAtIndex:self.clickRow];
//            model.shareNum =[NSString stringWithFormat:@"%d",[model.shareNum intValue]+1] ;
//            [self.myArticleTableView reloadData];
//        }
//        
//    }failure:^(NSError *error){
//        
//    }];
}

#pragma mark - 头像点击事件
/**
 *  个人头像点击事件
 */
-(void) headClick:(UIImageView *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机拍摄",@"相册库", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheet Delegate
/**
 *  跳出相机或相册
 *
 *  @param actionSheet 下标
 *  @param buttonIndex 按钮下标
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //先设定sourceType为相机，然后判断相机是否可用，不可用将sourceType设定为相片库
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Camera View Delegate Methods
/**
 *  拍照完成或相册选择完成
 *
 *  @param picker 相机或相册
 *  @param info   照片
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/circleUserIcon.png"];
    // 将图片写入文件
    [self scaleAndSaveImage:image andFilePath:fullPath];
}
/**
 *  在相机或相册 点了取消
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/**
 *  调整选择的照片质量，并写入临时目录下
 *
 *  @param image    选择的图片
 *  @param fullPath 写入的路径
 */
- (void)scaleAndSaveImage:(UIImage *)image andFilePath:(NSString *)fullPath
{
    //调整图片方向
    float quality = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, quality);
    
    
    if(imageData.length > 200 * 1024)
    {
        quality = 0.7;
        imageData = UIImageJPEGRepresentation(image, quality);
        
        
        while (imageData.length < 200 * 1024 && (quality < 1.0)) {
            quality += 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
        
        while (imageData.length > 200 * 1024 && (quality > 0.0)) {
            quality -= 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
    }
    
    
    [imageData writeToFile:fullPath atomically:NO];//写入到缓存目录
    
    [self upLoadUserHead ];
}

/**
 *  上传头像文件
 */
- (void)upLoadUserHead {
    // 上传用户头像
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/circleUserIcon.png"];
    
    [self.userService Bus400501:[LoginManager shareInstance].loginAccountInfo.uId file:fullPath success:^(id responseObj){
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            // 上传成功
            [SVProgressHUD showSuccessWithStatus:@"头像修改成功"];
            //保存本地 设置新头像
            [JRPropertyUntils updateUserPortraitImageWithFilePath:fullPath];
            [JRPropertyUntils refreshUserPortraitInView:self.headImageView];
        }
        else{
            [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"头像上传失败，请稍后重试"];
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
    [self.myArticleTableView reloadData];
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
    [self.myArticleTableView reloadData];
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


@end
