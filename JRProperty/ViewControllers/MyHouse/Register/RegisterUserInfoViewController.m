//
//  RegisterUserInfoViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "RegisterUserInfoViewController.h"
#import "LoginViewController.h"
#import "UserService.h"
#import "BuildingListModel.h"
#import "NSString+MD5HexDigest.h"
#import "SVProgressHUD.h"
#import "UIView+Additions.h"
#import "RegexKitLite.h"

typedef enum : NSUInteger {
    PhoneFieldTag = 1000,
    VerifyFieldTag,
    NickFieldTag,
    PwdFieldTag,
    RepwdFieldTag
} TextFieldTag;

@interface RegisterUserInfoViewController ()<UITextFieldDelegate>
{
    TextFieldTag _resignTextFieldTag;  // 激活的textfieldtag
}

@property (weak,nonatomic) IBOutlet UIScrollView        *mainScrollView;
@property (weak,nonatomic) IBOutlet UITextField         *phoneTextField;
@property (weak,nonatomic) IBOutlet UITextField         *verifyTextField;
@property (weak,nonatomic) IBOutlet UITextField         *nickTextField;

@property (weak,nonatomic) IBOutlet UIView              *passwordView;
@property (weak,nonatomic) IBOutlet UITextField         *pwdTextField;
@property (weak,nonatomic) IBOutlet UITextField         *repwdTextField;

@property (weak,nonatomic) IBOutlet UIView              *verifyCodeView;
@property (weak,nonatomic) IBOutlet UIButton            *verifyCodeButton;  // 获取验证码按钮
@property (weak,nonatomic) IBOutlet NSLayoutConstraint  *nickViewTopConstraint;

@property (weak,nonatomic) IBOutlet UIButton            *okButton;          // 确定按钮

@property (strong,nonatomic)        UserService         *userService;

@end

@implementation RegisterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"zhuce2_btnred_yanzhengma_22x22"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"zhuce2_btnred_yanzhengma_22x22_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];

    self.phoneTextField.text = self.isProprietor ? self.houseModel.phone : @"";
    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    
    self.phoneTextField.tag = PhoneFieldTag;
    self.verifyTextField.tag = VerifyFieldTag;
    self.nickTextField.tag = NickFieldTag;
    self.pwdTextField.tag = PwdFieldTag;
    self.repwdTextField.tag = RepwdFieldTag;

    [self showVerifyCodeView:self.isProprietor ? NO : YES];
    
    self.userService = [[UserService alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 中文输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nickTextField];
    
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

#pragma  mark - NSNotification
- (void)hiddenKeyboardTaped:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
    
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.repwdTextField resignFirstResponder];
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
    
    // scrollview偏移
    CGRect oldFrame = self.passwordView.frame;
    int keyboardTopHeight = UIScreenHeight - keyboardHeight;
    if (_resignTextFieldTag >= NickFieldTag && ( keyboardTopHeight < oldFrame.origin.y + oldFrame.size.height))
    {
        self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - keyboardTopHeight+60);
    }
    
    // scrollview扩充高度
    NSLayoutConstraint *bottomConstraint = [self.okButton findConstraintForAttribute:NSLayoutAttributeBottom];
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
    self.mainScrollView.contentOffset = CGPointMake(0,0);
    
    NSLayoutConstraint *bottomConstraint = [self.okButton findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = 20;
    [self.view layoutIfNeeded];

}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 7) {
                textField.text = [toBeString substringToIndex:7];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 7) {
            textField.text = [toBeString substringToIndex:7];
        }
    }
}

#pragma  mark - Actions
/**
 *  显示验证码输入
 *
 *  @param flag 是否需要显示
 */
- (void)showVerifyCodeView:(BOOL)isShow
{
    if (isShow) {
        // 用户注册或者业主号码与预留号码不一致，显示获取验证码
        self.verifyCodeView.hidden = NO;
        
        self.nickViewTopConstraint.constant = 20;
        [self.view layoutIfNeeded];
    }
    else{
        // 业主预留号码不需要再次获取验证码
        self.verifyCodeView.hidden = YES;
        
        self.nickViewTopConstraint.constant = -20;
        [self.view layoutIfNeeded];
    }
}

/**
 *  获取验证码
 */
- (IBAction)getVerifyCodeButtonPressed
{
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.repwdTextField resignFirstResponder];

    if (![self.phoneTextField.text isMatchedByRegex:MOBILE_REGULAR_EXPRESSION]) {
        
        // 未输入手机号码
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
        return;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400301:self.phoneTextField.text type:@"1" success:^(id response){
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
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
}

#pragma mark - Actions

- (IBAction)registerUserButtonPressed:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.repwdTextField resignFirstResponder];

    if (![self.phoneTextField.text isMatchedByRegex:MOBILE_REGULAR_EXPRESSION]) {
        
        // 未输入手机号码
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
        return;
    }
    if (!self.verifyCodeView.hidden && self.verifyTextField.text.length < 4) {
        
        // 校验码不对
        [SVProgressHUD showErrorWithStatus:@"请输入4位手机校验码"];
        return;
    }
    NSString *nickStr = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nickStr.length == 0) {
        
        // 未输入昵称
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    if (![self.pwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION]) {
        
        // 6-20位数字字母下划线
        [SVProgressHUD showErrorWithStatus:@"请输入6-20密码(数字字母下划线)"];
        return;
    }
    if (![self.pwdTextField.text isEqualToString:self.repwdTextField.text]) {
        
        // 密码不一致
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        return;
    }
    if (![self.repwdTextField.text isMatchedByRegex:PSW_REGULAR_EXPRESSION]) {
        
        // 6-20位数字字母下划线
        [SVProgressHUD showErrorWithStatus:@"请输入6-20密码(数字字母下划线)"];
        return;
    }

    
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion = @"";
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400101:self.phoneTextField.text
                       nickName:nickStr
                            msg:self.verifyTextField.text
                            pwd:[self.pwdTextField.text md5HexDigest]
                            hId:self.houseModel.hId
                           type:_isProprietor ? @"1":@"2"
                        version:curVersion ? curVersion : @""
                        success:^(id response)
    {
        BaseModel *resultModel = (BaseModel *)response;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            // dw add
            [[NSUserDefaults standardUserDefaults] setValue:self.selCID forKey:@"ucid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // dw end
            if([self.navigationController.viewControllers count] > 2)
            {
                UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:0];
                if ([viewController isKindOfClass:[LoginViewController class]]) {
                    LoginViewController *loginViewController = (LoginViewController *)viewController;
                    loginViewController.phoneTextField.text = self.phoneTextField.text;
                    [loginViewController loginWithUserName:self.phoneTextField.text andMd5Password:[self.pwdTextField.text md5HexDigest]];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:self.phoneTextField.text forKey:LOGIN_ACCOUNT_PHONE];
                    [self.navigationController popToViewController:loginViewController animated:YES];
                }
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"注册失败，请稍后重试"];
    }];
    


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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _resignTextFieldTag = textField.tag;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    switch (textField.tag) {
        case PhoneFieldTag:
        {
            if (toBeString.length > 11) {
                // 手机号码最大11位
                textField.text = [toBeString substringToIndex:11];
                return NO;
            }
            
            // 业主身份，使用预留号码，不展示验证码输入
            NSString *phoneString = [textField.text stringByAppendingFormat:@"%@",string];
            if (_isProprietor && [phoneString isEqualToString:self.houseModel.phone] && ![string isEqualToString:@""]) {
                [self showVerifyCodeView:NO];
            }
            else{
                [self showVerifyCodeView:YES];
            }
        }
            break;
        case VerifyFieldTag:
        {
            if (toBeString.length > 6) {
                // 验证码6位
                textField.text = [toBeString substringToIndex:6];
                return NO;
            }

        }
            break;
        case NickFieldTag:
        {
            // 交给通知处理
        }
            break;
        case PwdFieldTag:
        {
            if (toBeString.length > 20) {
                // 密码6-20数字字母下划线
                textField.text = [toBeString substringToIndex:20];
                return NO;
            }
        }
            break;
        case RepwdFieldTag:
        {
            // 密码6-20数字字母下划线
            if (toBeString.length > 20) {
                // 密码6-20数字字母下划线
                textField.text = [toBeString substringToIndex:20];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)userinfoViewTapped:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    [self.repwdTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
