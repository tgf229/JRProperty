//
//  HomPageViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HomPageViewController.h"
#import "JRDefine.h"
#import "AppDelegate.h"
#import "ExpressMessageViewController.h"
#import "MyMessageViewController.h"
#import "MyBillViewController.h"
#import "PlotSomethingNewTableViewCell.h"
#import "HelpInfoForHouseOwnerViewController.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "CircularDetailViewController.h"

#import "LoginManager.h"
#import "MyMessageService.h"
#import "MessageListModel.h"
#import "PackageService.h"
#import "PackageListModel.h"
#import "HelpInfoService.h"
#import "NewsListModel.h"
#import "NewPackageNumModel.h"
#import "AnnounceService.h"
#import "AnnounceListModel.h"
#import "MessageDataManager.h"
#import "LoginViewController.h"

#import "UserPageViewController.h"
#import "ArticleDetailViewController.h"

#import "SelectedPlotsViewController.h"
#import "SuperArticleListViewController.h"

#import "ArticleBottom.h"

#import "PlotService.h"
#import "PlotListModel.h"

#import "ArticleService.h"
#import "ShareView.h"
#import "ShareToSnsService.h"
static NSString *cellIndentifier = @"PlotSomethingNewTableViewCellIndentifierlalal";

@interface HomPageViewController ()<PlotSonethingNewTableViewCellDelegate,PhotosViewDatasource,PhotosViewDelegate,ArticleBottomDelegate,ShareToSnsServiceDelegate,SocialShareViewDelegate>
{
    UIView * tView;
    UILabel * tLabel;
    UIButton * tButton;
}
@property (strong, nonatomic) MyMessageService *myMessageService;   // 我的消息业务请求服务类
@property (strong, nonatomic) PackageService  *packageService;      // 快递业务服务类
@property (strong, nonatomic) HelpInfoService *helpInfoService;     // 便民信息业务服务类
@property (strong, nonatomic) AnnounceService *announceService;     // 轮播通告业务服务类
@property (strong, nonatomic) NSMutableArray * imageFilePathArray;  // 点击看大图数据源
@property (assign, nonatomic) BOOL   isHomeMessageRequestSuccess;   // 首页我的消息接口是否返回数据标示
@property (strong, nonatomic)   BaseModel * baseModel;              // 服务类基础返回MODEL

// dw add V1.1
@property (nonatomic, strong) PlotService * plotService;
@property (strong,nonatomic) ArticleService      *articleService;
@property (nonatomic,strong) ShareView      *shareView;//分享页面
@property (nonatomic, assign) NSInteger shareSection;
@property (nonatomic,strong) ShareToSnsService   *shareService;
@end

@implementation HomPageViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self config];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_adScrollerView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_adScrollerView fireTimer];
}

/**
 *  配置信息
 */
- (void)config{
    if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
        int num = [[MessageDataManager defaultManager] queryMyUnReadMessage:[LoginManager shareInstance].loginAccountInfo.uId cId:CID_FOR_REQUEST];
        NSString *numStr = [NSString stringWithFormat:@"%d",num];
        _headViewMyMessageNumLabel.text = numStr;
        if (num != 0) {
            _headViewMyMessageButtonView.hidden = NO;
        }else{
            _headViewMyMessageButtonView.hidden = YES;
        }
        [self requestPackageService];
        [self requestMyMesssageService];
    }
    else{
        _headViewExpressButtonView.hidden = YES;
        _headViewMyMessageButtonView.hidden = YES;
    }
    [self requestAnnounceService];
    [self requestNewMessageService];
    _isHomeMessageRequestSuccess = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"PlotSomethingNewTableViewCell" bundle:nil];
    [_mainRefreshTableView registerNib:cellNib forCellReuseIdentifier:cellIndentifier];
    self.prototypeCell  = [_mainRefreshTableView dequeueReusableCellWithIdentifier:cellIndentifier];

    _headView.frame = CGRectMake(0, 0, _mainRefreshTableView.frame.size.width, 120 + UIScreenWidth * 8 / 15);
    _topHeightConstraint.constant = UIScreenWidth * 8 / 15;
    [_mainRefreshTableView beginUpdates];
    [_mainRefreshTableView setTableHeaderView:_headView];
    [_mainRefreshTableView endUpdates];
    
    _adScrollerView = [[EScrollerView alloc] init];
    _adScrollerView.delegate = self;
    [_headView addSubview:_adScrollerView];
    
    NSDictionary *metrics = @{@"width":@(UIScreenWidth),@"vEdge":@(UIScreenWidth * 8 / 15)};
    _adScrollerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *adArrayConstraint = [NSMutableArray array];
    [adArrayConstraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adScrollerView(width)]|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_adScrollerView,_headView)]];
    [adArrayConstraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_adScrollerView(==vEdge)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_adScrollerView)]];
    [_headView addConstraints:adArrayConstraint];

    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = _mainRefreshTableView;
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        [self config];
        [_mainRefreshTableView headerEndRefreshing];
    }];
    
//    [weaktb addFooterWithCallback:^{
//        // 调用网络请求
//    }];
    self.plotSomeingArray = [[NSMutableArray alloc] init];
    self.myMessageService = [[MyMessageService alloc] init];
    self.packageService = [[PackageService alloc] init];
    self.helpInfoService = [[HelpInfoService alloc] init];
    self.announceService = [[AnnounceService alloc] init];
    self.imageFilePathArray = [[NSMutableArray alloc] init];
    self.adArray = [[NSMutableArray alloc] init];
    
    [self config];
    //添加通知 当用户登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(config)
                                                 name: LOGIN_SUCCESS_NOTIFICATION
                                               object: nil];
    
    //添加通知，当用户退出登陆
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(config)
                                                 name: LOGIN_OUT_NOTIFICATION
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMessageNumView) name:@"HAVEWATCHMESSAGE" object:nil];
    
    
    // dw add V1.1 初始化
    self.articleService = [[ArticleService alloc] init];
    
    self.shareService = [[ShareToSnsService alloc] init];
    
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [@"星雨华府" sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    tView = [[UIView alloc] initWithFrame:CGRectMake((UIScreenWidth - labelsize.width - 17) / 2, 0, labelsize.width + 17, 40)];
    [tView setBackgroundColor:[UIColor clearColor]];
    
    tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tView.frame.size.width - 17, 40)];
    [tLabel setBackgroundColor:[UIColor clearColor]];
    [tLabel setFont:[UIFont systemFontOfSize:20]];
    [tView addSubview:tLabel];
    
    tButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height)];
    [tButton setImage:[UIImage imageNamed:@"home_icon_arrow_24x14"] forState:UIControlStateNormal];
    [tView addSubview:tButton];
    [tButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [tButton addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    tButton.hidden = YES;
    
    self.navigationItem.titleView = tView;
    [self searchPlots];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPlots) name:@"SEARCHPLOTS" object:nil];
    // dw end
}

/**
 *  小区检索
 */
- (void)searchPlots{
    [[AppDelegate appDelegete] initDataFromService];
    if (!self.plotService) {
        self.plotService = [[PlotService alloc] init];
    }
    NSString * uidStr = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.plotService Bus101301:uidStr success:^(id responseObject) {
        PlotListModel * demoModel = (PlotListModel *)responseObject;
        for (PlotModel * tempModel in demoModel.doc) {
            if ([CID_FOR_REQUEST isEqualToString:tempModel.cId]) {
                CGSize size = CGSizeMake(320,2000);
                CGSize labelsize = [tempModel.cName sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
                tView.frame = CGRectMake((UIScreenWidth - labelsize.width - 17) / 2, tView.frame.origin.y, labelsize.width + 17, 40);
                tLabel.frame = CGRectMake(0, 0, tView.frame.size.width - 17, 40);
                tLabel.text = tempModel.cName;
                [tLabel setFont:[UIFont systemFontOfSize:20]];
                tButton.frame = CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height);
                break;
            }
        }
        
        if ([LoginManager shareInstance].loginAccountInfo.isLogin && demoModel.doc.count == 1) {
            tButton.hidden = YES;
        }else{
            tButton.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        
    }];
}


/**
 *  隐藏我的消息视图
 */
- (void)hideMessageNumView{
    _headViewMyMessageButtonView.hidden = YES;
}

/**
 *  查询未收邮包数量
 */
- (void)requestPackageService{
    [self.packageService Bus101201:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NewPackageNumModel class]]) {
            NewPackageNumModel *newPackageNumModel = (NewPackageNumModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:newPackageNumModel.retcode]) {
                if ([newPackageNumModel.theNewPost intValue] != 0) {
                    _headViewExpressButtonView.hidden = NO;
                }else{
                    _headViewExpressButtonView.hidden = YES;
                }
                _headViewExpressMessageNumLabel.text = newPackageNumModel.theNewPost;
            }
//            else{
//                _headViewExpressButtonView.hidden = YES;
//            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  我的消息查询
 */
- (void)requestMyMesssageService{
    [self.myMessageService Bus100701:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[MessageListModel class]]) {
            MessageListModel *messageListModel = (MessageListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:messageListModel.retcode]) {
                NSString *userId = [LoginManager shareInstance].loginAccountInfo.uId;
                [[MessageDataManager defaultManager] insertMessage:messageListModel userId:userId cId:CID_FOR_REQUEST];
                int num = [[MessageDataManager defaultManager] queryMyUnReadMessage:userId cId:CID_FOR_REQUEST];
                NSString *numStr = [NSString stringWithFormat:@"%d",num];
                _headViewMyMessageNumLabel.text = numStr;
                if (num != 0) {
                    _headViewMyMessageButtonView.hidden = NO;
                }else{
                    _headViewMyMessageButtonView.hidden = YES;
                }
            }
            if (!_baseModel) {
                _baseModel = [[BaseModel alloc] init];
            }
            _baseModel.retcode = messageListModel.retcode;
            _baseModel.retinfo = messageListModel.retinfo;
        }
        _isHomeMessageRequestSuccess = YES;
    } failure:^(NSError *error) {
        _isHomeMessageRequestSuccess = YES;
        if (!_baseModel) {
            _baseModel = [[BaseModel alloc] init];
        }
        _baseModel.retcode = @"000001";
        _baseModel.retinfo = OTHER_ERROR_MESSAGE;
    }];
}

/**
 *  新鲜事儿查询
 */
- (void)requestNewMessageService{
    [self.helpInfoService Bus100901:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NewsListModel class]]) {
            NewsListModel *newListModel = (NewsListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:newListModel.retcode]) {
                if ([self.plotSomeingArray count]>0) {
                    [self.plotSomeingArray removeAllObjects];
                }
                [self.plotSomeingArray addObjectsFromArray:newListModel.doc];
                [_mainRefreshTableView reloadData];
            }else{
                
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  轮播通告——列表查询
 */
- (void)requestAnnounceService{
    [self.announceService Bus100201:CID_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[AnnounceListModel class]]) {
            AnnounceListModel *announceListModel = (AnnounceListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:announceListModel.retcode]) {
                NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
                [self.adArray removeAllObjects];
                for (AnnounceModel *announceModel  in announceListModel.doc) {
                    [imagePathArray addObject:announceModel.imageUrl];
                    [self.adArray addObject:announceModel];
                }
                if (imagePathArray.count > 0) {
                    [_adScrollerView refreshHeadViewWithImgArray:imagePathArray];
                }else{
                    [_adScrollerView hidePageControlAndScrollview];
                }
            }else{
                [_adScrollerView hidePageControlAndScrollview];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  头部视图按钮点击触发
 *
 *  @param sender
 */
- (IBAction)headViewButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        switch ([btn tag]) {
            case 0:
                // 快递信息
            {
                if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    return;
                }
                ExpressMessageViewController *expressMsgVC = [[ExpressMessageViewController alloc] init];
                expressMsgVC.title = @"快递信息";
                [expressMsgVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:expressMsgVC animated:YES];
            }
                break;
            case 1:
                // 我的消息
            {
                if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    return;
                }
                MyMessageViewController *myMessageVC = [[MyMessageViewController alloc] init];
                myMessageVC.title = @"我的消息";
                [myMessageVC setHidesBottomBarWhenPushed:YES];
                myMessageVC.messageRequestSuccess = _isHomeMessageRequestSuccess;
                myMessageVC.baseModel = _baseModel;
                myMessageVC.isNotification = NO;
                [self.navigationController pushViewController:myMessageVC animated:YES];
            }
                break;
            case 2:
                // 我的账单
            {
                if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    return;
                }
                MyBillViewController *myBillVC = [[MyBillViewController alloc] init];
                myBillVC.title = @"我的账单";
                [myBillVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myBillVC animated:YES];
            }
                break;
            case 3:
                // 便民信息
            {
                HelpInfoForHouseOwnerViewController *helpInfoForHouseOwnerViewController = [[HelpInfoForHouseOwnerViewController alloc] init];
                helpInfoForHouseOwnerViewController.title = @"便民信息";
                helpInfoForHouseOwnerViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:helpInfoForHouseOwnerViewController animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

/**
 *  小区选择
 *
 *  @param sender
 */
- (void)titleButtonSelected:(id)sender {
    SelectedPlotsViewController * vc = [[SelectedPlotsViewController alloc] init];
    vc.title = @"选择小区";
    vc.hidesBottomBarWhenPushed = YES;
    vc.isHomePass = YES;
    vc.cidStr = CID_FOR_REQUEST;
    vc.buttonBlock = ^(NSString *titleStr,NSString * cid, NSString *city){
        [[AppDelegate appDelegete] initDataFromService];
        CGSize size = CGSizeMake(320,2000);
        CGSize labelsize = [titleStr sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        tView.frame = CGRectMake((UIScreenWidth - labelsize.width - 17) / 2, 0, labelsize.width + 17, 40);
        tLabel.frame = CGRectMake(0, 0, tView.frame.size.width - 17, 40);
        tLabel.text = titleStr;
        tButton.frame = CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height);
        if ([LoginManager shareInstance].loginAccountInfo.isLogin){
            [[AppDelegate appDelegete] autoLoginIsSelectedPlot:YES];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//[self.plotSomeingArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.plotSomeingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlotSomethingNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell refrashDataSourceWithNewsModel:(NewsModel *)self.plotSomeingArray[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        [_tableViewSectionCustomView setBackgroundColor:UIColorFromRGB(0xeeeeee)];
        return _tableViewSectionCustomView;
    }else{
        return nil;
    }
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
//    [tempView setBackgroundColor:[UIColor clearColor]];
//    
//    ArticleBottom * bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ArticleBottom" owner:self options:nil]objectAtIndex:0];
//    [bottomView initial];
//    [bottomView setFrame:CGRectMake(44, 0, tempView.frame.size.width - 44, 44)];
//    bottomView.delegate =self;
//    NewsModel * article = (NewsModel *)self.plotSomeingArray[section];
//    [bottomView setData:(ArticleDetailModel *)article];
//    bottomView.section = section;
//    [tempView addSubview:bottomView];
//    
//    if (section == self.plotSomeingArray.count -1) {
//        UIImage * image = [UIImage imageNamed:@"end_tips_60x42"];
//        tempView.frame = CGRectMake(0, 0, tableView.frame.size.width, 44 + image.size.height + 10);
//        UIImageView * footIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//        [footIV setImage:image];
//        [tempView addSubview:footIV];
//        [footIV setCenter:CGPointMake(tempView.frame.size.width / 2, 44 + image.size.height / 2 + 5)];
//    }
//    return tempView;
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取Cell
//    PlotSomethingNewTableViewCell *cell = (PlotSomethingNewTableViewCell *)self.prototypeCell;
//    [cell refrashDataSourceWithNewsModel:(NewsModel *)self.plotSomeingArray[indexPath.section]];
//    //通过systemLayoutSizeFittingSize返回最低高度
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height = [PlotSomethingNewTableViewCell height:(NewsModel *)self.plotSomeingArray[indexPath.section]];
    return 136;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 38.0f;
    }else{
        return 1.0f;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 44;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[indexPath.row];
    ArticleDetailViewController * articleDetailVC = [[ArticleDetailViewController alloc] init];
    articleDetailVC.articleId = newsModel.articleId;
    articleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float height = scrollView.contentSize.height > _mainRefreshTableView.frame.size.height ? _mainRefreshTableView.frame.size.height : scrollView.contentSize.height;
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) >= -10) {
        // 调用上拉刷新方法
        [_mainRefreshTableView footerBeginRefreshing];
    }
}

#pragma mark - EScrollerViewDelegate
- (void)ScrollImagesView:(long)index{
    if ([self.adArray count]>0 && index>0) {
        CircularDetailViewController *circularDetailVC = [[CircularDetailViewController alloc] init];
        circularDetailVC.title = @"活动详情";
        circularDetailVC.hidesBottomBarWhenPushed = YES;
        circularDetailVC.announceModel = (AnnounceModel *)self.adArray[index - 1];
        [self.navigationController pushViewController:circularDetailVC animated:YES];
    }
}

#pragma mark - PlotSonethingNewTableViewCellDelegate
/**
 *  点击头像
 *
 *  @param indexPath
 */
- (void)headImageViewSelected:(NSIndexPath *)indexPath{
    UserPageViewController * userPageVC = [[UserPageViewController alloc] init];
    NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[indexPath.section];
    userPageVC.queryUid = newsModel.uId;
    userPageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userPageVC animated:YES];
}

/**
 *  点击举报
 *
 *  @param indexPath
 */
- (void)reportImageViewSelected:(NSIndexPath *)indexPath{
    [SVProgressHUD showSuccessWithStatus:@"您的举报已受理，我们会尽快处理您的举报"];
}

/**
 *  点击来自哪儿
 *
 *  @param indexPath
 */
- (void)fromHereButtonSelected:(NSIndexPath *)indexPath{

}

/**
 *  点击查看大图
 *
 *  @param indexPath    cell indexPath
 *  @param _selectIndex 序号
 */
- (void)uploadImageViewSelectedWithIndexPath:(NSIndexPath *)indexPath selectIndex:(int)_selectIndex{
    NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[indexPath.section];
    [self.imageFilePathArray removeAllObjects];
    [self.imageFilePathArray addObjectsFromArray:newsModel.imageList];
    //查看大图
    PhotosViewController      *photosController = [[PhotosViewController alloc] init];
    photosController.datasource = self;
    photosController.currentPage = _selectIndex;
    photosController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photosController animated:YES];
}

#pragma mark - PhotosViewDatasource

- (NSInteger)photosViewNumberOfCount
{
    return [self.imageFilePathArray count];
}

- (NSString *)photosViewUrlAtIndex:(NSInteger)index
{
    PlotImageModel * plotImageModel = (PlotImageModel *)[self.imageFilePathArray objectAtIndex:index];
    return plotImageModel.imageUrlL;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //跳转到登陆页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //登录返回前需要请求圈子用户信息
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
//            [self searchPlots];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

#pragma mark - ArticleBottomDelegate
/**
 *  评论触发  跳转到话题详情页面
 *
 *  @param article  话题
 */
-(void) commentClick:(ArticleDetailModel*) data {
//    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
//        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//    }else{
        ArticleDetailViewController *controller = [[ArticleDetailViewController alloc]init];
        controller.articleDetailModel = data;
        controller.articleId = data.articleId;
        controller.hidesBottomBarWhenPushed = YES;
        controller.onlyComment = YES;
        [self.navigationController pushViewController:controller animated:YES];
//    }
}

/**
 *  点赞
 *
 *  @param articleId   话题id
 */
- (void)praiseClick:(NSString *)articleId withSection:(NSInteger)section{
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[section];
        newsModel.flag = @"1";
        int number = [newsModel.praiseNum intValue]+1;
        NSString *numberStr = [NSString stringWithFormat:@"%d",number];
        newsModel.praiseNum = numberStr;
        NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
        [self.articleService Bus300801:uid aId:articleId type:@"1" success:^(id responseObject) {
            [self.mainRefreshTableView reloadData];
        } failure:^(NSError *error) {
            [self.mainRefreshTableView reloadData];
        }];
    }
}

/**
 *  取消赞
 *
 *  @param articleId   话题id
 */
- (void)cancelPraiseClick:(NSString *)articleId withSection:(NSInteger)section{
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[section];
        newsModel.flag = @"0";
        int number = [newsModel.praiseNum intValue]-1;
        NSString *numberStr = [NSString stringWithFormat:@"%d",number];
        newsModel.praiseNum = numberStr;
        NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
        [self.articleService Bus300801:uid aId:articleId type:@"0" success:^(id responseObject) {
            [self.mainRefreshTableView reloadData];
        } failure:^(NSError *error) {
            [self.mainRefreshTableView reloadData];
        }];
    }
}


- (void)shareArticle:(NSString *)articleId withSection:(NSInteger)section{
    self.shareSection = section;
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
    
//    for (NewsModel * newsModel in self.plotSomeingArray) {
//        if ([articleId isEqualToString:newsModel.articleId]) {
//            SuperArticleListViewController  * vc = [[SuperArticleListViewController alloc] init];
//            vc.title = @"移动";
//            vc.formID = newsModel.id;
//            vc.articleID = articleId;
//            vc.callBackBlock = ^(){
//                
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//    }
}
    
#pragma  mark - 分享  SocialShareViewDelegate

//分享
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType {
    [self.shareView dismissPage];
    
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[self.plotSomeingArray objectAtIndex:self.shareSection];
    
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
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[self.plotSomeingArray objectAtIndex:self.shareSection];
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
        NewsModel * newsModel = (NewsModel *)self.plotSomeingArray[self.shareSection];
        SuperArticleListViewController  * vc = [[SuperArticleListViewController alloc] init];
        vc.title = @"移动";
        vc.formID = newsModel.id;
        vc.articleID = newsModel.articleId;
        vc.callBackBlock = ^(){
            // 刷新吗？
            [self requestNewMessageService];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma  mark - 分享成功 ShareToSnsServiceDelegate

/**
 *  分享成功
 */
- (void)shareToSnsPlatformSuccessed
{
    ArticleDetailModel *articleModel = (ArticleDetailModel *)[self.plotSomeingArray objectAtIndex:self.shareSection];
    
    [self.articleService Bus300901:articleModel.articleId success:^(id responseObj){
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            // 分享次数+1 self.sharedindexPath
//            ArticleDetailModel *model = [self.articleArray objectAtIndex:self.sharedIndexPath.row];
//            model.shareNum =[NSString stringWithFormat:@"%d",[model.shareNum intValue]+1] ;
//            [self.myArticleTableView reloadData];
            [SVProgressHUD showSuccessWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        
    }];
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
