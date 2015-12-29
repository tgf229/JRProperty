//
//  HomPageViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HomFragmentController.h"
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
#import "PropertyService.h"
#import "ArticleBottom.h"
#import "MyWorkOrderListViewController.h"
#import "CompanyInfoViewController.h"
#import "ServiceListModel.h"
#import "PlotService.h"
#import "PlotListModel.h"
#import "UIImageView+WebCache.h"
#import "PropertyServiceCommonPostViewController.h"
#import "FleaMarketListViewController.h"
#import "PraiseListViewController.h"

//static NSString *cellIndentifier = @"PlotSomethingNewTableViewCellIndentifierlalal";

@interface HomFragmentController ()<PlotSonethingNewTableViewCellDelegate,PhotosViewDatasource,PhotosViewDelegate,ArticleBottomDelegate>
{
    UIView * tView;
    UILabel * tLabel;
    UIButton * tButton;
}
@property (strong, nonatomic) MyMessageService *myMessageService;   // 我的消息业务请求服务类
@property (strong, nonatomic) PackageService  *packageService;      // 快递业务服务类
@property (strong, nonatomic) HelpInfoService *helpInfoService;     // 便民信息业务服务类
@property (strong, nonatomic) AnnounceService *announceService;     // 轮播通告业务服务类
@property (strong, nonatomic) PropertyService *propertyService;
@property (strong, nonatomic) NSMutableArray * imageFilePathArray;  // 点击看大图数据源
@property (assign, nonatomic) BOOL   isHomeMessageRequestSuccess;   // 首页我的消息接口是否返回数据标示
@property (strong, nonatomic)   BaseModel * baseModel;              // 服务类基础返回MODEL

// dw add V1.1
@property (nonatomic, strong) PlotService * plotService;

@property (strong, nonatomic) ServiceListModel *serviceListModel;

@end

@implementation HomFragmentController

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
    _isHomeMessageRequestSuccess = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    _contentSubView.backgroundColor = [UIColor getColor:@"eeeeee"];
   
    //===================================================
    _headView.frame = CGRectMake(0, 0, _mainRefreshTableView.frame.size.width, 120 + UIScreenWidth * 8 / 15);
    _topHeightConstraint.constant = UIScreenWidth * 8 / 15;
    [_mainRefreshTableView beginUpdates];
    [_mainRefreshTableView setTableHeaderView:_headView];
    [_mainRefreshTableView endUpdates];
    _adScrollerView = [[EScrollerView alloc] init];
    _adScrollerView.delegate = self;
    [_headView addSubview:_adScrollerView];
    [_headView setHidden:YES];
     //===================================================
    
    _contentView.backgroundColor = [UIColor getColor:@"eeeeee"];
    _contentView.frame = CGRectMake(0, 0, _mainRefreshTableView.frame.size.width, 30+650 + UIScreenWidth * 8 / 15);
    _topHeightConstraint.constant = UIScreenWidth * 8 / 15+15;
    [_mainRefreshTableView beginUpdates];
    [_mainRefreshTableView setTableHeaderView:_contentView];
    [_mainRefreshTableView endUpdates];
    _adScrollerView = [[EScrollerView alloc] init];
    _adScrollerView.delegate = self;
    [_contentView addSubview:_adScrollerView];
    
    NSDictionary *metrics = @{@"width":@(UIScreenWidth),@"vEdge":@(UIScreenWidth * 8 / 15)};
    _adScrollerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *adArrayConstraint = [NSMutableArray array];
    [adArrayConstraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_adScrollerView(width)]|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_adScrollerView,_contentView)]];
    [adArrayConstraint addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_adScrollerView(==vEdge)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_adScrollerView)]];
    [_contentView addConstraints:adArrayConstraint];
    
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRName"];
    NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAddress"];
    _companyLabel.text = [NSString stringWithFormat:@"%@",nameStr?nameStr:@""];
    _companyAddressLabel.text = [NSString stringWithFormat:@"%@",addressStr?addressStr:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePropertyInfo) name:@"CHANGEPROPERTYINFO" object:nil];

    // 在block中引用变量，需要定义一个weak对象指向原对象，防止在block中循环引用，导致内存泄露
    __weak UITableView * weaktb = _mainRefreshTableView;
    [weaktb addHeaderWithCallback:^{
        // 调用网络请求
        [self config];
        [self removeAllServiceItemSubviews];
        [self reqServiceItem];
        [_mainRefreshTableView headerEndRefreshing];
    }];
    
    
    self.myMessageService = [[MyMessageService alloc] init];
    self.packageService = [[PackageService alloc] init];
    self.helpInfoService = [[HelpInfoService alloc] init];
    self.propertyService = [[PropertyService alloc] init];
    self.announceService = [[AnnounceService alloc] init];
    self.serviceListModel = [[ServiceListModel alloc] init];
    self.adArray = [[NSMutableArray alloc] init];
    
    [self config];
    [self reqServiceItem];
    
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
    
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [@"桃花源云社区" sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
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

-(void)reqServiceItem{
    [self.propertyService Bus200901:CID_FOR_REQUEST success:^(id responseObject) {
        self.serviceListModel = (ServiceListModel *)responseObject;
        if ([RETURN_CODE_SUCCESS isEqualToString:self.serviceListModel.retcode]) {
            if (self.serviceListModel.doc.count > 0) {
                [self showServiceItem];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void) showServiceItem{
    CGFloat width = UIScreenWidth/4;
    CGFloat w = width / 3;
    CGFloat height = ((self.serviceListModel.doc.count-1)/4 + 1) * width;
    _serviceListHeightConstraint.constant =  height;
    for (int i=0; i<self.serviceListModel.doc.count; i++) {
        ServiceItemModel *itemModel = [[ServiceItemModel alloc]init];
        itemModel = [self.serviceListModel.doc objectAtIndex:i];
        CGFloat x = i % 4 * width;
        CGFloat y = i / 4 * width;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+w, y+w-w/2+5, w, w)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:itemModel.sImage] placeholderImage:[UIImage imageNamed:@"community_default.png"]];
       
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y+w+w/2+10+5, width, 12)];
        label.textAlignment= NSTextAlignmentCenter;
        label.text = itemModel.sName;
        label.textColor = [UIColor getColor:@"333333"];
        label.font = [UIFont systemFontOfSize:12];
        
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(x+width, y, 1, width)];
        [rightImage setImage:[UIImage imageNamed:@"line_vertical_1x20.png"]];
        UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(x,y+width,width,1)];
        [bottomImage setImage:[UIImage imageNamed:@"line_grey_foot_40x1.png"]];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, width)];
        if ([JOB_ADVISE isEqualToString:itemModel.sId]) {
            [button setTag:0];
        }else if ([JOB_COMPLAIN isEqualToString:itemModel.sId]) {
            [button setTag:1];
        }
        else if ([JOB_HELP isEqualToString:itemModel.sId]) {
            [button setTag:2];
        }
        else if ([JOB_REPAIR isEqualToString:itemModel.sId]) {
            [button setTag:3];
        }
        else if ([STAFF_PRAISE isEqualToString:itemModel.sId]) {
            [button setTag:4];
        }
        else if ([SERVICE_PARCEL isEqualToString:itemModel.sId]) {
            [button setTag:5];
        }
        else if ([SERVICE_PAYMENT isEqualToString:itemModel.sId]) {
            [button setTag:6];
        }
        else if ([SERVICE_CONVENIENT isEqualToString:itemModel.sId]) {
            [button setTag:7];
        }
        [button addTarget:self action:@selector(serviceItemClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [self.serviceListView addSubview:imageView];
        [self.serviceListView addSubview:label];
        [self.serviceListView addSubview:rightImage];
        [self.serviceListView addSubview:bottomImage];
        [self.serviceListView addSubview:button];
    }
    
    UIImageView *bImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, height-1, UIScreenWidth, 1)];
    [bImage setImage:[UIImage imageNamed:@"line_grey_foot_40x1.png"]];
    [self.serviceListView addSubview:bImage];
}

-(void)serviceItemClick:(UIButton *)btn{
    switch ([btn tag]) {
        case 0:
            [self enterPropertyServiceCommonPostViewController:@"建议"];
            break;
        case 1:
            [self enterPropertyServiceCommonPostViewController:@"投诉"];
            break;
        case 2:
            [self enterPropertyServiceCommonPostViewController:@"求助"];
            break;
        case 3:
            [self enterPropertyServiceCommonPostViewController:@"报修"];
            break;
        case 4:
            //表扬
            {
            UIStoryboard *praiseStoryboard = [UIStoryboard storyboardWithName:@"PraiseStoryboard" bundle:nil];
            
            PraiseListViewController *praiseListViewController = [praiseStoryboard instantiateViewControllerWithIdentifier:@"praiseListViewController"];
            
            praiseListViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:praiseListViewController animated:YES];
            }
            break;
        case 5:
            {
            //快递
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
        case 6:
            //缴费
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
        case 7:
            //便民信息
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

-(IBAction)enterFleaMarketClick:(id)sender{
    UIStoryboard *fleaMarketStoryboard = [UIStoryboard storyboardWithName:@"FleaMarketStoryboard" bundle:nil];
    FleaMarketListViewController *fleaMarketListViewController = [fleaMarketStoryboard instantiateViewControllerWithIdentifier:@"fleaMarketListViewController"];
     fleaMarketListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fleaMarketListViewController animated:YES];
    
}

- (void)enterPropertyServiceCommonPostViewController:(NSString *)titleName{
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
            UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        return;
    }
    
    PropertyServiceCommonPostViewController *propertyServiceCommonPostVC = [[PropertyServiceCommonPostViewController alloc] init];
    propertyServiceCommonPostVC.title = titleName;
    propertyServiceCommonPostVC.hidesBottomBarWhenPushed = YES;
    propertyServiceCommonPostVC.propertyServiceCommentSuccessBlock = ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@成功",titleName] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    };
    [self.navigationController pushViewController:propertyServiceCommonPostVC animated:YES];
}

- (void)removeAllServiceItemSubviews {
    while (self.serviceListView.subviews.count) {
        UIView* child = self.serviceListView.subviews.lastObject;
        [child removeFromSuperview];
    }
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
 *  按钮点击效果
 *
 *  @param sender
 */
- (IBAction)propertyButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        switch ([btn tag]) {
            case 0:
                // 我的工单
            {
                MyWorkOrderListViewController *myWorkOrderListViewController = [[MyWorkOrderListViewController alloc] init];
                myWorkOrderListViewController.title = @"我的工单";
                myWorkOrderListViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myWorkOrderListViewController animated:YES];
            }
                break;
            case 1:
                // 一键呼叫
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
                // 特点: 直接拨打, 不弹出提示。 并且, 拨打完以后, 留在通讯录中, 不返回到原来的应用。
            {
                NSString *telStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRTel"];
                telStr = [telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([@"" isEqualToString:telStr]||telStr==nil) {
                    [SVProgressHUD showErrorWithStatus:@"暂无号码信息"];
                    return;
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                // 特点: 拨打前弹出提示。 并且, 拨打完以后会回到原来的应用。
            }
                break;
            case 3:
                // 物业公司介绍
            {
                CompanyInfoViewController *companyInfoViewController = [[CompanyInfoViewController alloc] init];
                companyInfoViewController.title = @"物业公司介绍";
                companyInfoViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:companyInfoViewController animated:YES];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
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
        circularDetailVC.title = @"详情";
        circularDetailVC.hidesBottomBarWhenPushed = YES;
        circularDetailVC.announceModel = (AnnounceModel *)self.adArray[index - 1];
        [self.navigationController pushViewController:circularDetailVC animated:YES];
    }
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
            [self searchPlots];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePropertyInfo{
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRName"];
    NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAddress"];
    _companyLabel.text = [NSString stringWithFormat:@"%@",nameStr?nameStr:@""];
    _companyAddressLabel.text = [NSString stringWithFormat:@"%@",addressStr?addressStr:@""];
    
    [self removeAllServiceItemSubviews];
    [self reqServiceItem];
}

@end
