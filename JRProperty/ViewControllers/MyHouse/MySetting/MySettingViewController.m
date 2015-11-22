//
//  MySettingViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MySettingViewController.h"
#import "MySettingTableViewCell.h"
#import "LoginViewController.h"
#import "LoginManager.h"
#import "SettingService.h"
#import "UIDevice+IdentifierAddition.h"
#import "VersionModel.h"
#import "VersionUpdateView.h"
#import "SVProgressHUD.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "UIView+Additions.h"

@interface MySettingViewController ()<UIAlertViewDelegate>
{
    
}

@property (weak,nonatomic)    IBOutlet  UIScrollView    *mainScrollView;
@property (weak,nonatomic)    IBOutlet  UIView          *checkVersionView;
@property (weak,nonatomic)    IBOutlet  UIView          *feedBackView;
@property (weak,nonatomic)    IBOutlet  UIView          *aboutView;
@property (weak,nonatomic)    IBOutlet  UIView          *logoutView;
@property (weak,nonatomic)    IBOutlet  UILabel         *newsNotificationLabel;
@property (weak,nonatomic)    IBOutlet  UIImageView     *dashSeperatorLine;

@property (weak,nonatomic)    IBOutlet  NSLayoutConstraint  *seperatorLineLeadingCon;
@property (weak,nonatomic)    IBOutlet  NSLayoutConstraint  *notificationTipHeightCon;

@property (strong,nonatomic)  SettingService            *settingService;


@end

static const NSString *SectionOne = @"SectionOne";
static const NSString *SectionTwo = @"SectionTwo";

@implementation MySettingViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_shezhi"]];
    // Do any additional setup after loading the view.
    // 初始化样式和布局
    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.dashSeperatorLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mybill_check_list_line_dash_4x1_mid"]]];

    // 初始化操作
//    UITapGestureRecognizer *checkTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkViewTapped:)];
//    [self.checkVersionView addGestureRecognizer:checkTap];
    
    UITapGestureRecognizer *feedbackTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(feedbackViewTapped:)];
    [self.feedBackView addGestureRecognizer:feedbackTap];
    
    UITapGestureRecognizer *aboutTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aboutViewTapped:)];
    [self.aboutView addGestureRecognizer:aboutTap];
    
    UITapGestureRecognizer *logoutTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoutViewTapped:)];
    [self.logoutView addGestureRecognizer:logoutTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotificationStatus)
                                                 name:MYSETTING_REFRESH_NOTIFICATION
                                               object:nil];
    
    // 初始化数据
    self.settingService = [[SettingService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshNotificationStatus];
    
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        // 未登录情况下不显示退出
        self.logoutView.hidden = YES;
        self.seperatorLineLeadingCon.constant = 0;
        [self.view layoutIfNeeded];
    }
    else{
        self.logoutView.hidden = NO;
        self.seperatorLineLeadingCon.constant = 20;
        [self.view layoutIfNeeded];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        self.notificationTipHeightCon.constant = 116;
        [self.view layoutIfNeeded];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


#pragma mark - Actions
/**
 *  打开或者关闭提醒
 *
 *  @param sender
 */
- (IBAction)newsRemindSwitch:(id)sender
{
//    NSString *reminder = [[NSUserDefaults standardUserDefaults] objectForKey:@"reminderSwitch"];
//
//    if ([reminder isEqualToString:@"1"]) {
//        // 关闭提醒
//        [self.reminderSwitchButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_off.png"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"reminderSwitch"];
//    }
//    else{
//        // 打开提醒
//        [self.reminderSwitchButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_on.png"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"reminderSwitch"];
//    }
    
}

/**
 *  检查版本更新
 *
 *  @param sender
 */
- (void)checkViewTapped:(id)sender
{
    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    //设备号
    NSString *imeiStr = [[UIDevice currentDevice] myGlobalDeviceId];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.settingService Bus500201:curVersion type:@"2" imei:imeiStr success:^(id responseObj)
    {
        VersionModel *versionModel = (VersionModel *)responseObj;
        
        if ([versionModel.retcode isEqualToString:@"000000"]) {
            
            [SVProgressHUD dismiss];
            
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
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wo-de-xiao-ba/id954184194"]];
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
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wo-de-xiao-ba/id954184194"]];
                    }
                };
                versionView.rightBlock = ^() {
                    exit(0);
                };
            }
        }
        else if([versionModel.retcode isEqualToString:@"000019"]){
            [SVProgressHUD showSuccessWithStatus:versionModel.retinfo];
        }
        else{
            [SVProgressHUD showErrorWithStatus:versionModel.retinfo];
        }
     
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"检查更新失败，请稍后重试"];
    }];
}

/**
 *  反馈
 *
 *  @param sender
 */
- (void)feedbackViewTapped:(id)sender
{
    // 到反馈页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    FeedbackViewController *feedbackController = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    feedbackController.title = @"意见反馈";
    [self.navigationController pushViewController:feedbackController animated:YES];
}

/**
 *  查看关于
 *
 *  @param sender
 */
- (void)aboutViewTapped:(id)sender
{
    // 到关于
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    AboutViewController *aboutController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    aboutController.title = @"关于";
    [self.navigationController pushViewController:aboutController animated:YES];
}

/**
 *  注销操作
 *
 *  @param sender
 */
- (void)logoutViewTapped:(id)sender
{
    [[LoginManager shareInstance] resetAccountInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_OUT_NOTIFICATION object:self];
    // dw add 清除登录信息
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ucid"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isSuper"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEARCHPLOTS" object:nil];
    // dw end
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
    loginViewController.phoneTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_ACCOUNT_PHONE];
    loginViewController.loginButtonBlock = ^{
        // 登录成功回，回到会员中心页面
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  判断是否登录
 *
 *  @return YES:已登录 NO:未登录
 */
- (BOOL)isLogin
{
    if ([LoginManager shareInstance].loginAccountInfo.isLogin) {
        return YES;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录"
                                                            message:@"您还未登录，是否登录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        [alertView show];
        
        return NO;
    }
}

/**
 *  更新通知状态
 */
- (void)refreshNotificationStatus
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *userSetting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (userSetting.types == UIUserNotificationTypeNone)
        {
            [self.newsNotificationLabel setText:@"已关闭"];
        }else{
            [self.newsNotificationLabel setText:@"已开启"];
        }
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if (types == UIRemoteNotificationTypeNone)
        {
            [self.newsNotificationLabel setText:@"已关闭"];
        }else{
            [self.newsNotificationLabel setText:@"已开启"];
        }
    }
}

#pragma  mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        // 登录页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
