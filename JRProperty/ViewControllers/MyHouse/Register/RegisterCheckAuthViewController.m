//
//  RegisterCheckAuthViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "RegisterCheckAuthViewController.h"
#import "RegisterUserInfoViewController.h"
#import "MemberCenterViewController.h"
#import "HouseService.h"
#import "UserService.h"
#import "BuildingListModel.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "MartinCustomLabel.h"
#import "AFFNumericKeyboard.h"
#import "UIView+Additions.h"

@interface RegisterCheckAuthViewController ()<UITextFieldDelegate,AFFNumericKeyboardDelegate>
{
    BOOL          _isProprietor;  // 是否是业主
    NSUInteger    _textFieldTag;  // 标记激活的textfield
}

@property (weak,nonatomic) IBOutlet  UIScrollView      *mainScrollView;
@property (weak,nonatomic) IBOutlet  UIView            *headerGuideView;   // 步骤指示图
@property (weak,nonatomic) IBOutlet  UIButton          *tenementButton;    // 住户
@property (weak,nonatomic) IBOutlet  UIButton          *proprietorButton;  // 业主

@property (weak,nonatomic) IBOutlet  UIView            *idNumberView;    // 验证码视图
@property (weak,nonatomic) IBOutlet  UIButton          *idPreNumbersButton;     // 身份证前几位
@property (weak,nonatomic) IBOutlet  MartinCustomLabel *idNumberLabel;     // 身份证后6位
@property (weak,nonatomic) IBOutlet  UITextField       *idResignField;     // 身份证激活field

@property (weak,nonatomic) IBOutlet  UILabel           *phoneLabel;        // 手机号码提示
@property (weak,nonatomic) IBOutlet  UILabel           *verifyTipLabel;    // 验证码视图
@property (weak,nonatomic) IBOutlet  UIView            *verifyCodeView;    // 验证码视图
@property (weak,nonatomic) IBOutlet  UITextField       *verifyCodeField;   // 验证码
@property (weak,nonatomic) IBOutlet  UIButton          *verifyCodeButton;  // 获取验证码按钮
@property (weak,nonatomic) IBOutlet  UIButton          *okButton;          // 按钮：注册下一步或者绑定确定


@property (weak,nonatomic) IBOutlet  NSLayoutConstraint *selectTipTopConstraint;   //选择身份的提示语top约束
@property (weak,nonatomic) IBOutlet  NSLayoutConstraint *nextButtonTopConstraint;  //下一步top约束

@property (strong,nonatomic) HouseService               *houseService;
@property (strong,nonatomic) UserService                *userService;


@end

@implementation RegisterCheckAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"zhuce2_btnred_yanzhengma_22x22"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [self.verifyCodeButton setBackgroundImage:[[UIImage imageNamed:@"zhuce2_btnred_yanzhengma_22x22_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateHighlighted];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.okButton setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    // 数据初始化
    self.houseService = [[HouseService alloc] init];
    self.userService = [[UserService alloc] init];
    
    [self.idPreNumbersButton setTitle:self.houseModel.idCard forState:UIControlStateNormal];
    
    if (self.houseModel.phone.length == 0) {
        self.phoneLabel.text = @"业主手机号";
    }
    else{
        NSRange phoneRange;
        phoneRange.location = 4;
        phoneRange.length = 5;
        self.phoneLabel.text = [NSString stringWithFormat:@"业主手机号 %@",[self.houseModel.phone stringByReplacingCharactersInRange:phoneRange withString:@"****"]];  // 手机号码5-9位星号代替
    }
    
    // 样式及布局初始化
    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.verifyTipLabel.hidden = YES;
    self.verifyCodeView.hidden = YES;
    
    self.nextButtonTopConstraint.constant = -150;
    if(!self.isRegister)
    {
        // 绑定操作
        self.selectTipTopConstraint.constant = -50;
        self.headerGuideView.hidden = YES;
        [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    [self.view layoutIfNeeded];
    
    self.idResignField.tag = 1000;
    self.verifyCodeField.tag = 1001;
    
    AFFNumericKeyboard *keyboard = [[AFFNumericKeyboard alloc] initWithFrame:CGRectMake(0, 200, UIScreenWidth, 216)];
    self.idResignField.inputView = keyboard;
    keyboard.delegate = self;

    
    // 增加动作响应
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

#pragma mark - 键盘事件
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
    CGRect textFieldFrame;
    if (_textFieldTag == 1000) {
        // 激活身份证号码
       textFieldFrame = self.idNumberView.frame;
       textFieldFrame.size.height += 28; // 去掉底部提示语距离
    }
    else if(_textFieldTag == 1001)
    {
        textFieldFrame = self.verifyCodeView.frame;
        textFieldFrame.size.height += 28; // 去掉底部提示语距离
    }
    
    if ( keyboardTopHeight < textFieldFrame.origin.y + textFieldFrame.size.height)
    {
       self.mainScrollView.contentOffset = CGPointMake(0, textFieldFrame.origin.y + textFieldFrame.size.height - keyboardTopHeight);
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


#pragma  mark - Actions
- (IBAction)resignIDInputTextField:(id)sender
{
    [self.idResignField becomeFirstResponder];
}

- (void)hiddenKeyboardTaped:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
    
    [self.idResignField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
}

- (IBAction)authButtonSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == self.tenementButton && _isProprietor) {
        // 选择身份为住户
        _isProprietor = !_isProprietor;
        [self.tenementButton setImage:[UIImage imageNamed:@"myhome_signin_checkbox_selecton"] forState:UIControlStateNormal];
        [self.proprietorButton setImage:[UIImage imageNamed:@"myhome_signin_checkbox_selectno"] forState:UIControlStateNormal];
        
        self.verifyTipLabel.hidden = YES;
        self.verifyCodeView.hidden = YES;
        
        self.nextButtonTopConstraint.constant = -150;
        [self.view layoutIfNeeded];

    }
    else if (button == self.proprietorButton && !_isProprietor)
    {
        // 选择为业主
        _isProprietor = !_isProprietor;
        [self.tenementButton setImage:[UIImage imageNamed:@"myhome_signin_checkbox_selectno"] forState:UIControlStateNormal];
        [self.proprietorButton setImage:[UIImage imageNamed:@"myhome_signin_checkbox_selecton"] forState:UIControlStateNormal];
        
        self.verifyTipLabel.hidden = NO;
        self.verifyCodeView.hidden = NO;
        self.nextButtonTopConstraint.constant = 20;
        
        [self.view layoutIfNeeded];
    }
}

/**
 *  绑定房屋获取验证码
 */
- (IBAction)getVerifyCodeButtonPressed
{
    [self.idResignField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
    [self.userService Bus400301:self.houseModel.phone type:@"3" success:^(id response){
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
 *  下一步，填写联系人信息
 */
- (IBAction)pushToUserInfoViewController
{
    [self.idResignField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];

    if (self.idNumberLabel.text.length < 6) {
        // 未输入身份证号码后6位
        [SVProgressHUD showErrorWithStatus:@"请输入户主身份证号码后6位"];
        return;
    }
    
    if (_isProprietor && self.verifyCodeField.text.length < 4) {
        
        // 未输入校验码
        [SVProgressHUD showErrorWithStatus:@"请输入4位校验码"];
        return;
    }
    
    [self.idResignField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
//    RegisterUserInfoViewController *userinfoController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterUserInfoViewController"];
//    userinfoController.title = @"注册";
//    userinfoController.houseModel = self.houseModel;
//    userinfoController.isProprietor = _isProprietor;
//    [self.navigationController pushViewController:userinfoController animated:YES];
//
//    return;
    
    if (self.isRegister) {
        // 注册，校验是否可绑定
        
        [self.houseService Bus401101:nil   // uid为空
                                 hId:self.houseModel.hId
                                type:_isProprietor ? @"1":@"2"
                              idCard:self.idNumberLabel.text
                               phone:_isProprietor ? self.houseModel.phone:nil
                             msgCode:_isProprietor ? self.verifyCodeField.text:nil
                             success:^(id response)
        {
            BaseModel *responseModel = (BaseModel *)response;
            if ([responseModel.retcode isEqualToString:@"000000"]) {
                // 可绑定，进入下一步填写注册信息
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
                
                RegisterUserInfoViewController *userinfoController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterUserInfoViewController"];
                userinfoController.title = @"注册";
                userinfoController.houseModel = self.houseModel;
                userinfoController.isProprietor = _isProprietor;
                userinfoController.selCID = self.selectCID;
                [self.navigationController pushViewController:userinfoController animated:YES];
            }
            else{
                // 其他错误信息
                [SVProgressHUD showErrorWithStatus:responseModel.retinfo];
            }
            
        }failure:^(NSError *error){
            // 失败
            [SVProgressHUD showErrorWithStatus:@"验证房屋信息失败，请稍后重试"];
        }];
    }
    else{
        //  添加房屋，绑定
        
        [self.houseService Bus401101:[LoginManager shareInstance].loginAccountInfo.uId
                                 hId:self.houseModel.hId
                                type:_isProprietor ? @"1":@"2"
                              idCard:self.idNumberLabel.text
                               phone:_isProprietor ? self.houseModel.phone:nil
                             msgCode:_isProprietor ? self.verifyCodeField.text:nil
                             success:^(id response)
        {
            BaseModel *responseModel = (BaseModel *)response;
            if ([responseModel.retcode isEqualToString:@"000000"]) {
                // 绑定成功，返回我的家
                // dw add V1.1
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SEARCHPLOTS" object:nil];
                // dw end
                if([self.navigationController.viewControllers count] > 2)
                {
                    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:0];
                    if ([viewController isKindOfClass:[MemberCenterViewController class]]) {
                        MemberCenterViewController *memberController = (MemberCenterViewController *)viewController;
                        [memberController refreshUserHouseInfo];
                        [self.navigationController popToViewController:memberController animated:YES];
                    }
                }
            }
            else{
                // 其他错误信息
                [SVProgressHUD showErrorWithStatus:responseModel.retinfo];
            }
        }failure:^(NSError *error){
            // 失败
            [SVProgressHUD showErrorWithStatus:@"绑定房屋信息，请稍后重试"];
        }];
        
    }
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
    _textFieldTag = textField.tag;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 验证码最大6位
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 6) {
        textField.text = [toBeString substringToIndex:6];
        return NO;
    }

    return YES;
}


#pragma mark - AFFNumericKeyboardDelegate
/**
 *  输入数字
 *
 *  @param number 数字
 */
-(void)numberKeyboardInput:(NSInteger)number
{
    if (self.idNumberLabel.text.length == 6)
    {
        return;
    }
    // 身份证输入的号码显示在label上
    self.idNumberLabel.characterSpacing = 21;
    self.idNumberLabel.topSpacing = 12;
    self.idNumberLabel.text = [self.idNumberLabel.text stringByAppendingString:[NSString stringWithFormat:@"%d",number]];
}

/**
 *  输入x
 */
-(void)xButtonPressed
{
    if (self.idNumberLabel.text.length == 6)
    {
        return;
    }

    // 身份证输入的号码显示在label上
    self.idNumberLabel.characterSpacing = 21;
    self.idNumberLabel.topSpacing = 12;
    self.idNumberLabel.text = [self.idNumberLabel.text stringByAppendingString:@"X"];
}

/**
 *  回退
 */
-(void)numberKeyboardBackspace
{
    if (self.idNumberLabel.text.length != 0)
    {
        // 身份证输入的号码显示在label上
        self.idNumberLabel.characterSpacing = 21;
        self.idNumberLabel.topSpacing = 12;
        self.idNumberLabel.text = [self.idNumberLabel.text substringToIndex:self.idNumberLabel.text.length -1];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
