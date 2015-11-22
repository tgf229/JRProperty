//
//  ForgetPasswordViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "UserService.h"
#import "SVProgressHUD.h"

@interface ForgetPasswordViewController ()

@property (strong,nonatomic)  UserService *userService;
@property (weak,nonatomic)    IBOutlet UITextField  *phoneField;
@property (weak,nonatomic)    IBOutlet UITextField  *verifyCodeField;
@property (weak,nonatomic)    IBOutlet UIButton     *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wangjimima"]];

    self.userService = [[UserService alloc] init];
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.verifyCodeButton setBackgroundImage:[UIImage imageNamed:@"myhome_signin_textbtn_gaincode.png"] forState:UIControlStateNormal];
    [self.verifyCodeButton setBackgroundImage:[UIImage imageNamed:@"myhome_signin_textbtn_gaincode_press"] forState:UIControlStateHighlighted];
    [self.verifyCodeButton setBackgroundImage:[UIImage imageNamed:@"myhome_signin_textbtn_gaincode_press"] forState:UIControlStateSelected];
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.saveBtn setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *hiddenKeyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardTap)];
    [self.view addGestureRecognizer:hiddenKeyboardTap];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark - Actions
- (void)hiddenKeyboardTap
{
    [self.phoneField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
}


- (void)startTimerCountdown
{
    UILabel *timecountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.verifyCodeButton.frame.size.width,self.verifyCodeButton.frame.size.height)];
    timecountLabel.backgroundColor = [UIColor clearColor];
    timecountLabel.textAlignment = NSTextAlignmentCenter;
    timecountLabel.textColor = [UIColor getColor:@"ffffff"];
    timecountLabel.font = self.verifyCodeButton.titleLabel.font;
    [self.verifyCodeButton addSubview:timecountLabel];
    
    __block  int timeout = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                self.verifyCodeButton.enabled = YES;
                [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateHighlighted];
                
                [timecountLabel removeFromSuperview];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时进行
                self.verifyCodeButton.enabled = NO;
                [self.verifyCodeButton setTitle:@"" forState:UIControlStateNormal];

                timecountLabel.text = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
            });
            
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}


/**
 *  忘记密码获取验证码
 */
- (IBAction)getVerifyCodeButtonPressed
{
    [self.phoneField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
    if (self.phoneField.text.length < 11) {
        // 未输入手机号码
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400301:self.phoneField.text type:@"2" success:^(id response){
        // 获取验证码
        BaseModel *baseModel = (BaseModel *)response;
        if ([baseModel.retcode isEqualToString:@"000000"]) {
            // 获取成功
            [SVProgressHUD showSuccessWithStatus:baseModel.retinfo];
            
            [self startTimerCountdown];
        }
        else{
            // 获取失败
            [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
        }
    }failure:^(NSError *error){
        // 获取验证码失败
        [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请稍后重试"];
    }];
}


/**
 *  忘记密码，验证用户名
 *
 *  @param sender
 */
- (IBAction)sureButtonPressed:(id)sender
{
    [self.phoneField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
    if (self.phoneField.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
        return;
    }
    
    if (self.verifyCodeField.text.length < 4) {
        [SVProgressHUD showErrorWithStatus:@"请输入4位验证码"];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400801:self.phoneField.text
                        msgCode:self.verifyCodeField.text
                        success:^(id response)
    {
        // 获取验证码
        BaseModel *baseModel = (BaseModel *)response;
        if ([baseModel.retcode isEqualToString:@"000000"]) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
            
            ResetPasswordViewController *resetPwdController = [storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
            resetPwdController.isForgetPassword = YES;
            resetPwdController.title = @"忘记密码";
            resetPwdController.phoneNumber = self.phoneField.text;
            [self.navigationController pushViewController:resetPwdController animated:YES];
            
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
        }
    }failure:^(NSError *error){
        // 验证账号失败
        [SVProgressHUD showErrorWithStatus:@"校验账号失败，请稍后重试"];

    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField == self.phoneField)
    {
        // 手机号码最大11位
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    
    if(textField == self.verifyCodeField)
    {
        // 验证码6位
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
