//
//  LoginViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "LoginViewController.h"
#import "JRDefine.h"
#import "RegisterCheckHouseViewController.h"
#import "ForgetPasswordViewController.h"
#import "UserService.h"
#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5HexDigest.h"
#import "LoginModel.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "UIView+Additions.h"
#import "RegexKitLite.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UIScrollView     *mainScrollView;     

@property (weak,nonatomic) IBOutlet UIView      *phoneInputView;     // 手机号整体view
@property (weak,nonatomic) IBOutlet UIView      *pwdInputView;       // 密码整体view
@property (weak,nonatomic) IBOutlet UITextField *pwdTextField;       // 密码

@property (weak,nonatomic) IBOutlet UIButton     *forgetPwdButton;   // 忘记密码按钮
@property (weak,nonatomic) IBOutlet UIButton     *loginButton;       // 登录按钮
@property (weak,nonatomic) IBOutlet UIView       *bottomButtonsView; // 底部操作整体view
@property (weak,nonatomic) IBOutlet UIButton     *registerButton;    // 注册按钮
@property (weak,nonatomic) IBOutlet UIButton     *visitorButton;     // 游客按钮

@property (strong,nonatomic)        UserService  *userService;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 视图和样式
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if (CURRENT_VERSION>=7.0)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
//    [self.registerButton setTitleColor:[UIColor getColor:@"A81005"] forState:UIControlStateNormal];
//    [self.registerButton setTitleColor:[UIColor getColor:@"A81005"] forState:UIControlStateHighlighted];
    [self.visitorButton setTitleColor:[UIColor getColor:@"2D69AC"] forState:UIControlStateNormal];
    [self.visitorButton setTitleColor:[UIColor getColor:@"2D69AC"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];

    
    // 数据初始化
    self.userService = [[UserService alloc] init];
    
    // 操作初始化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if ([LoginManager shareInstance].loginAccountInfo.isAutoLogin) {
        // 自动登录
        [self autoLogin];
    }
    else{
        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ACCOUNT_PHONE];
    }
    
    if(UIScreenHeight == 480)
    {
        self.mainScrollView.contentOffset = CGPointMake(0, 64);
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 键盘事件

- (void)hiddenKeyboardTaped:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
}


/**
 *  当键盘出现或改变时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    int keyboardTopHeight = UIScreenHeight - keyboardHeight;
    
    // scrollview偏移
    CGRect oldFrame = self.pwdInputView.frame;
    if ( keyboardTopHeight < oldFrame.origin.y + oldFrame.size.height)
    {
        self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - keyboardTopHeight);
    }
    
    // scrollview扩充高度
    NSLayoutConstraint *bottomConstraint = [self.bottomButtonsView findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = keyboardHeight;
    [self.view layoutIfNeeded];
    
    
    UITapGestureRecognizer *keyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardTaped:)];
    [self.view addGestureRecognizer:keyboardTap];
    
}

/**
 *  当键盘退出时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    // 还原scrollview
    self.mainScrollView.contentOffset = CGPointMake(0,0);
    
    NSLayoutConstraint *bottomConstraint = [self.bottomButtonsView findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = 20;
    [self.view layoutIfNeeded];
    
}


#pragma  mark - Actions

/**
 *  忘记密码按钮点击事件
 *
 *  @param sender
 */
- (IBAction) forgetPwdButtonPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    
    ForgetPasswordViewController *forgetpwdController = [storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    forgetpwdController.title = @"忘记密码";
    [self.navigationController pushViewController:forgetpwdController animated:YES];
}

/**
 *  登录按钮点击事件
 *
 *  @param sender
 */
- (IBAction)loginButtonPressed:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];

    if (![self.phoneTextField.text isMatchedByRegex:MOBILE_REGULAR_EXPRESSION]) {
        // 未输入账号
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
        
        return;
    }

    if(![self.pwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION])
    {
        // 密码不对
        [SVProgressHUD showErrorWithStatus:@"密码是6-20位数字字母下划线"];

        return;
    }
    
    [self loginWithUserName:self.phoneTextField.text andMd5Password:[self.pwdTextField.text md5HexDigest]];
    
    [[LoginManager shareInstance] resetAccountInfo];
}

/**
 *  自动登录
 */
-(void)autoLogin
{
    self.phoneTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_ACCOUNT_PHONE];
    NSString *md5Pwd = [[NSUserDefaults standardUserDefaults]objectForKey:LOGIN_ACCOUNT_PASSWORD];

    self.pwdTextField.text = @"XXXXXX";  // 自动登录显示伪密码
    [self loginWithUserName:self.phoneTextField.text andMd5Password:md5Pwd];
    
}


/**
 *  登录请求
 *
 *  @param userName 账号
 *  @param password 加密密码
 */
- (void)loginWithUserName:(NSString *)userName andMd5Password:(NSString *)md5password
{
    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    //设备号
    NSString *imei=[[UIDevice currentDevice] myGlobalDeviceId];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400201:userName
                           imei:imei ? imei : @""
                            pwd:md5password
                            cId:[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ucid"]:nil
                           type:@"2"
                        version:curVersion
                        success:^(id responseObj)
     {
         LoginModel *loginModel = (LoginModel *)responseObj;
         
         if ([loginModel.retcode isEqual:@"000000"]) {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS  object:self];
             [LoginManager shareInstance].loginAccountInfo.isLogin = YES;
             
             if(![LoginManager shareInstance].loginAccountInfo.isAutoLogin)
             {
                 // 手动登录，更新保存的登录信息
                 [self updateAccountInfoWithLoginInfo:loginModel];

                 [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:self];
             }
             
             if (self.loginButtonBlock) {
                 self.loginButtonBlock();
             }
         }
         else{
             [SVProgressHUD showErrorWithStatus:loginModel.retinfo];
             if([LoginManager shareInstance].loginAccountInfo.isAutoLogin)
             {
                 // 自动登录失败后清空伪密码
                 self.pwdTextField.text = @"";
             }
         }
         
     }failure:^(NSError *error){
         [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后重试"];
         if([LoginManager shareInstance].loginAccountInfo.isAutoLogin)
         {
             // 自动登录失败后清空伪密码
             self.pwdTextField.text = @"";
         }
     }];

}

/**
 *  登录成功，更新账户信息
 */
- (void)updateAccountInfoWithLoginInfo:(LoginModel *)loginModel
{
    // 模拟登录成功，保存登录信
    [DES3Util tripleDESWithAppkey:loginModel.baseKey];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    accountInfo.uId = loginModel.uId;
    accountInfo.baseKey = loginModel.baseKey;
    accountInfo.username = self.phoneTextField.text;
    accountInfo.password = [self.pwdTextField.text md5HexDigest];
    accountInfo.nickName = loginModel.nickName;
    accountInfo.name = loginModel.name;
    accountInfo.image = loginModel.image;
    accountInfo.birth = loginModel.birth;
    accountInfo.sex = loginModel.sex;
    accountInfo.isLogin = YES;
    accountInfo.isAutoLogin = YES;
    
    [[LoginManager shareInstance] saveAccountInfo:accountInfo];
    
    // dw add V1.1
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEARCHPLOTS" object:nil];
    // dw end
}


/**
 *  注册点击事件
 *
 *  @param sender
 */
- (IBAction)registerButtonPressed:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    RegisterCheckHouseViewController *checkHouseController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterCheckHouseViewController"];
    checkHouseController.isRegister = YES;
    checkHouseController.title = @"注册";
    [self.navigationController pushViewController:checkHouseController animated:YES];
}

/**
 *  游客按钮事件
 *
 *  @param sender
 */
- (IBAction)visitorButtonPressed:(id)sender
{
    [[LoginManager shareInstance] resetAccountInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_OUT_NOTIFICATION object:self];
    // dw add 清除登录信息
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ucid"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"isSuper"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEARCHPLOTS" object:nil];
    // dw end
    
    
    if (self.loginButtonBlock) {
        self.loginButtonBlock();
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // 联系方式最长20位
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if(textField == self.phoneTextField)
    {
        // 手机号码最大11位
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        // dw add V1.1 更换账号 密码清空
        if (toBeString.length < 11) {
            self.pwdTextField.text = @"";
        }
        // dw end
    }
    
    if(textField == self.pwdTextField)
    {
        // 密码6-20位
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self loginButtonPressed:nil];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
