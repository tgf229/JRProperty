//
//  AppDelegate.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "HomPageViewController.h"
#import "PropertyServiceViewController.h"
#import "NeighborViewController.h"
#import "MemberCenterViewController.h"
#import "LoginViewController.h"
#import "RegisterCheckHouseViewController.h"
#import "UIColor+extend.h"
#import "UIDevice+IdentifierAddition.h"
#import "LoginManager.h"
#import "LoginModel.h"
#import "InitService.h"
#import "InitModel.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "APService.h"
#import "SVProgressHUD.h"
#import "LoginManager.h"
#import "UserService.h"
#import "SettingService.h"
#import "MyMessageViewController.h"
#import "CircleDetailViewController.h"
#import "CircularDetailViewController.h"
#import "AnnounceListModel.h"
#import "MySettingViewController.h"
#import "JRPropertyUntils.h"
#import "PackageService.h"
#import "NewPackageNumModel.h"
//百度统计
#import "BaiduMobStat.h"

#import "VersionModel.h"
#import "VersionUpdateView.h"

@interface AppDelegate ()<UIAlertViewDelegate,WelcomeControllerDelegate>
{
    BOOL _isLoginPageShow;  // 登录页面是否已经展示
    BOOL _isGetRemoteNotification;  // 是否是从消息栏打开
}
@property (strong, nonatomic) UserService     *userService;
@property (strong, nonatomic) PackageService     *packageService;

@property (strong, nonatomic) InitService     *service;
@property (strong, nonatomic) SettingService  *settingService;
@property (strong, nonatomic) NSTimer         *countDownTimer;
@property (strong, nonatomic) NSURL           *launchOptionsURL;
@property (strong, nonatomic) UIButton        *circleMessageButton;
@property (strong, nonatomic) UITabBarItem    *barItem3;
@end

@implementation AppDelegate

+ (AppDelegate *) appDelegete
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     //[[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    WelcomeViewController *welComeView=[[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    welComeView.delegate = self;
    self.window.rootViewController = welComeView;
    [self.window makeKeyAndVisible];
   
    // 初始化数据
//    [self initDataFromService];
    
    //控制欢迎页
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:VERSION_GUIDE_KEY] integerValue] < VERSION_NUM_FOR_GUIDE)
    {
        //获取老版本的用户名和密码
        NSString *oldAccountName =[[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_ACCOUNT_PHONE];
        AccountInfo *oldUser = [AccountInfo getAccountInfo];
        if (oldAccountName == nil) {
            if (oldUser != nil) {
                if (oldUser.isLogin) {
                    [[NSUserDefaults standardUserDefaults]setObject:oldUser.username forKey:LOGIN_ACCOUNT_PHONE];
                    [LoginManager shareInstance].loginAccountInfo.isAutoLogin = YES;
                    [LoginManager shareInstance].loginAccountInfo.isLogin = NO;
                    [LoginManager shareInstance].loginAccountInfo.password = oldUser.password;
                }
            }
        }
        else {
            if (oldUser != nil) {
                if (oldUser.isLogin) {
                    [LoginManager shareInstance].loginAccountInfo.isAutoLogin = YES;
                    [LoginManager shareInstance].loginAccountInfo.isLogin = NO;
                    [LoginManager shareInstance].loginAccountInfo.password = oldUser.password;
                }
            }
        }
        //首次安装，显示引导页面
        [welComeView createGuidePageView];
    }
    else{
        // 检查是否自动登录
        if ([LoginManager shareInstance].loginAccountInfo.isAutoLogin) {
            // 程序启动，自动登录
            [self autoLoginIsSelectedPlot:NO];
            // 3秒后，未自动登录成功，进入登录页
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoLoginExceed) userInfo:nil repeats:NO];
            self.countDownTimer = timer;
        }
        else{
            // 进入登录页面
            [self showLoginPage];
        }
    }



    self.launchOptionsURL = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
    //百度统计
    [self configBaiduMobStat];
    
    //清空消息
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //友盟分享
    [UMSocialData setAppKey:@"56206fcc67e58e89010005b4"];
    
    //设置微信
    [UMSocialWechatHandler setWXAppId:@"wx99e5dfd086492c32" appSecret:@"dcf38e6118b73b8c71e1051021e2da4a" url:HTTP_APP_DOWNLOAD_URL];
    
    //设置手机QQ
    [UMSocialQQHandler setQQWithAppId:@"QQ41DA6071" appKey:@"ZaPcXuZhJfaufZ6a" url:HTTP_APP_DOWNLOAD_URL];
    [UMSocialQQHandler setSupportWebView:YES];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址,需要 #import "UMSocialTencentWeiboHandler.h"
//    //打开人人网SSO开关,需要 #import "UMSocialRenrenHandler.h"
//    [UMSocialRenrenHandler openSSO];
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    //添加通知 当用户登陆成功之后像极光发送别名
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setAliasForLoginUser)
                                                 name: LOGIN_SUCCESS_NOTIFICATION
                                               object: nil];
    
    //添加通知，当用户退出登陆后清空别名
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearAliasForLoginUser)
                                                 name: LOGIN_OUT_NOTIFICATION
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestCircleMessage)
                                                 name: LOGIN_SUCCESS
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestCircleMessage)
                                                 name: LOGIN_SUCCESS_NOTIFICATION
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestCircleMessage)
                                                 name: @"CHANGEPROPERTYINFO"
                                               object: nil];
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        _isGetRemoteNotification = dictionary ? YES : NO;  // 是否打开我的消息页面
    }

    
    return YES;
}

/**
 *   这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 *   处理第三方app打开分享链接
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    
    if ([url.scheme isEqualToString:@"jiarun"]) {
        // 到活动或者话题话题详情
        [self goToActivityOrToppicDetail:url];
    }
    
    return YES;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}


#pragma  mark - 初始化
/**
 *  初始化数据
 */
- (void)initDataFromService{
    // duw add 数据库版本号
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isUpdateDB"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    // duw end
    self.service = [[InitService alloc] init];
    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    //设备号
    NSString *imeiStr = [[UIDevice currentDevice] myGlobalDeviceId];

    [self.service Bus100101:curVersion type:@"2" model:[JRPropertyUntils deviceModelString] imei:imeiStr cid:CID_FOR_REQUEST success:^(id responseObject) {
        if ([responseObject isKindOfClass:[InitModel class]]) {
            InitModel *initModel = (InitModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:initModel.retcode]) {
                if ([@"1" isEqualToString:initModel.flag]) {
                    // 退出应用
                    exit(0);
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:initModel.address forKey:@"JRAddress"];
                    [[NSUserDefaults standardUserDefaults] setObject:initModel.tel forKey:@"JRTel"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEPROPERTYINFO" object:nil];
                }
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JRAddress"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JRTel"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEPROPERTYINFO" object:nil];
            }
        }
    } failure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JRAddress"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"JRTel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEPROPERTYINFO" object:nil];
    }];
}

/**
 *  自动登录
 *
 *  @param _isSelected 是否选择小区后自动登录
 */
- (void)autoLoginIsSelectedPlot:(BOOL)_isSelected
{
    if (self.userService == nil) {
        self.userService = [[UserService alloc] init];
    }

    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    //设备号
    NSString *imei=[[UIDevice currentDevice] myGlobalDeviceId];
    
    [self.userService Bus400201:[LoginManager shareInstance].loginAccountInfo.username
                           imei:imei ? imei : @""
                            pwd:[LoginManager shareInstance].loginAccountInfo.password
                            cId:[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]:nil
                           type:@"2"
                        version:curVersion
                        success:^(id responseObj)
     {
         if (!_isSelected) {
             [self.countDownTimer invalidate];
             
             if (_isLoginPageShow) {
                 return;
             }
         }
         
         LoginModel *loginModel = (LoginModel *)responseObj;
         
         if ([loginModel.retcode isEqual:@"000000"]) {
             if (!_isSelected) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS  object:self];
                 //[self requestCircleMessage];
                 // 移除欢迎页面，进入主页
                 [self showHomepages];
                 [LoginManager shareInstance].loginAccountInfo.isLogin = YES;
             }
         }
         else{
             if (!_isSelected) {
                 // 进入登录页面
                 [self showLoginPage];
             }
         }
         
     }failure:^(NSError *error){
         if (!_isSelected) {
             // 进入登录页面
             [self.countDownTimer invalidate];
             
             if (!_isLoginPageShow) {
                 [self showLoginPage];
             }
         }
     }];
}

/**
 *  登录超过3秒
 */
- (void)autoLoginExceed
{
    [self showLoginPage];
    
    _isLoginPageShow = YES;
}

/**
 *  显示登录页面
 */
- (void)showLoginPage
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    loginViewController.loginButtonBlock = ^{
        [self showHomepages];
    };
    JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
    self.window.rootViewController = nav;
}

/**
 *  初始并初始化主页
 */
- (void)showHomepages
{
    [self checkVersions];
    
    // 首页
    HomPageViewController *homeController = [[HomPageViewController alloc]init];
//    homeController.title = @"星雨华府";
    JRUINavigationController *navHome = [[JRUINavigationController alloc]initWithRootViewController:homeController];
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        UITabBarItem * barItem1 = [[UITabBarItem alloc] initWithTitle:@"小区" image:[UIImage imageNamed:@"home_icon_home"] tag:1];
        [barItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home_icon_home_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_icon_home"]];
        [navHome setTabBarItem:barItem1];
    } else {
        UITabBarItem * barItem1 = [[UITabBarItem alloc] initWithTitle:@"小区" image:[[UIImage imageNamed:@"home_icon_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_icon_home_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navHome setTabBarItem:barItem1];
    }
    
    // 物业服务
    PropertyServiceViewController *propertyServiceController = [[PropertyServiceViewController alloc]init];
    propertyServiceController.title = @"物业";
    JRUINavigationController *navHome2 = [[JRUINavigationController alloc]initWithRootViewController:propertyServiceController];
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        UITabBarItem * barItem2 = [[UITabBarItem alloc] initWithTitle:@"物业" image:[UIImage imageNamed:@"home_icon_service"] tag:2];
        [barItem2 setFinishedSelectedImage:[UIImage imageNamed:@"home_icon_service_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_icon_service"]];
        [navHome2 setTabBarItem:barItem2];
    } else {
        UITabBarItem * barItem2 = [[UITabBarItem alloc] initWithTitle:@"物业" image:[[UIImage imageNamed:@"home_icon_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_icon_service_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navHome2 setTabBarItem:barItem2];
    }
    
    // 邻里
    NeighborViewController *shoppingcartController = [[NeighborViewController alloc]init];
    JRUINavigationController *navHome3 = [[JRUINavigationController alloc]initWithRootViewController:shoppingcartController];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        self.barItem3= [[UITabBarItem alloc] initWithTitle:@"邻里" image:[UIImage imageNamed:@"home_icon_neighbor"] tag:3];
        [self.barItem3 setFinishedSelectedImage:[UIImage imageNamed:@"home_icon_neighbor_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_icon_neighbor"]];
        [navHome3 setTabBarItem:self.barItem3];
    } else {
        self.barItem3 = [[UITabBarItem alloc] initWithTitle:@"邻里" image:[[UIImage imageNamed:@"home_icon_neighbor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_icon_neighbor_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navHome3 setTabBarItem:self.barItem3];
    }
    
    // 我的家
    MemberCenterViewController *myController = [[MemberCenterViewController alloc]init];
    myController.title = @"我的";
    JRUINavigationController *navHome4 = [[JRUINavigationController alloc]initWithRootViewController:myController];
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        UITabBarItem * barItem4 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"home_icon_myhome"] tag:4];
        [barItem4 setFinishedSelectedImage:[UIImage imageNamed:@"home_icon_myhome_press"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_icon_myhome"]];
        [navHome4 setTabBarItem:barItem4];
    } else {
        UITabBarItem * barItem4 = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"home_icon_myhome"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"home_icon_myhome_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [navHome4 setTabBarItem:barItem4];
    }

    NSArray *array = [NSArray arrayWithObjects:navHome, navHome2, navHome3, navHome4, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeFont : [UIFont systemFontOfSize:12],UITextAttributeTextColor : [UIColor getColor:@"333333"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeFont : [UIFont systemFontOfSize:12],UITextAttributeTextColor : [UIColor getColor:@"333333"]} forState:UIControlStateSelected];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setViewControllers:array];
    self.tabBarController.delegate = self;
    // IOS6将tabbar背景设置成白色
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.tabBarController.tabBar.backgroundImage = image;
    }
    
    // IOS6取消tabbar高亮效果
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.tabBarController.tabBar setSelectionIndicatorImage:image];
    }
 
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if (self.launchOptionsURL && [self.launchOptionsURL.scheme isEqualToString:@"jiarun"])
    {
        // 打开活动或者话题页面
        [self goToActivityOrToppicDetail:self.launchOptionsURL];
    }
    
    if (_isGetRemoteNotification) {
        // 打开消息中心
        [self pushToMyMessageViewController];
    }
    int circleMessageNum =[[[NSUserDefaults standardUserDefaults]objectForKey:@"circleMessageNumber"]intValue];
    if (circleMessageNum!=0) {
        self.barItem3.badgeValue = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"circleMessageNumber"]];
    }
}


/**
 *  检查版本更新
 *
 *  @param sender
 */
- (void)checkVersions
{
    //当前版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    // 上一次检查的版本号
    NSString *lastCheckedVersion = [[NSUserDefaults standardUserDefaults]objectForKey:VERSION_LAST_CHECKED_KEY];
    
    //设备号
    NSString *imeiStr = [[UIDevice currentDevice] myGlobalDeviceId];
    
    if (self.settingService == nil) {
        self.settingService = [[SettingService alloc] init];
    }
    
    [self.settingService Bus500201:curVersion type:@"2" imei:imeiStr success:^(id responseObj)
     {
         VersionModel *versionModel = (VersionModel *)responseObj;
         
         if ([versionModel.retcode isEqualToString:@"000000"]) {
             
             if ([lastCheckedVersion isEqualToString:versionModel.version]) {
                 // 已检查过该版本，不再提示
                 //return;
             }
             else{
                 // 更新已检查过的版本
                 //[[NSUserDefaults standardUserDefaults] setObject:versionModel.version forKey:VERSION_LAST_CHECKED_KEY];
             }
             
             NSString *content = versionModel.content;
             NSArray *arr = nil;
             if (![content isEqualToString:@""]&&content!=nil){
                 arr = [content componentsSeparatedByString:@";"];
             }
             int newisUpdate= [versionModel.isUpdate intValue];    //是否强制更新 0：不强制更新 1：强制跟新
             NSString *url= versionModel.urlAddress;
             
             if (0 == newisUpdate) {
                 // 不强制更新
                 VersionUpdateView *versionView = [[VersionUpdateView alloc] initWithDocArray:arr isMust:NO];
                 __weak VersionUpdateView *weakVersionView = versionView;
                 weakVersionView.leftBlock = ^() {
                     if (url&&![url isEqualToString:@""]) {
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                     }else{
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://d.crossroad.love/app/download.html"]];
                     }
                 };
                 weakVersionView.rightBlock = ^() {
                     [weakVersionView removeViewFromSelf];
                 };
             }
             else if(1 == newisUpdate){
                 // 强制更新
                 VersionUpdateView *versionView = [[VersionUpdateView alloc] initWithDocArray:arr isMust:YES];
                 versionView.leftBlock = ^() {
                     if (url&&![url isEqualToString:@""]) {
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                     }else{
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://d.crossroad.love/app/download.html"]];
                     }
                 };
                 versionView.rightBlock = ^() {
                     exit(0);
                 };
             }
         }
         else if([versionModel.retcode isEqualToString:@"000019"]){
             //[SVProgressHUD showSuccessWithStatus:versionModel.retinfo];
             NSLog(@"check versions:%@",versionModel.retinfo);
         }
         else{
             //[SVProgressHUD showErrorWithStatus:versionModel.retinfo];
             NSLog(@"check versions:%@",versionModel.retinfo);
         }
         
     }failure:^(NSError *error){
         //[SVProgressHUD showErrorWithStatus:@"检查更新失败，请稍后重试"];
         NSLog(@"check versions failed");
     }];
}

#pragma  mark - WelcomeControllerDelegate

- (void)enterButtonPressed
{
    // 检查是否自动登录
    if ([LoginManager shareInstance].loginAccountInfo.isAutoLogin) {
        // 程序启动，自动登录
        [self autoLoginIsSelectedPlot:NO];
        
        // 3秒后，未自动登录成功，进入登录页
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoLoginExceed) userInfo:nil repeats:NO];
        self.countDownTimer = timer;
    }
    else{
        // 进入登录页面
        [self showLoginPage];
    }
    
    //进入app之后设置引导页标记为1
    [[NSUserDefaults standardUserDefaults] setInteger:VERSION_NUM_FOR_GUIDE forKey:VERSION_GUIDE_KEY];
}

#pragma  mark - JPush

/**
 *  为登陆用户设置别名
 */
-(void)setAliasForLoginUser{
    NSString  * userId = [NSString stringWithFormat:@"U_%@",[LoginManager shareInstance].loginAccountInfo.uId];
    if(![@"" isEqualToString:userId] && userId !=nil){
        [APService setAlias:userId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

/**
 *  回调方法
 *
 *  @param iResCode 返回码
 *  @param tags     设置的tag
 *  @param alias    设置的别名
 */
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if(iResCode ==0){
        NSLog(@"用户%@设置别名%@成功",[LoginManager shareInstance].loginAccountInfo.uId,alias);
    }else{
        NSLog(@"用户%@设置别名%@失败",[LoginManager shareInstance].loginAccountInfo.uId,alias);
    }
}

/**
 *  清除别名
 */
-(void)clearAliasForLoginUser
{
    [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}


#pragma mark - 打开分享
/**
 *  跳转到活动或者话题详情
 */
- (void)goToActivityOrToppicDetail:(NSURL *)url
{
    //url = [NSURL URLWithString:@"centermarket://share/activity?sid=2102"];
    //url = [NSURL URLWithString:@"centermarket://share/product?skuid=272300"];
    NSLog(@"shared url scheme:%@",[url scheme]);
    
    NSArray *pathArray = [url pathComponents];                            // 路径
    NSArray *paraArray = [[url query] componentsSeparatedByString:@"&"];  // 参数
    NSString *idString = [paraArray objectAtIndex:0];                     // 取第一个参数（id）
    NSArray *idArray = [idString componentsSeparatedByString:@"="];
    
    if ([idArray count] < 2) {
        // 不符合要求的地址，不处理
        return;
    }
    
    if([pathArray containsObject:@"activity"])
    {
        // 活动详情
        JRUINavigationController *navigationController = (JRUINavigationController *)self.tabBarController.selectedViewController;
        
        AnnounceModel *announceModel = [[AnnounceModel alloc] init];
        announceModel.id = [idArray objectAtIndex:1];
        
        CircularDetailViewController *circularDetail = [[CircularDetailViewController alloc]init];
        circularDetail.announceModel = announceModel;
        [navigationController pushViewController:circularDetail animated:YES];
    }
    else if([pathArray containsObject:@"circleDetail"])
    {
        // 话题详情
        JRUINavigationController *navigationController = (JRUINavigationController *)self.tabBarController.selectedViewController;
        CircleDetailViewController* circleDetail = [[CircleDetailViewController alloc]init];
        circleDetail.circleId = [idArray objectAtIndex:1];
        [navigationController pushViewController:circleDetail animated:YES];
    }
}


#pragma mark - UITabBar
// 获取指定ViewController
- (UINavigationController *)getNavigationControllerByIndex:(NSInteger)index
{
    UITabBarController *tabBar = self.tabBarController;
    
    if (nil != tabBar)
    {
        return (UINavigationController *)[tabBar.viewControllers objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

#pragma  mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self pushToMyMessageViewController];
    }
}

/**
 *  跳转到我的消息页面
 */
- (void)pushToMyMessageViewController
{
    UINavigationController *selectedNavigation = [[AppDelegate appDelegete] getNavigationControllerByIndex:self.tabBarController.selectedIndex];
    
    if (![[selectedNavigation.viewControllers lastObject] isMemberOfClass:[MyMessageViewController class]]) {
        // 没在消息页
        MyMessageViewController * messageController = [[MyMessageViewController alloc] init];
        messageController.title = @"我的消息";
        messageController.isNotification = YES;
        [messageController setHidesBottomBarWhenPushed:YES];
        [selectedNavigation pushViewController:messageController animated:YES];
    }
    else{
        // 发送接收消息通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HAVENEWMSGNOTIFICATION" object:nil];
    }
}

- (void)requestCircleMessage {
    if (self.packageService==nil) {
        self.packageService = [[PackageService alloc]init];
    }
    NSLog(@"自动请求%@,%@",CID_FOR_REQUEST,[LoginManager shareInstance].loginAccountInfo.uId);
    [self.packageService Bus101201:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        NewPackageNumModel *newPackageNumModel = (NewPackageNumModel *)responseObject;
        
        if ([RETURN_CODE_SUCCESS isEqualToString:newPackageNumModel.retcode]) {
            if ([newPackageNumModel.theNewReply intValue]>0) {
                [[NSUserDefaults standardUserDefaults]setObject:newPackageNumModel.theNewReply  forKey:@"circleMessageNumber"];
                [self.barItem3 setBadgeValue:newPackageNumModel.theNewReply];
                //[[NSNotificationCenter defaultCenter]postNotificationName:HAS_NEW_MESSAGE object:self];
            }
            else {
                [self.barItem3 setBadgeValue:0];
            }
            
        }
        else{
           [[NSUserDefaults standardUserDefaults]setObject:@"0"  forKey:@"circleMessageNumber"];
         }
    } failure:^(NSError *error) {
         [[NSUserDefaults standardUserDefaults]setObject:@"0"  forKey:@"circleMessageNumber"];
    }];
}


/**
 * 百度统计
 */
#pragma mark -
#pragma mark 百度统计
-(void)configBaiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;   // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.channelId = @"AppStore";    // 设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;// 根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 1;        // 为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = YES;      // 是否仅在WIfi情况下发送日志数据
    // 设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s,测试时使用1S可以用来测试日志的发送。
    statTracker.sessionResumeInterval = 35;
    // 参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;        // 打开sdk调试接口，会有log打印
    [statTracker startWithAppId:@"d7677d39f3"];// 设置您在mtj网站上添加的app的appkey
}

#pragma mark - remote notifications
//消息推送 第一次安装app会走这个方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //极光推送
    [APService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // 注册失败
    NSLog(@"消息推送注册失败！");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 极光推送
    [APService handleRemoteNotification:userInfo];
    // 接收推送过来的消息
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (application.applicationState != UIApplicationStateActive){
        // 如果应用在不在前台，跳转到我的消息页面
        [self pushToMyMessageViewController];
    }
    else{
        // 应用在前台，弹出提示
        NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您收到一条新消息"
                                                            message:alertValue
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"查看", nil];
        [alertView show];
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 接收推送过来的消息
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (application.applicationState != UIApplicationStateActive){
        // 如果应用在不在前台，跳转到我的消息页面
        [self pushToMyMessageViewController];
    }
    else{
        // 应用在前台，弹出提示
        NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您收到一条新消息"
                                                            message:alertValue
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"查看", nil];
        [alertView show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 通知设置页面刷新
    UINavigationController *selectedNavigation = [[AppDelegate appDelegete] getNavigationControllerByIndex:self.tabBarController.selectedIndex];
    
    if ([[selectedNavigation.viewControllers lastObject] isMemberOfClass:[MySettingViewController class]]) {
        // 在设置页面，通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:MYSETTING_REFRESH_NOTIFICATION object:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
