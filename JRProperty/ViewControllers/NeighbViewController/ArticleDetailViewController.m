//
//  ArticleDetailViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define kNoLoginAlert    0
#define kRequestFailAlert  1
#import "ArticleDetailViewController.h"
#import "UserPageViewController.h"
#import "ReportViewController.h"
#import "LoginViewController.h"
#import "ArticleDetailHeadView.h"
#import "WebViewController.h"
#import "CommentTableViewCell.h"
#import "PopSocialShareView.h"
#import "SVProgressHUD.h"
#import "ArticleBottomView.h"
#import "MJRefresh.h"
#import "JRDefine.h"

#import "ArticleService.h"
#import "CommunityService.h"
#import "ShareToSnsService.h"

#import "CommentListModel.h"
#import "ReplyResultModel.h"
#import "LoginManager.h"
#import "ShareView.h"
#import "SuperArticleListViewController.h"
@interface ArticleDetailViewController ()<ShareToSnsServiceDelegate,SocialShareViewDelegate>

@property (strong,nonatomic) NSMutableArray        *commentList;//评论数组
@property (nonatomic,strong) NSMutableArray          *largeImageArray;    //大图地址列表

@property (strong,nonatomic) ArticleDetailHeadView   *headView;//话题详情部分view
//@property (nonatomic,strong) PopSocialShareView      *shareView;//分享页面
 @property (nonatomic,strong) ShareView      *shareView;//分享页面

@property (nonatomic, assign) CGFloat            contentOffsetY;//下滑控制键盘隐藏
@property (nonatomic,assign)  BOOL               isPulling;        // 下拉刷新标志
@property (nonatomic,assign)  BOOL               hasMore;          // 还有更多标志
@property (nonatomic,assign)  BOOL               isLoadMore;      // 上拉加载更多标志
@property (nonatomic,assign)  int                page;            // 评论页数

@property (strong ,nonatomic) CommentListModel   *commentListModel;//评论列表model

@property (nonatomic,strong) ShareToSnsService   *shareService;
@property (strong,nonatomic) ArticleService      *articleService;
@property (strong, nonatomic) CommunityService   *communityService;

@property (strong ,nonatomic) ArticleBottomView   *bottomView;//评论列表model

@property (nonatomic,assign)  BOOL               isReply;      // 回复标志
@property (nonatomic,strong) CommentModel        *replyComment;//被回复的评论

@end

@implementation ArticleDetailViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.onlyComment) {
        self.title = @"评论";
        UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_pinglun"]];
        self.navigationItem.titleView = iv;
    }
    else {
        self.title = @"详情";
        UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_xiangqing"]];
        self.navigationItem.titleView = iv;
    }
   [self.keyboardView setHidden:YES];
    self.bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleBottomView" owner:self options:nil]objectAtIndex:0];
    [self.bottomView initial];
    self.bottomView.delegate =self;
    if (CURRENT_VERSION <7) {
        self.bottomView.frame = CGRectMake(0, UIScreenHeight-48-64, UIScreenWidth, 48);
    }
    else {
        self.bottomView.frame = CGRectMake(0, UIScreenHeight-48, UIScreenWidth, 48);
    }
    [self.view addSubview:self.bottomView];
    //登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestArticleDetailAfertLogin) name:LOGIN_SUCCESS  object:nil];

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //初始化
    self.articleService = [[ArticleService alloc]init];
    self.communityService = [[CommunityService alloc]init];
    self.commentListModel = [[CommentListModel alloc]init];
    self.commentList = [[NSMutableArray alloc]init];
    self.largeImageArray = [[NSMutableArray alloc]init];
    self.shareService = [[ShareToSnsService alloc] init];
    self.articleDetailModel = [[ArticleDetailModel alloc]init];
    self.replyComment = [[CommentModel alloc]init];
    //设置表格
    [self.commentTableView setHidden:YES];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource =self;
    self.commentTableView.backgroundColor = [UIColor getColor:@"FCFCFC"];
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTableView.showsVerticalScrollIndicator = YES;
   
        [self.commentTableView addHeaderWithCallback:^{
            self.isPulling = YES;
            // 调用网络请求
            [self requestArticleDetail];
        }];
   
    
    [self.commentTableView addFooterWithCallback:^{
        if (self.hasMore) {
            self.isLoadMore = YES;
            [self requestCommentListWithPage:self.page+1 Time:self.commentListModel.queryTime];
        }
    }];
    //表格设置事件 点击其他地方 键盘下降
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.commentTableView addGestureRecognizer:tapGestureRecognizer];
    //设置输入viewed
    [self initKeyboardView];
    
    //请求话题详情
    [self requestArticleDetail];
    
   
    
}

/**
 *  设置表格
 */
- (void)createTableView {
    if (!self.onlyComment) {
        self.headView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleDetailHeadView" owner:self options:nil]objectAtIndex:0];
        [self.headView initial];
        self.headView.delegate = self;
        CGFloat heigh = [ArticleDetailHeadView height:self.articleDetailModel];
        self.headView.frame = CGRectMake(0, 0, UIScreenWidth, heigh);
        [self.headView setData:self.articleDetailModel];
        self.commentTableView.tableHeaderView = self.headView;
    }
    
    [self.bottomView setData:self.articleDetailModel];
}

/**
 *  设置输入区域
 */
- (void)initKeyboardView {
    [self.keyboardView setBackgroundColor:[UIColor getColor:@"F2F2F2"]];
    self.CommenInputView.isScrollable = NO;
    self.CommenInputView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.CommenInputView.animateHeightChange = YES;
    self.CommenInputView.minNumberOfLines = 1;
    self.CommenInputView.maxNumberOfLines = 4;
    self.CommenInputView.returnKeyType = UIKeyboardTypeDefault;
    self.CommenInputView.font = [UIFont systemFontOfSize:15.0f];
    self.CommenInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.CommenInputView.delegate = self;
    self.CommenInputView.placeholder = @"说点什么吧...";
    [self.CommenInputView setBackgroundColor:[UIColor getColor:@"FDFDFD"]];
    CALayer *layer1 = [self.CommenInputView layer];
    layer1.borderColor = [UIColor grayColor].CGColor;
    layer1.borderWidth = 0.5f;
    [self.CommenInputView.layer setCornerRadius:5.0];
    [self.CommenInputView.layer setMasksToBounds:YES];
    [self.CommenInputView setClipsToBounds:YES];
    
    [self.sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  请求评论列表
 *
 *  @param page     页数
 *  @param queryTime 时间
 */
- (void)requestCommentListWithPage:(int )page Time:(NSString *)queryTime {
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    if (!self.isPulling && !self.isLoadMore) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    
    [self.communityService Bus301202:self.articleDetailModel.aId page:pageStr num:NUMBER_FOR_REQUEST queryTime:queryTime success:^(id responseObject) {
        self.commentListModel = (CommentListModel *)responseObject;
        [SVProgressHUD dismiss];
        [self requestListSuccess];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        if (self.isPulling) {
            self.isPulling = NO;
            [self.commentTableView headerEndRefreshing];
        }
        else if (self.isLoadMore) {
            self.isLoadMore = NO;
            [self.commentTableView footerEndRefreshing];
            self.hasMore = YES;
        }

    }];
//    [self.articleService Bus301201:self.articleDetailModel.articleId queryTime:queryTime page:pageStr num:NUMBER_FOR_REQUEST success:^(id responseObject) {
//        self.commentListModel = (CommentListModel *)responseObject;
//        [SVProgressHUD dismiss];
//        [self requestListSuccess];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
//        if (self.isPulling) {
//            self.isPulling = NO;
//            [self.commentTableView headerEndRefreshing];
//        }
//        else if (self.isLoadMore) {
//            self.isLoadMore = NO;
//            [self.commentTableView footerEndRefreshing];
//            self.hasMore = YES;
//        }
//    }];
}

/**
 *  评论列表请求成功处理
 */
- (void)requestListSuccess {
    if ([self.commentListModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
        //成功
        if (self.isPulling) {
            [self.commentList removeAllObjects];
            self.page = 1;
            self.isPulling = NO;
            [self.commentTableView headerEndRefreshing];
        }
        else if (self.isLoadMore) {
            self.page = self.page+1;
            self.isLoadMore = NO;
            [self.commentTableView footerEndRefreshing];
        }
        else {
            self.page = 1;
        }
        [self.commentList addObjectsFromArray:self.commentListModel.doc];
        if(self.commentListModel.doc.count < [NUMBER_FOR_REQUEST intValue]){
            self.hasMore = NO;
            [self.commentTableView removeFooter];;
            
        }else{
            self.hasMore = YES;
            [self.commentTableView addFooterWithCallback:^{
                if (self.hasMore) {
                    self.isLoadMore = YES;
                    [self requestCommentListWithPage:self.page+1 Time:self.commentListModel.queryTime];
                }
            }];

        }
        [self.commentTableView reloadData];
    }
    else {
        [SVProgressHUD showErrorWithStatus:self.commentListModel.retinfo];
        if (self.isPulling) {
            self.isPulling = NO;
            [self.commentTableView headerEndRefreshing];
        }
        else if (self.isLoadMore) {
            self.isLoadMore = NO;
            [self.commentTableView footerEndRefreshing];
            self.hasMore = YES;
        }
    }
   
}

/**
 *  发送评论
 */
- (void) sendComment {
    //未登录提示
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
      UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

    else {
        //去掉前后换行
        NSString * str = [self.CommenInputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([@"" isEqualToString:str]||str==nil) {
            // 请输入内容
            self.CommenInputView.text = @"";
            [self.CommenInputView resignFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"评论内容不能为空！"];
            return;
        }
        else {
            if (str.length>200) {
                str = [str substringToIndex:199];
            }
            [self.CommenInputView resignFirstResponder];
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
            if (self.isReply) {
                //发表回复
                [self.articleService Bus301101:[LoginManager shareInstance].loginAccountInfo.uId aId:self.articleDetailModel.articleId replyUId:self.replyComment.uId commentId:self.replyComment.commentId content:str success:^(id responseObject) {
                    ReplyResultModel *model = (ReplyResultModel *)responseObject;
                    if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                        //成功
                        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                        [self addMyCommentWithCommentId:model.commentId];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:model.retinfo];
                    }
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
                }];
            }
            else {
                //发表评论
                [self.articleService Bus301101:[LoginManager shareInstance].loginAccountInfo.uId aId:self.articleDetailModel.articleId replyUId:nil commentId:nil content:str success:^(id responseObject) {
                    ReplyResultModel *model = (ReplyResultModel *)responseObject;
                    if ([model.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                        //成功
                        [SVProgressHUD showSuccessWithStatus:@"发表成功"];
                        [self addMyCommentWithCommentId:model.commentId];
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
}


/**
 *  将我的评论加入评论列表首条
 */
- (void)addMyCommentWithCommentId:(NSString *)commentId {
    CommentModel *model = [[CommentModel alloc]init];
    model.uId = [LoginManager shareInstance].loginAccountInfo.uId;
    model.nickName = [LoginManager shareInstance].loginAccountInfo.nickName;
    
    model.userLevel = IS_SUPER_REQUEST;
    model.imageUrl = @"add";
    model.content = self.CommenInputView.text;
    model.commentId = commentId;
    if (self.isReply) {
        model.replyUId = self.replyComment.uId;
        model.replyNickName = self.replyComment.nickName;
    }
    model.time = @"刚刚" ;
    [self.commentList insertObject:model atIndex:0];
    [self.commentTableView reloadData];
    self.CommenInputView.text = @"";
    self.keyboardView.frame =CGRectMake(0,UIScreenHeight-49, self.view.frame.size.width, 48);
    self.articleDetailModel.comment = [NSString stringWithFormat:@"%d",[self.articleDetailModel.comment intValue]+1];
    [self.bottomView setData:self.articleDetailModel];
    [self.headView setData:self.articleDetailModel];
    self.isReply = NO;
}

/**
 *  请求话题详情
 */
- (void)requestArticleDetail {
    if (!self.isPulling) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    NSString *uId = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus301902: uId aId:self.articleId success:^(id responseObject) {
        self.articleDetailModel = (ArticleDetailModel *)responseObject;
        if ([self.articleDetailModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
            //成功
            [SVProgressHUD dismiss];
            [self.commentTableView setHidden:NO];
            [self createTableView];
            //信息请求完成  请求评论列表
            [self requestCommentListWithPage:1 Time:nil];
        }
        else {
            if (self.isPulling) {
                [SVProgressHUD showErrorWithStatus:self.articleDetailModel.retinfo];
            }
            else {
                UIAlertView *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                tipAlert.tag = kRequestFailAlert;
                [tipAlert show];
                
            }
        }
    } failure:^(NSError *error) {
        if (self.isPulling) {
            [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }
        else {
            UIAlertView *tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息请求失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            tipAlert.tag = kRequestFailAlert;
            [tipAlert show];
            
        }
    }];
}

/**
 *  登录后 自动下拉刷新 请求话题详情和评论
 */
- (void)requestArticleDetailAfertLogin {
    [self.commentTableView headerBeginRefreshing];
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取数据
    return [CommentTableViewCell height:[self.commentList objectAtIndex:indexPath.row]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identify = @"CommentTableViewCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor getColor:@"FCFCFC"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    //获取数据
    CommentModel * info = [self.commentList objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.commentList.count -1) {
        [cell isLastRow:YES];
    }else {
        [cell isLastRow:NO];
    }
    
    [cell setData:info];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.replyComment = [self.commentList objectAtIndex:indexPath.row];
    [self.bottomView setHidden:YES];
    [self.keyboardView setHidden:NO];
    self.isReply = YES;
    self.CommenInputView.placeholder = [NSString stringWithFormat:@"回复%@:",self.replyComment.nickName];
    [self.CommenInputView becomeFirstResponder];
}




#pragma mark - HeadView Delegate (for vote priase cancelPriase  )

//投票
- (void)voteClick:(ArticleVoteView *)voteView type:(NSString *)type {
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = kNoLoginAlert;
        [loginAlert show];
    }
    else {
        //反对
        if ([type integerValue]==0) {
            self.articleDetailModel.voteFlag = @"2";
            self.articleDetailModel.no = [NSString stringWithFormat:@"%d",[self.articleDetailModel.no intValue]+1];
        }
        //支持
        else  {
            self.articleDetailModel.voteFlag = @"1";
            self.articleDetailModel.yes = [NSString stringWithFormat:@"%d",[self.articleDetailModel.yes intValue]+1];
        }
        [self.headView setData:self.articleDetailModel];
        [self.articleService Bus301001:[LoginManager shareInstance].loginAccountInfo.uId aId:self.articleDetailModel.articleId type:type success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }

}


- (void)praiseClick:(NSString *)articleId {
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        loginAlert.tag = kNoLoginAlert;
        
        [loginAlert show];
    }
    else {
        self.articleDetailModel.flag = @"1";
        int number = [self.articleDetailModel.praiseNum intValue]+1;
        NSString *numberStr = [NSString stringWithFormat:@"%d",number];
        self.articleDetailModel.praiseNum =numberStr;
        [self.bottomView setData:self.articleDetailModel];
        //        [self.headView setData:self.articleDetailModel];
        
        //调接口服务 赞
        NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
        [self.communityService Bus300802:CID_FOR_REQUEST aId:self.articleDetailModel.aId uId:uid     type:@"1" success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)cancelPraiseClick:(NSString *)articleId {
    self.articleDetailModel.flag = @"0";
    NSInteger number = [self.articleDetailModel.praiseNum integerValue]-1;
    NSString *numberStr = [NSString stringWithFormat:@"%ld",(long)number];
    self.articleDetailModel.praiseNum =numberStr;
    [self.bottomView setData:self.articleDetailModel];
    //调用接口 取消赞
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus300802:CID_FOR_REQUEST aId:self.articleDetailModel.aId uId:uid type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)commentClick:(ArticleDetailModel *)data {
    self.isReply = NO;
    [self.bottomView setHidden:YES];
    [self.keyboardView setHidden:NO];
    self.CommenInputView.placeholder = @"说点什么吧...";
    [self.CommenInputView becomeFirstResponder];
}


//点击话题发布者头像触发
- (void)userHeadClick:(NSString *)userId {
    UserPageViewController *controller = [[UserPageViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.queryUid = userId;
    [self.navigationController pushViewController:controller animated:YES];
}

//大图预览
- (void)imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *)info {
    [self.largeImageArray removeAllObjects];
    [self.largeImageArray addObjectsFromArray:info];
    PhotosViewController      *photos = [[PhotosViewController alloc] init];
    photos.delegate = self;
    photos.datasource = self;
    photos.currentPage = (int)index;
    [self.navigationController pushViewController:photos animated:YES];
}

//分享触发
- (void)shareArticle:(NSString *)articleId  {
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue]== 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:NO isTop:NO];
    self.shareView.delegate = self;
    [self.shareView show];

    //    PopSocialShareView *tempShareView = [[PopSocialShareView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    tempShareView.delegate = self;
//    self.shareView = tempShareView;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}

- (void)selectUrl:(NSURL *)url {
    //[[UIApplication sharedApplication] openURL:url];
    WebViewController *controller = [[WebViewController alloc]init];
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma  mark - ShareViewDelegate

//分享
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType {
    [self.shareView dismissPage];
    self.shareService.actID = self.articleDetailModel.articleId;
    self.shareService.delegate = self;
    NSData *imageData = nil;
    NSData *bigImageData=nil;
    if (self.articleDetailModel.imageList.count>0) {
        ImageModel *image = [self.articleDetailModel.imageList objectAtIndex:0];
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlS]];
        bigImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlL]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_ARTICLE_URL,self.articleDetailModel.articleId];
    
    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",self.articleDetailModel.name,self.articleDetailModel.content,urlStr];
    
    [self.shareService showSocialPlatformIn:self
                                 shareTitle:self.articleDetailModel.name
                                  shareText:self.articleDetailModel.content
                                   shareUrl:urlStr
                            shareSmallImage:imageData
                              shareBigImage:bigImageData
                           shareFullMessage:fullMessage
                             shareToSnsType:platformType];
}

//举报 移动
- (void)didSelectOperationButton:(ArticleOperationType)operationType {
    [self.shareView dismissPage];

    //举报话题
    if (operationType == ArticleReport) {
        if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
            ReportViewController *controller = [[ReportViewController alloc]init];
            controller.articleId =self.articleDetailModel.articleId;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            loginAlert.tag = kNoLoginAlert;
            
            [loginAlert show];
        }
       
    }
    //移动话题
    else {
        // dw add
//        NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[self.shareSection];
        SuperArticleListViewController  * vc = [[SuperArticleListViewController alloc] init];
        vc.title = @"移动";
        vc.formID = self.articleDetailModel.id;
        vc.articleID = self.articleDetailModel.articleId;
        vc.callBackBlock = ^(){
            // 刷新吗？
            
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
    [self.articleService Bus300901:self.articleDetailModel.articleId success:^(id responseObj){
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            // 分享次数+1
            self.articleDetailModel.shareNum =[NSString stringWithFormat:@"%d",[self.articleDetailModel.shareNum intValue]+1] ;
            [self.headView setData:self.articleDetailModel];
            
        }
        
    }failure:^(NSError *error){
        
    }];
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





#pragma mark - HGTextViewDelegate Method
    /**
     *  改变textview的高度
     *
     *  @param growingTextView textview
     *  @param height          改变的高度
     */
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
        
    CGRect r = self.keyboardView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    
    self.keyboardHeightContraint.constant = r.size.height;
    [self.view layoutIfNeeded];
        
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    return  [self.inputView resignFirstResponder];
}



    /**
     *  当键盘出现或改变时调用
     *
     *  @param aNotification 通知
     */
- (void)keyboardWillShow:(NSNotification *)aNotification {
        //获取键盘的高度
    CGRect oldFrame = self.keyboardView.frame;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.bottomContraint.constant = height;
    self.tableViewBottomContraint.constant = height+oldFrame.size.height;


}
    
    /**
     *  当键盘退出时调用
     *
     *  @param aNotification 通知
     */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect oldFrame = self.keyboardView.frame;

    self.bottomContraint.constant = 0;
    self.tableViewBottomContraint.constant = oldFrame.size.height;
    [self.keyboardView setHidden:YES];
    [self.bottomView setHidden:NO];
}

#pragma mark - Scroll  控制下滑表格则 键盘下降
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ((self.commentTableView.contentOffset.y - _contentOffsetY) < 20)
    {
        [self.CommenInputView resignFirstResponder];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _contentOffsetY = scrollView.contentOffset.y;
}


/**
 *  控制textview输入长度
 *
 *  @param textView textview
 *  @param range    range
 *  @param text     text
 *
 *  @return  是否可输入
 */
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
 
    if ([self.CommenInputView.text length] > 200) {
        self.CommenInputView.text = [self.CommenInputView.text substringToIndex:199];
        return NO;
    }else if ([self.CommenInputView.text length] == 200){
        self.CommenInputView.text = [self.CommenInputView.text substringToIndex:199];
        return NO;
    }
    else {
        return YES;
    }
}


#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kNoLoginAlert) {
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
    else {
        if (buttonIndex == 0) {
            //返回上一页面
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


/**
 *  给tableview加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [self.CommenInputView resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
