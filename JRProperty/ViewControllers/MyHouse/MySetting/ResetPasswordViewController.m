//
//  ResetPasswordViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UserService.h"
#import "NSString+MD5HexDigest.h"
#import "LoginViewController.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "UIView+Additions.h"
#import "RegexKitLite.h"

@interface ResetPasswordViewController ()

@property (weak,nonatomic) IBOutlet UIScrollView        *mainScrollView;
@property (weak,nonatomic) IBOutlet UIView             *inputOldPwdView;
@property (weak,nonatomic) IBOutlet UITextField        *oldPwdTextField;
@property (weak,nonatomic) IBOutlet UITextField        *pwdTextField;
@property (weak,nonatomic) IBOutlet UITextField        *rePwdTextField;
@property (weak,nonatomic) IBOutlet UIButton           *saveButton;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *inputNewPwdTopConstraint;
@property (strong,nonatomic)        UserService        *userService;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    [self.saveButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];

    if (self.isForgetPassword) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wangjimima"]];
        // 忘记密码，只输入新密码和确认密码
        self.inputOldPwdView.hidden = YES;
        self.inputNewPwdTopConstraint.constant = 28;
        [self.view layoutIfNeeded];
    } else {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_xiugaimima"]];
    }
    
    self.userService = [[UserService alloc] init];
    
    // 操作
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma  mark - Actions
- (void)hiddenKeyboardTaped:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
    
    [self.oldPwdTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.rePwdTextField resignFirstResponder];
    
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
    
    CGRect contentFrame = self.rePwdTextField.frame;
    if ( keyboardTopHeight < contentFrame.origin.y + contentFrame.size.height)
    {
        //self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - tempHeight);
    }
    
    // scrollview扩充高度
    NSLayoutConstraint *bottomConstraint = [self.saveButton findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = keyboardHeight;
    [self.view layoutIfNeeded];
    
    // 增加动作响应
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
    //self.mainScrollView.contentOffset = CGPointMake(0,0);
    
    NSLayoutConstraint *bottomConstraint = [self.saveButton findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = 20;
    [self.view layoutIfNeeded];
}


#pragma mark - Actions

/**
 *  重设密码
 *
 *  @param sender
 */
- (IBAction)resetPasswordButtonPressed:(id)sender
{
    [self.oldPwdTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.rePwdTextField resignFirstResponder];

    if(!_isForgetPassword && ![self.oldPwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION])
    {
        // 旧密码不正确
        [SVProgressHUD showErrorWithStatus:@"旧密码是6-20位数字字母下划线"];
        
        return;
    }
    
    if(![self.pwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION])
    {
        // 请输入6-20位数字字母下划线
        [SVProgressHUD showErrorWithStatus:@"新密码必须是6-20位数字字母下划线"];

        return;
    }
    if(![self.rePwdTextField.text isEqualToString:self.pwdTextField.text])
    {
        // 确认密码不正确
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        return;
    }
    if(![self.rePwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION])
    {
        // 请输入6-20位数字字母下划线
        [SVProgressHUD showErrorWithStatus:@"新密码必须是6-20位数字字母下划线"];
        
        return;
    }

    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    if(_isForgetPassword)
    {
        // 忘记密码重设密码
        [self.userService Bus400901:self.phoneNumber
                                pwd:[self.pwdTextField.text md5HexDigest]
                            success:^(id responseObj)
         {
             BaseModel *baseModel = (BaseModel *)responseObj;
             
             if ([baseModel.retcode isEqualToString:@"000000"]) {
                 // 返回登录页面
                 UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:0];
                 if ([viewController isKindOfClass:[LoginViewController class]]) {
                     LoginViewController *loginViewController = (LoginViewController *)viewController;
                     [self.navigationController popToViewController:loginViewController animated:YES];
                     [loginViewController loginButtonPressed:nil];
                 }
             }
             else{
                 [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
             }
             
         }
        failure:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"保存密码失败，请稍后重试"];
        }];

    }
    else{
        // 密码管理－修改密码
        [self.userService Bus400701:[LoginManager shareInstance].loginAccountInfo.uId
                             oldPwd:[self.oldPwdTextField.text md5HexDigest]
                                pwd:[self.pwdTextField.text md5HexDigest]
                            success:^(id responseObj)
         
         {
             BaseModel *baseModel = (BaseModel *)responseObj;
             
             if ([baseModel.retcode isEqualToString:@"000000"]) {
                 // 密码修改成功，返回上一级
                 [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
                 
                 //延迟返回上一级页面
                 [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popToLoginViewController) userInfo:nil repeats:NO];
             }
             else{
                 // 修改失败
                 [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
             }
             
         }
         failure:^(NSError *error){
            // 修改失败
            [SVProgressHUD showErrorWithStatus:@"保存密码失败，请稍后重试"];
        }];
    }
}

- (void)popToLoginViewController
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // 密码最大20位
    if (toBeString.length > 20) {
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
