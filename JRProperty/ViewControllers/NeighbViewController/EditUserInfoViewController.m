//
//  EditUserInfoViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-30.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "SVProgressHUD.h"
#import "LoginManager.h"
#import "UserService.h"
#import "BaseModel.h"

@interface EditUserInfoViewController ()

@property (strong ,nonatomic)  UserService  *userService;

@end

@implementation EditUserInfoViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}


- (void)viewDidLoad {
    self.title = @"个人设置";
    [super viewDidLoad];
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_gerenshezhi"]];
    self.navigationItem.titleView = iv;
    [self.view setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    self.userService = [[UserService alloc]init];
    //IOS6上位置偏移
    if (CURRENT_VERSION<7) {
        self.topContraint.constant = 16;
    }
    
    self.inputView.isScrollable = NO;
    self.inputView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.inputView.animateHeightChange = YES;
    self.inputView.minNumberOfLines = 1;
    self.inputView.maxNumberOfLines = 4;
    self.inputView.returnKeyType = UIReturnKeyDefault;
    self.inputView.font = [UIFont systemFontOfSize:15.0f];
    self.inputView.delegate = self;
    self.inputView.placeholder = @"最多20个字";
    self.inputView.textColor = [UIColor getColor:@"666666"];
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.nameTextField.textColor = [UIColor getColor:@"666666"];
    self.nameTextField.delegate = self;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.text = self.nickName;
    self.inputView.text = self.desc;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTextViewDidChange:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    //点击其他区域 键盘下降
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //右上角 确认 按钮
    [self createRightButton];
}

/**
 *  右上角 确认 按钮
 */
- (void)createRightButton {
    //标题栏右侧按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [saveButton setFrame:CGRectMake(0, 0, 54, 28)];
    
    [saveButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
    [saveButton setTitle:@"确认" forState:UIControlStateNormal];
    [saveButton setTitle:@"确认" forState:UIControlStateHighlighted];
    [saveButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [saveButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate Method
/**
 *  改变textview的高度
 *
 *  @param growingTextView textview
 *  @param height          改变的高度
 */
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.contentView.frame;
    
    r.size.height -= diff;
   // r.origin.y += diff;
    self.heihtCon.constant=r.size.height;
    [self.view layoutIfNeeded];
    
}

/**
 *  给 view加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [self.inputView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

/**
 *  控制textview输入长度
 *
 *  @param textView textview
 *  @param range    range
 *  @param text     text
 *
 *  @return  是否可输入
 */
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([self.inputView.text length] > 20) {
        self.inputView.text = [self.inputView.text substringToIndex:19];
        return NO;
    }else if ([self.inputView.text length] == 20){
        self.inputView.text = [self.inputView.text substringToIndex:19];
        return YES;
    }
    
    return YES;
}


#pragma  mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   [self.inputView becomeFirstResponder];
    return YES;
}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([self.nameTextField.text length] > 7) {
//        self.nameTextField.text = [self.nameTextField.text substringToIndex:6];
//        return NO;
//    }else if ([self.nameTextField.text length] == 7){
//        self.nameTextField.text = [self.nameTextField.text substringToIndex:6];
//        return YES;
//    }
//    return YES;
//}
/**
 *  输入框文本变化通知
 *
 *  @param notification
 */
- (void)nameTextViewDidChange:(NSNotification *)notification{
    UITextField *textView = (UITextField *)notification.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 7) {
                textView.text = [toBeString substringToIndex:7];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 7) {
            textView.text = [toBeString substringToIndex:7];
        }
    }
}

/**
 *  右上角 确认 按钮触发事件 提交请求
 */
- (void)submit {
    [self.nameTextField resignFirstResponder];
    [self.inputView resignFirstResponder];
     NSString * descStr = [self.inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.nameTextField.text.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空！"];
    }
    else if (descStr.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"您输入的签名已超过20字"];
        return;
    }
    else {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        [self.userService Bus400601:[LoginManager shareInstance].loginAccountInfo.uId nickName:self.nameTextField.text desc:descStr name:nil sex:nil birth:nil flag:@"1" success:^(id responseObject) {
            BaseModel *baseModel = (BaseModel *)responseObject;
            if ([baseModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                [SVProgressHUD  showSuccessWithStatus:@"个人信息设置成功"];
                [LoginManager shareInstance].loginAccountInfo.nickName = self.nameTextField.text;
                [[LoginManager shareInstance] saveAccountInfo:[LoginManager shareInstance].loginAccountInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_USERINFO_SUCCESS  object:self];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else  {
                [SVProgressHUD  showErrorWithStatus:baseModel.retinfo];

            }
        } failure:^(NSError *error) {
            [SVProgressHUD  showErrorWithStatus:OTHER_ERROR_MESSAGE];

        }];
    }
}


@end
