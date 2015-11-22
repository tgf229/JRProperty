//
//  FeedbackViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/29.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SettingService.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "UIDevice+IdentifierAddition.h"
#import "UIView+Additions.h"
#import "JRPropertyUntils.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (strong,nonatomic)  SettingService   *settingService;

@property (weak,nonatomic) IBOutlet UIScrollView       *mainScrollView;

@property (weak,nonatomic) IBOutlet UITextField        *contactTextField;
@property (weak,nonatomic) IBOutlet UILabel            *feedContentTipLabel;
@property (weak,nonatomic) IBOutlet UITextView         *feedContentTextView;
@property (weak,nonatomic) IBOutlet UILabel            *textNumberLabel;
@property (weak,nonatomic) IBOutlet UIButton           *submiButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_yijianfankui"]];

    // 数据初始化
    self.settingService = [[SettingService alloc] init];
    
    // 样式
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if (CURRENT_VERSION>=7.0)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.textNumberLabel.text = @"0/100";


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
    
    [self.contactTextField resignFirstResponder];
    [self.feedContentTextView resignFirstResponder];
    
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
    
    CGRect contentFrame = self.feedContentTextView.frame;
    if ( keyboardTopHeight < contentFrame.origin.y + contentFrame.size.height)
    {
        //self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - tempHeight);
    }
    
    // scrollview扩充高度
    NSLayoutConstraint *bottomConstraint = [self.submiButton findConstraintForAttribute:NSLayoutAttributeBottom];
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
    
    NSLayoutConstraint *bottomConstraint = [self.submiButton findConstraintForAttribute:NSLayoutAttributeBottom];
    bottomConstraint.constant = 20;
    [self.view layoutIfNeeded];
}


/**
 *  提交申请
 *
 *  @param sender
 */
- (IBAction)submitButtonPressed:(id)sender
{
    [self.contactTextField resignFirstResponder];
    [self.feedContentTextView resignFirstResponder];

    if (self.contactTextField.text.length > 20) {
        // 联系方式长度限制
        [SVProgressHUD showErrorWithStatus:@"联系方式不能超过20位"];
        
        return;
    }

    if (self.feedContentTextView.text.length <= 0) {
        // 请输入反馈内容
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    //设备号
    NSString *imei=[[UIDevice currentDevice] myGlobalDeviceId];
    
    NSString *contactStr = [self.contactTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *contentStr = [self.feedContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.settingService Bus500101:nil
                           version:curVersion
                              type:@"2"
                             model:[JRPropertyUntils deviceModelString]
                              imei:imei
                           contact:contactStr
                            remark:contentStr success:^(id responseObj)
    {
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            // 反馈成功
            [SVProgressHUD showSuccessWithStatus:@"您得反馈已发送，感谢您的支持"];
            
            //延迟返回上一级页面
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
        }
        else{
            [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"发送失败，请稍后重试"];
    }];

}

// 返回上一级
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 联系方式最长20位
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 20) {
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    
    return YES;
}


#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.feedContentTipLabel.text = @"请在此留下您得宝贵意见，让我们不断进步，感谢您的支持！";
    }else{
        self.feedContentTipLabel.text = @"";
    }
    
    [self.textNumberLabel setText:[NSString stringWithFormat:@"%u/100",textView.text.length > 100 ? 100:textView.text.length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([toBeString length] > 100) {
        textView.text = [toBeString substringToIndex:100];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
