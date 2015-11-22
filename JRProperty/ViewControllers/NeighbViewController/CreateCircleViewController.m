//
//  CreateCircleViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "CreateCircleViewController.h"
#import "SVProgressHUD.h"

#import "MemberService.h"

#import "JRDefine.h"
#import "LoginManager.h"

#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"

@interface CreateCircleViewController ()

@property (nonatomic,strong) MemberService  *memberService;
@property (nonatomic,assign) BOOL   hasPhoto;  //上传图片 （提交请求时用于判断有无图片）

@end

@implementation CreateCircleViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}


- (void)viewDidLoad {
    //title
    [super viewDidLoad];
    switch (self.manageType) {
        case kCreateCircle:
        {
            self.title = @"创建圈子";
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_chuangjianquanzi"]];
            self.navigationItem.titleView = iv;
            break;
        }
        case kEditCircle:
        {
            self.title = @"编辑";
            UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bianjiquanzi"]];
            self.navigationItem.titleView = iv;
            break;
        }
        default:
            break;
    }
    
    
    
    //初始化
    self.memberService = [[MemberService alloc]init];
    self.hasPhoto =NO;
    //标题栏右侧“确认”按钮
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
    
    self.scrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    //右侧箭头设置图片偏移
    [self.arrowButton  setImageEdgeInsets:UIEdgeInsetsMake(37, UIScreenWidth-31, 37, 15)];
    //scrollView加点击事件 键盘下降
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
    //输入框的一些属性设置
    self.nameTextField.delegate = self;
    self.nameTextField.textColor = [UIColor getColor:@"888888"];
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.descTextView.isScrollable = NO;
    self.descTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.descTextView.animateHeightChange = YES;
    self.descTextView.minNumberOfLines = 1;
    self.descTextView.maxNumberOfLines = 10;
    self.descTextView.returnKeyType = UIReturnKeyDefault;
    self.descTextView.font = [UIFont systemFontOfSize:15.0f];
    self.descTextView.delegate = self;
    self.descTextView.placeholder = @"最多200个字";
    self.descTextView.textColor = [UIColor getColor:@"888888"];
    self.descTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //如果是编辑页面  展示上页面传来的数据
    if (self.manageType == kEditCircle) {
        self.nameTextField.text = self.circleInfo.name;
        self.descTextView.text = self.circleInfo.desc;
        [self.iconImageView  sd_setImageWithURL:[NSURL URLWithString:self.circleInfo.icon] placeholderImage:[UIImage imageNamed:@"community_default"]];
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameTextViewDidChange:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
}

/**
 *  确认按钮 触发 提交数据发送请求
 *
 */
- (void) submit {
    [self.nameTextField resignFirstResponder];
    [self.descTextView resignFirstResponder];
   
    NSString * str = [self.descTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //名称不能为空 不能超过8位
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"名称不能为空！"];
    }
    else if (self.nameTextField.text.length > 8) {
        [SVProgressHUD showErrorWithStatus:@"名称不能超过8位！"];
    }
    //描述不能超过200字
    else if (str.length > 200) {
        [SVProgressHUD showErrorWithStatus:@"您输入的内容已超过200字"];
        return;
    }
    else {
        NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/circleIcon.png"];
        if (self.manageType == kCreateCircle) {
            //创建圈子 图片不能为空
            if (!self.hasPhoto) {
                 [SVProgressHUD showErrorWithStatus:@"请上传圈子头像！"];
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = NO;
                [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
                //创建圈子
                [self.memberService Bus301501:[LoginManager shareInstance].loginAccountInfo.uId cId:CID_FOR_REQUEST name:self.nameTextField.text desc:str file:fullPath success:^(id responseObject) {
                    BaseModel *baseModel = (BaseModel *)responseObject;
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    if ([baseModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                        [SVProgressHUD showSuccessWithStatus:@"创建成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:CREATE_CRICLE_SUCCESS  object:self];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
                    }
                } failure:^(NSError *error) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
                }];
            }
        }
        else if (self.manageType == kEditCircle) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
            //编辑圈子
            if (self.hasPhoto) {
                [self.memberService Bus301701:[LoginManager shareInstance].loginAccountInfo.uId sId:self.circleInfo.id name:self.nameTextField.text desc:self.descTextView.text logo:fullPath flag:@"1" success:^(id responseObject) {
                    BaseModel *baseModel = (BaseModel *)responseObject;
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    if ([baseModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                        [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_CRICLE_SUCCESS  object:self];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
                    }

                } failure:^(NSError *error) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
                }];
            }
            else {
                [self.memberService Bus301701:[LoginManager shareInstance].loginAccountInfo.uId sId:self.circleInfo.id name:self.nameTextField.text desc:self.descTextView.text logo:nil flag:@"0" success:^(id responseObject) {
                    BaseModel *baseModel = (BaseModel *)responseObject;
                    self.navigationItem.rightBarButtonItem.enabled = YES;

                    if ([baseModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                        [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_CRICLE_SUCCESS  object:self];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
                    }

                } failure:^(NSError *error) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;

                    [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
                }];

            }
           
        }
    }
}





#pragma  mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.descTextView becomeFirstResponder];
    return YES;
}
//限制名称输入最多8位
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([self.nameTextField.text length] > 9) {
//        self.nameTextField.text = [self.nameTextField.text substringToIndex:8];
//        return NO;
//    }else if ([self.nameTextField.text length] == 9){
//        self.nameTextField.text = [self.nameTextField.text substringToIndex:8];
//        return YES;
//    }
//    
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
            if (toBeString.length > 8) {
                textView.text = [toBeString substringToIndex:8];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 8) {
            textView.text = [toBeString substringToIndex:8];
        }
    }
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
    //设置输入view的高度约束改变
   self.contentViewHeighCon.constant=r.size.height;
    [self.view layoutIfNeeded];
    
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
    
    if ([self.descTextView.text length] > 200) {
        self.descTextView.text = [self.descTextView.text substringToIndex:199];
        return NO;
    }else if ([self.descTextView.text length] == 200){
        self.descTextView.text = [self.descTextView.text substringToIndex:199];
        return YES;
    }
    
    return YES;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
   return  [self.descTextView resignFirstResponder];
}

/**
 *  给scrollview加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [self.nameTextField resignFirstResponder];
    [self.descTextView resignFirstResponder];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  头像点击触发 
 *
 */
- (IBAction)clickIcon:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机拍摄",@"相册库", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheet Delegate
/**
 *  跳出相机或相册
 *
 *  @param actionSheet 下标
 *  @param buttonIndex 按钮下标
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        //先设定sourceType为相机，然后判断相机是否可用，不可用将sourceType设定为相片库
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 1){
        //相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - Camera View Delegate Methods
/**
 *  拍照完成或相册选择完成
 *
 *  @param picker 相机或相册
 *  @param info   照片
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.iconImageView.image = image;
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/circleIcon.png"];
    // 将图片写入文件
    [self scaleAndSaveImage:image andFilePath:fullPath];
}
/**
 *  在相机或相册 点了取消
 *
 *  @param picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

/**
 *  调整选择的照片质量，并写入临时目录下
 *
 *  @param image    选择的图片
 *  @param fullPath 写入的路径
 */
- (void)scaleAndSaveImage:(UIImage *)image andFilePath:(NSString *)fullPath
{
    //调整图片方向
    float quality = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, quality);
    
    
    if(imageData.length > 200 * 1024)
    {
        quality = 0.7;
        imageData = UIImageJPEGRepresentation(image, quality);
        
        
        while (imageData.length < 200 * 1024 && (quality < 1.0)) {
            quality += 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
        
        while (imageData.length > 200 * 1024 && (quality > 0.0)) {
            quality -= 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
    }
    
    

    [imageData writeToFile:fullPath atomically:NO];//写入到缓存目录
    self.hasPhoto = YES;
}



@end
