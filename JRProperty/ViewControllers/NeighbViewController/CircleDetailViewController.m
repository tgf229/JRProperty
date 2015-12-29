//
//  CircleDetailViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#define kJoinCircle     1
#define kQuitCircle   0
#define kRequestInfoFailAlert   0
#define kNoLoginAlert     1
#define kNoJoinAlert     2
#define kTopAlert     3
#define kDeleteArticleAlert 4
#import "ReportViewController.h"
#import "CircleDetailViewController.h"
#import "CreateCircleViewController.h"
#import "CircleListTableViewCell.h"
#import "MemberListViewController.h"
#import "ArticleDetailViewController.h"
#import "ArticleTableViewCell.h"
#import "PublicTopicViewController.h"
#import "UserPageViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"

#import "NoResultView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#import "CommunityModel.h"
#import "ArticleListModel.h"
#import "LoginManager.h"
#import "BaseModel.h"
#import "JRDefine.h"

#import "NeighborService.h"
#import "ArticleService.h"
#import "ShareToSnsService.h"

#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "ShareView.h"
#import "SuperArticleListViewController.h"
#import "PlotSomethingNewTableViewCell.h"
#import "NewsListModel.h"
static NSString *cellIndentifier = @"PlotSomethingNewTableViewCellIndentifierlalal";

//#import "PopSocialShareView.h"  PopSocialShareViewDelegate

@interface CircleDetailViewController ()<SocialShareViewDelegate,ShareToSnsServiceDelegate>

@property (nonatomic,strong)  NoResultView       *noResultView; //哭脸视图
//@property (nonatomic,strong) PopSocialShareView      *shareView;    //分享页面

@property (nonatomic,strong)  NSMutableArray     *articleArray;     // 话题数组
@property (nonatomic,strong) NSMutableArray          *largeImageArray;    //大图地址列表

@property (nonatomic,strong)  NeighborService    *neighborService;
@property (nonatomic,strong)  ArticleService     *articleService;
@property (nonatomic,strong) ShareToSnsService       *shareService;

@property (nonatomic,strong)  CommunityModel     *currentCircleModel; //圈子model
@property (nonatomic,strong)  ArticleListModel   *articleListModel;   //话题列表model

@property (assign,nonatomic)  int                page;//话题页数
@property (nonatomic,assign)  BOOL               isPulling;        // 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMore;          // 还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMore;       // 上拉加载更多标志
@property (nonatomic,assign)  BOOL               isMyCircle;       // 我是圈主的标志
@property (nonatomic,strong) NSIndexPath             *sharedIndexPath;//分享话题行号
@property (nonatomic,assign) CGFloat    headHeigh;
@property (nonatomic,strong) ShareView      *shareView;//分享页面
@property (strong,nonatomic)  UIView  *footerView;//列表结束提示图片
@property (nonatomic,assign)  long clickRow;

@end

@implementation CircleDetailViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    self.title = self.circleName;
    [super viewDidLoad];
    //通知 编辑圈子信息  发帖  登录
    [self.joinButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.joinButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.editButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.memberButton setBackgroundImage:[[UIImage imageNamed:@"shequ_detail_btn_grey_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.memberButton setBackgroundImage:[[UIImage imageNamed:@"shequ_detail_btn_grey_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestCircleInfoAfertEdit) name:EDIT_CRICLE_SUCCESS  object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestArticleListAfertPublic) name:PUBLICE_ARTICLE_SUCCESS  object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAfertLogin) name:LOGIN_SUCCESS  object:nil];
//    shequ_detail_btn_grey_40x40@2x
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    UINib *cellNib = [UINib nibWithNibName:@"PlotSomethingNewTableViewCell" bundle:nil];
    [self.circleDetailTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];

    //初始化
    self.largeImageArray = [[NSMutableArray alloc]init];
    self.articleArray = [[NSMutableArray alloc]init];
    self.articleListModel = [[ArticleListModel alloc]init];
    self.currentCircleModel = [[CommunityModel alloc]init];
    self.neighborService = [[NeighborService alloc]init];
    self.articleService = [[ArticleService alloc]init];
    self.shareService = [[ShareToSnsService alloc] init];
    self.sharedIndexPath = [[NSIndexPath alloc] init];
    
    self.descLabel.textColor = [UIColor getColor:@"888888"];
    self.numberLabel.textColor = [UIColor getColor:@"888888"];
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-44, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-24, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.circleDetailTableView addSubview:self.noResultView];
        self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 30)];
        UIImageView *endTip = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth/2-18, 7.5, 36, 15)];
        endTip.image = [UIImage imageNamed:@"end_tips_60x42"];
        [self.footerView addSubview:endTip];
    //设置表格
    self.circleDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.circleDetailTableView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.circleDetailTableView.delegate = self;
    self.circleDetailTableView.dataSource = self;
    self.circleDetailTableView.showsVerticalScrollIndicator = YES;
    
    
//    self.HeadView.frame = CGRectMake(0, 0, _circleDetailTableView.frame.size.width, 150);
//    [_circleDetailTableView setTableHeaderView:_HeadView];
    
    [self.circleDetailTableView addHeaderWithCallback:^{
        self.isPulling = YES;
        [self.noResultView setHidden:YES];
        // 调用网络请求
        [self requestCircleInfomation];
        //[self requestArticleWithPage:@"1" Time:nil];
    }];
    
    [self.circleDetailTableView addFooterWithCallback:^{
        if (self.hasMore) {
            self.isLoadMore = YES;
            NSString *pageStr = [NSString stringWithFormat:@"%d",self.page+1];
            [self requestArticleWithPage:pageStr Time:self.articleListModel.queryTime];
        }
    }];
    //右上角 创建发帖按钮
    [self createPostButton];
    //请求圈子信息
    [self requestCircleInfomation];
}


/**
 *  标题栏右侧按钮
 */
- (void)createPostButton {
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [postButton setFrame:CGRectMake(0, 0, 50+ 22, 24)];
    }
    else{
        [postButton setFrame:CGRectMake(0, 0,50, 20)];
    }
    
//    [postButton setTitle:@"发话题"  forState:UIControlStateNormal];
//    [postButton setTitle:@"发话题"  forState:UIControlStateHighlighted];
    [postButton setImage:[UIImage imageNamed:@"red_fahuati"] forState:UIControlStateNormal];
    [postButton setImage:[UIImage imageNamed:@"red_fahuati"] forState:UIControlStateHighlighted];
//    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
//    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
//    postButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [postButton addTarget:self action:@selector(gotoPostPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 *  圈子信息部分 填充数据
 */
- (void)updateInfomationPart {
    CGSize size = CGSizeMake(UIScreenWidth-30,2000);
    CGSize labelsize;
    CGFloat headHight=142;
    if (self.currentCircleModel.desc != 0) {
        labelsize =[self.currentCircleModel.desc  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        headHight = headHight+labelsize.height;
    }
    if (headHight<162) {
        headHight = 162;
    }
    self.headHeigh = headHight;
    self.HeadView.frame = CGRectMake(0, 0, _circleDetailTableView.frame.size.width, headHight);
    [_circleDetailTableView setTableHeaderView:_HeadView];
    self.title = self.currentCircleModel.name;
    if (!self.currentCircleModel.nickName) {
        self.currentCircleModel.nickName = @"";
    }
    self.circleNameLabel.text = [NSString stringWithFormat:@"圈主：%@",self.currentCircleModel.nickName];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.currentCircleModel.icon] placeholderImage:[UIImage imageNamed:@"community_default"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@关注  %@发帖",self.currentCircleModel.userCount,self.currentCircleModel.articleCount];
    if (!self.currentCircleModel.desc) {
        self.currentCircleModel.desc = @"";
    }
    self.descLabel.text = [NSString stringWithFormat:@"公告：%@",self.currentCircleModel.desc];
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    if (uid && ![@"" isEqualToString:uid]&&[self.currentCircleModel.uId isEqualToString:uid]) {
        self.isMyCircle = YES;
        [self.joinButton setHidden:YES];
        [self.editButton setHidden:NO];
        [self.memberButton setHidden:NO];
    }
    else {
        self.isMyCircle = NO;
        [self.joinButton setHidden:NO];
        [self.editButton setHidden:YES];
        if (self.currentCircleModel.flag.length!=0 && [self.currentCircleModel.flag integerValue]==1 ) {
            [self.joinButton setTitle:@"取消关注" forState:UIControlStateNormal];
        }
        else {
            [self.joinButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        [self.memberButton setHidden:YES];
    }
}

/**
 *  请求圈子信息 若失败 提示返回
 */
- (void) requestCircleInfomation {
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.neighborService Bus300401:self.circleId uId:uid success:^(id responseObject) {
        CommunityModel *model = (CommunityModel *)responseObject;
        [SVProgressHUD dismiss];
        if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            //success
            self.currentCircleModel = model;
            [self.circleDetailTableView setHidden:NO];
            [self updateInfomationPart];
            [self requestArticleWithPage:@"1" Time:nil];
        }
        else {
            //failure
            //[SVProgressHUD showErrorWithStatus:model.retinfo];
            UIAlertView  *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:model.retinfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            tipAlert.tag = kRequestInfoFailAlert;
            [tipAlert show];
        }
    } failure:^(NSError *error) {
        UIAlertView  *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:OTHER_ERROR_MESSAGE delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        tipAlert.tag = kRequestInfoFailAlert;
        [tipAlert show];
    }];
}

/**
 *  编辑圈子信息后  重新请求圈子信息 若失败 不更新信息
 */
-(void)requestCircleInfoAfertEdit {
    [self.neighborService Bus300401:self.circleId uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        CommunityModel *model = (CommunityModel *)responseObject;
        if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            //success
            self.currentCircleModel = model;
            [self updateInfomationPart];
        }
        else {
            //failure
            [SVProgressHUD showErrorWithStatus:model.retinfo];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"圈子信息更新失败"];
    }];
}

/**
 *  请求圈子的话题列表
 *
 *  @param page  页数
 *  @param time  时间
 */
- (void) requestArticleWithPage:(NSString *)page Time:(NSString *)queryTime {
    if (!self.isPulling &&!self.isLoadMore) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;
    [self.neighborService Bus300501:self.circleId uId:uid queryTime:queryTime page:page num:NUMBER_FOR_REQUEST success:^(id responseObject) {
        ArticleListModel *list = (ArticleListModel *)responseObject;
        self.articleListModel = list;
        if ([list.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [SVProgressHUD dismiss];
            //下拉刷新
            if (self.isPulling) {
                self.page = 1;
                //清空原数据  放入新数据  判断是否还有更多
                [self.articleArray removeAllObjects];
                // 请求回来后，停止刷新
                [self.circleDetailTableView headerEndRefreshing];
                self.isPulling = NO;
            }
            // 上滑加载更多
            else if (self.isLoadMore) {
                self.page = self.page +1 ;
                [self.circleDetailTableView footerEndRefreshing];
                self.isLoadMore = NO;
            }
            //第一次请求
            else {
                self.page = 1;
            }
            if(list.doc.count < 10){
                self.hasMore = NO;
                [self.circleDetailTableView removeFooter];
                self.circleDetailTableView.tableFooterView = self.footerView;
                [self.circleDetailTableView.tableFooterView setHidden:NO];
            }else{
                self.hasMore = YES;
                [self.circleDetailTableView.tableFooterView setHidden:YES];

                [self.circleDetailTableView addFooterWithCallback:^{
                    if (self.hasMore) {
                        self.isLoadMore = YES;
                        NSString *pageStr = [NSString stringWithFormat:@"%d",self.page+1];
                        [self requestArticleWithPage:pageStr Time:self.articleListModel.queryTime];
                    }
                }];
            }
            
            [self.articleArray addObjectsFromArray:list.doc];
            if(self.articleArray.count == 0) {
                if (self.headHeigh>150) {
                    self.noResultView.frame = CGRectMake(0, self.headHeigh +20, UIScreenWidth, 140);
                }
                [self.noResultView initialWithTipText:NONE_DATA_MESSAGE];
                [self.noResultView setHidden:NO];
                [self.footerView setHidden:YES];
            }
            else  {
                [self.noResultView setHidden:YES];
            }
            [self.circleDetailTableView reloadData];
        }
        else {
            if(self.articleArray.count == 0) {
                [SVProgressHUD dismiss];
                [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
                [self.noResultView setHidden:NO];
            }
            else  {
                [self.noResultView setHidden:YES];
                [SVProgressHUD showErrorWithStatus:list.retinfo];
            }
            if (self.isPulling) {
                // 请求回来后，停止刷新
                [self.circleDetailTableView headerEndRefreshing];
                self.isPulling = NO;
            }
            else if (self.isLoadMore) {
                [self.circleDetailTableView footerEndRefreshing];
                self.isLoadMore = NO;
                self.hasMore = YES;
            }
        }
        
    } failure:^(NSError *error) {
        if(self.articleArray.count == 0) {
            [SVProgressHUD dismiss];
            [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
            [self.noResultView setHidden:NO];
        }
        else  {
            [self.noResultView setHidden:YES];
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }
        if (self.isPulling) {
            // 请求回来后，停止刷新
            [self.circleDetailTableView headerEndRefreshing];
            self.isPulling = NO;
        }
        else if (self.isLoadMore) {
            [self.circleDetailTableView footerEndRefreshing];
            self.isLoadMore = NO;
            self.hasMore = YES;
        }
    }];
}

/**
 *  发帖后 自动下拉刷新 刷新信息和话题部分
 */
- (void)requestArticleListAfertPublic {
    [self.circleDetailTableView headerBeginRefreshing];
}

/**
 *  登陆后 自动下拉刷新 刷新信息和话题部分
 */
- (void)updateAfertLogin {
    [self.circleDetailTableView headerBeginRefreshing];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    CGFloat rowHight = [ArticleTableViewCell height:model];
    return 136;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.isMyCircle) {
//        static NSString * identify = @"DetailArticleTableViewCell";
//        DetailArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        
//        if (cell == nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailArticleTableViewCell" owner:self options:nil]objectAtIndex:0];
//        }
//        cell.backgroundColor = [UIColor getColor:@"eeeeee"];
//        cell.delegate = self;
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
//        [cell setData:model createUid:self.currentCircleModel.uId];
//        return cell;
//
//    }
//    else {
//        static NSString * identify = @"ArticleTableViewCell";
//        ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//        
//        if (cell == nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]objectAtIndex:0];
//        }
//        cell.backgroundColor = [UIColor getColor:@"eeeeee"];
//        cell.delegate = self;
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell setIsDetailPage:YES];
//        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
//        [cell setData:model createUid:self.currentCircleModel.uId];
//        return cell;
  
    //}
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  关注按钮触发
 */
- (IBAction)joinCircle:(id)sender {
    //未登录 提示
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = kNoLoginAlert;
        [loginAlert show];
    }
    else {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        //如果未关注 发送关注请求
        if ([self.currentCircleModel.flag integerValue]==kQuitCircle) {
            NSString  *type = [NSString  stringWithFormat:@"%d",kJoinCircle];
            [self.neighborService Bus300601:[LoginManager shareInstance].loginAccountInfo.uId sId:self.circleId type:type success:^(id responseObject) {
                BaseModel *model = (BaseModel *)responseObject;
                if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                    [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                    self.currentCircleModel.flag = @"1";
                    self.currentCircleModel.userCount = [NSString stringWithFormat:@"%d",[self.currentCircleModel.userCount intValue]+1];
                    if (self.fromMyPage) {
                     
                        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_FOR_JOINORQUIT object:self];
                    }
                    [self updateInfomationPart];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:model.retinfo];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
            }];
        }
        //如果已关注 发送取消关注请求
        else {
            NSString  *type = [NSString  stringWithFormat:@"%d",kQuitCircle];
            [self.neighborService Bus300601:[LoginManager shareInstance].loginAccountInfo.uId sId:self.circleId type:type success:^(id responseObject) {
                BaseModel *model = (BaseModel *)responseObject;
                if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                    [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
                    self.currentCircleModel.flag = @"0";
                    self.currentCircleModel.userCount = [NSString stringWithFormat:@"%d",[self.currentCircleModel.userCount intValue]-1];
                    if (self.fromMyPage) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_FOR_JOINORQUIT object:self];
                    }
                    [self updateInfomationPart];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:model.retinfo];
                }
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
                
            }];
        }

    }
    
}

/**
 *  圈主 查看成员按钮触发
 */
- (IBAction)gotoMemberPage:(id)sender {
    MemberListViewController *controller = [[MemberListViewController alloc]init];
    controller.memberList = self.currentCircleModel.member;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  发帖按钮触发 去发帖页面
 */
- (void)gotoPostPage {
    if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
        if ([self.currentCircleModel.flag intValue]==1) {
            PublicTopicViewController *publicTopicController = [[PublicTopicViewController alloc] init];
            publicTopicController.title = @"发话题";
            [self.navigationController pushViewController:publicTopicController animated:YES];
        }
        //未登录 提示
        else {
            UIAlertView  *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未关注，请先关注！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            tipAlert.tag = kNoJoinAlert;
            [tipAlert show];
        }
        
    }
    else {
        //未关注 提示
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = kNoLoginAlert;

        [loginAlert show];
    }
    
}

/**
 *  圈主 编辑按钮触发 去编辑页面
 */
- (IBAction)gotoEditPage:(id)sender {
    CreateCircleViewController *controller = [[CreateCircleViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.manageType = kEditCircle;
    controller.circleInfo = self.currentCircleModel;
    [self.navigationController pushViewController:controller animated:YES];
    
}

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
        loginAlert.tag = kNoLoginAlert;
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
        [self.circleDetailTableView reloadData];
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
        loginAlert.tag = kNoLoginAlert;
        [loginAlert show];
    }
    else {
        //设置UI 点赞取消 再发请求 不管请求失败与否
        ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
        model.flag = @"1";
        int number = [model.praiseNum intValue]+1;
        NSString *numberStr = [NSString stringWithFormat:@"%d",number];
        model.praiseNum =numberStr;
        [self.circleDetailTableView reloadData];
        //请求服务 赞
        NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
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
    [self.circleDetailTableView reloadData];
    //请求服务 取消赞
    NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;
    [self.articleService Bus300801:uid aId:articleId type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 *   大图预览
 *
 *  @param info  大图地址数组
 *  @param index 图片下标
 */
- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    [self.largeImageArray removeAllObjects];
    [self.largeImageArray addObjectsFromArray:info];
    PhotosViewController      *photos = [[PhotosViewController alloc] init];
    photos.delegate = self;
    photos.datasource = self;
    photos.currentPage =(int)index;
    [self.navigationController pushViewController:photos animated:YES];
}

/**
 *   话题头像触发事件 去个人中心页面
 *
 *  @param userId  uid
 */
- (void)userHeadClick:(NSString *)userId {
    UserPageViewController *controller = [[UserPageViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.queryUid = userId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectUrl:(NSURL *)url {
    WebViewController *controller = [[WebViewController alloc]init];
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)deleteArticle {
    [SVProgressHUD showWithStatus:@"加载中"];
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:self.clickRow];
    [self.articleService Bus301801:[LoginManager shareInstance].loginAccountInfo.uId sId:self.currentCircleModel.id aId:articleModel.articleId type:@"3" success:^(id responseObject) {
        BaseModel *model = (BaseModel*)responseObject;
        if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.articleArray removeObjectAtIndex:self.clickRow];
            [self.circleDetailTableView reloadData];
            self.currentCircleModel.articleCount = [NSString stringWithFormat:@"%d",[self.currentCircleModel.articleCount intValue]-1];
            [self updateInfomationPart];
            if (self.articleArray.count == 0) {
                [self.noResultView setHidden:NO];
                [self.footerView setHidden:YES];
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
 *   分享
 *
 *  @param articleId  话题id
 *  @param indexPath  话题所在行号
 */
- (void)shareArticle:(NSString *)articleId forIndexPath:(NSIndexPath *)indexPath {
    self.sharedIndexPath = indexPath;
    ArticleDetailModel *model = [self.articleArray objectAtIndex:indexPath.row];
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue]== 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:self.isMyCircle isTop:[model.isTop boolValue]];
    self.shareView.delegate = self;
    [self.shareView show];
    
//    PopSocialShareView *tempShareView = [[PopSocialShareView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    tempShareView.delegate = self;
//    self.shareView = tempShareView;
//    self.sharedIndexPath = indexPath;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}

//#pragma  mark - PopSocialShareViewDelegate
//- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType
//{
//    //[self.shareView removeShareSubView];
//
//    ArticleDetailModel *articleModel = (ArticleDetailModel *)[_articleArray objectAtIndex:[self.sharedIndexPath row]];
//    
//    self.shareService.actID = articleModel.articleId;
//    self.shareService.delegate = self;
//    
//    NSData *imageData = nil;
//    NSData *bigImageData=nil;
//    if (articleModel.imageList.count>0) {
//        ImageModel *image = [articleModel.imageList objectAtIndex:0];
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlS]];
//        bigImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlL]];
//    }
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_ARTICLE_URL,articleModel.articleId];
//    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",articleModel.name,articleModel.content,urlStr];
//    
//    [self.shareService showSocialPlatformIn:self
//                                 shareTitle:articleModel.name
//                                  shareText:articleModel.content
//                                   shareUrl:urlStr
//                            shareSmallImage:imageData
//                              shareBigImage:bigImageData
//                           shareFullMessage:fullMessage
//                             shareToSnsType:platformType];
//}

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
    NSString *uid=[LoginManager shareInstance].loginAccountInfo.uId;

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
    else if (operationType == ArticleMove){
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
    //置顶话题
    else if (operationType == ArticleTop) {
        int isTopNumber = 0;
        for (int i =0; i<self.articleArray.count; i++) {
            ArticleDetailModel *model = [self.articleArray objectAtIndex:i];
            if ([model.isTop integerValue]==1) {
                isTopNumber = isTopNumber+1;
            }
        }
        if (isTopNumber < 3) {
            articleModel.isTop = @"1";
            [self.articleArray removeObjectAtIndex:self.clickRow];
            [self.articleArray insertObject:articleModel atIndex:0];
            [self.circleDetailTableView reloadData];
            [self.articleService Bus301801:uid sId:self.currentCircleModel.id aId:articleModel.articleId type:@"1" success:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        else {
            UIAlertView *topTipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"每个圈子最多置顶三个话题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            topTipAlert.tag = kTopAlert;
            [topTipAlert show];
        }

    }
    //取消置顶话题
    else if (operationType == ArticleCancelTop){
        
        articleModel.isTop = @"0";
        [self.articleArray removeObjectAtIndex:self.clickRow];
        [self.articleArray addObject:articleModel];
        [self.circleDetailTableView reloadData];
        [self.articleService Bus301801:uid sId: self.currentCircleModel.id aId:articleModel.articleId type:@"2" success:^(id responseObject) {
                
        } failure:^(NSError *error) {
                
        }];
    }
    //删除话题
    else {
        UIAlertView  *deleteArticleAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此话题吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        deleteArticleAlert.tag = kDeleteArticleAlert;
        [deleteArticleAlert show];
    }
}
#pragma  mark - ShareToSnsServiceDelegate

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
//            // 分享次数+1
//            ArticleDetailModel *model = [self.articleArray objectAtIndex:self.clickRow];
//            model.shareNum =[NSString stringWithFormat:@"%d",[model.shareNum intValue]+1] ;
//            [self.circleDetailTableView reloadData];
//        }
//        
//    }failure:^(NSError *error){
//        
//    }];
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


#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kRequestInfoFailAlert) {
        if (buttonIndex == 0) {
            //返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == kNoLoginAlert){
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
    else if(alertView.tag == kTopAlert){
        
    }
    else if (alertView.tag == kDeleteArticleAlert) {
        if (buttonIndex == 1) {
            [self deleteArticle];
        }
    }
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
    [self.circleDetailTableView reloadData];
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
    [self.circleDetailTableView reloadData];
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
