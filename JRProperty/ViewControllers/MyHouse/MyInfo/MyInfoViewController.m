//
//  MyInfoViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyInfoViewController.h"
#import "JRDefine.h"
#import "UIAlertView+AFNetworking.h"
#import "UserService.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "LoginManager.h"
#import "MemberCenterViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "JRPropertyUntils.h"
#import "UIView+Additions.h"

@interface MyInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSArray *_sexArray;
    BOOL     _isPortraitChanged;  // 是否更改头像
    BOOL     _isSavedPortrait;    // 头像是否更改成功

}

@property (weak,nonatomic) IBOutlet UIScrollView   *mainScrollView;
@property (weak,nonatomic) IBOutlet UIView         *portraitView;        // 头像视图
@property (weak,nonatomic) IBOutlet UIImageView    *portraitImgView;     // 头像
@property (weak,nonatomic) IBOutlet UITextField    *nickTextField;
@property (weak,nonatomic) IBOutlet UITextField    *nameTextField;

@property (weak,nonatomic) IBOutlet UIView         *birthdayView;          // 出生日期视图
@property (weak,nonatomic) IBOutlet UIView         *sexView;               // 性别视图

@property (weak,nonatomic) IBOutlet UILabel         *birthdayLabel;        // 出生日期
@property (weak,nonatomic) IBOutlet UILabel         *sexLabel;             // 性别

@property (strong,nonatomic)        UserService    *userService;
@property (strong,nonatomic)        UserInfoModel  *userinfoModel;       // 个人信息

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_gerenxinxi"]];
    // 初始化样式和布局
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.portraitImgView.layer.masksToBounds = YES;
    self.portraitImgView.layer.cornerRadius = 40;
    self.nameTextField.textColor = [UIColor getColor:@"676767"];
    self.nickTextField.textColor = [UIColor getColor:@"676767"];
    self.birthdayLabel.textColor = [UIColor getColor:@"676767"];
    self.sexLabel.textColor = [UIColor getColor:@"676767"];
    
    [self setRightBarButtonItem];

    //  初始化数据
    self.userService = [[UserService alloc] init];
    self.userinfoModel = [[UserInfoModel alloc] init];
    
    [self refreshUseInfoView];
    
    // 初始化操作
    UITapGestureRecognizer *portraitTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(portraitViewTapped:)];
    [self.portraitView addGestureRecognizer:portraitTap];
    
    UITapGestureRecognizer *birthdayTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(birthdayViewTapped:)];
    [self.birthdayView addGestureRecognizer:birthdayTap];
    
    UITapGestureRecognizer *sexTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexViewTapped:)];
    [self.sexView addGestureRecognizer:sexTap];
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTextField];
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


- (void)refreshUseInfoView
{
    // 本地缓存数据
    self.userinfoModel.uId = [LoginManager shareInstance].loginAccountInfo.uId;
    self.userinfoModel.image = [LoginManager shareInstance].loginAccountInfo.image;
    self.userinfoModel.username = [LoginManager shareInstance].loginAccountInfo.username;
    self.userinfoModel.nickName = [LoginManager shareInstance].loginAccountInfo.nickName;
    self.userinfoModel.name = [LoginManager shareInstance].loginAccountInfo.name;
    self.userinfoModel.sex = [LoginManager shareInstance].loginAccountInfo.sex;
    self.userinfoModel.birth = [LoginManager shareInstance].loginAccountInfo.birth;
    
    // 个人信息展示
    [JRPropertyUntils refreshUserPortraitInView:self.portraitImgView];    // 头像
    self.nickTextField.text = self.userinfoModel.nickName;
    self.nameTextField.text = self.userinfoModel.name;

    _sexArray = [NSArray arrayWithObjects:@"保密",@"男",@"女",nil];
    NSString *infoSex = [LoginManager shareInstance].loginAccountInfo.sex;
    self.sexLabel.text =  infoSex ? [_sexArray objectAtIndex:infoSex.integerValue] : @"保密";
    
   // NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   // NSString *currentDataStr = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthday = [formatter dateFromString:[LoginManager shareInstance].loginAccountInfo.birth];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDataStr = @"";
    self.birthdayLabel.text = birthday ? [formatter stringFromDate:birthday] : currentDataStr;
}

#pragma  mark - NSNotification
- (void)hiddenKeyboardTaped:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
    
    [self.nickTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
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
    CGRect oldFrame = self.nameTextField.frame;
    int keyboardTopHeight = UIScreenHeight - keyboardHeight;
    if ( keyboardTopHeight < oldFrame.origin.y + oldFrame.size.height)
    {
        //self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - keyboardTopHeight);
    }
    
    // scrollview扩充高度
    NSLayoutConstraint *bottomConstraint = [self.sexView findConstraintForAttribute:NSLayoutAttributeBottom];
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
    
    NSLayoutConstraint *bottomConstraint = [self.sexView findConstraintForAttribute:NSLayoutAttributeBottom];
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
 *  设置导航栏右键
 */
- (void)setRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 32 + 22, 20)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 32, 20)];
    }
    //[editButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
//    [editButton setTitle:@"完成" forState:UIControlStateNormal];
//    [editButton setTitle:@"完成" forState:UIControlStateHighlighted];
    [editButton setImage:[UIImage imageNamed:@"title_red_wancheng"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"title_red_wancheng"] forState:UIControlStateHighlighted];
//    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
//    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)click_popViewController
{
    // 检查个人信息是否修改
    if ([self isUserInfoChanged] || _isPortraitChanged)
    {
        // 个人信息已修改，提示是否保存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"个人信息"
                                                            message:@"个人信息已修改，是否保存"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"保存", nil];
        [alertView show];
        
    }
    else
    {
        [self removeTempPortriatImage];
        [super click_popViewController];
    }
}

/**
 *  保存个人信息
 */
- (void)saveUserInfo
{
    [self.nickTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    NSString *nickStr = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nickStr.length == 0) {
        // 昵称不能为空
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空"];
        return;
    }

    if ([self isUserInfoChanged])
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        NSString *nameStr = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 保存用户信息
        [self.userService Bus400601:[LoginManager shareInstance].loginAccountInfo.uId
                           nickName:nickStr
                               desc:nil
                               name:nameStr
                                sex:self.userinfoModel.sex
                              birth:self.userinfoModel.birth
                               flag:@"0"
                            success:^(id responseOjb)
         {
             BaseModel *resultModel = (BaseModel *)responseOjb;
             if ([resultModel.retcode isEqualToString:@"000000"]) {
                 
                 //更新账户信息
                 [LoginManager shareInstance].loginAccountInfo.nickName = self.nickTextField.text;
                 [LoginManager shareInstance].loginAccountInfo.name = self.nameTextField.text;
                 [LoginManager shareInstance].loginAccountInfo.sex = self.userinfoModel.sex;
                 [LoginManager shareInstance].loginAccountInfo.birth = self.userinfoModel.birth;
                 [[LoginManager shareInstance] saveAccountInfo:[LoginManager shareInstance].loginAccountInfo];

                 // 保存成功
                 if (_isPortraitChanged) {
                     // 上传头像
                     [self uploadUserPortrait];
                 }
                 else{
                     [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                     
                     //延迟返回上一级页面
                     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
                  }
             }
             else{
                 [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
             }
             
         }failure:^(NSError *error){
             // 保存失败
             [SVProgressHUD showErrorWithStatus:@"保存失败，请稍后重试"];
         }];
    }
    else if (_isPortraitChanged)
    {
        // 个人信息未改动只修改头像
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self uploadUserPortrait];
    }
    else{
        // 都未改动，直接返回
        [self.navigationController popViewControllerAnimated:YES];
    }

}

/**
 *  上传头像
 */
- (void)uploadUserPortrait
{
    // 上传用户头像
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPhoto.png"];

    [self.userService Bus400501:[LoginManager shareInstance].loginAccountInfo.uId file:tempPath success:^(id responseObj){
        BaseModel *resultModel = (BaseModel *)responseObj;
        if ([resultModel.retcode isEqualToString:@"000000"]) {
            _isSavedPortrait = YES;
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            
            // 更新本地头像
            [JRPropertyUntils updateUserPortraitImageWithFilePath:tempPath];
            
            //延迟返回上一级页面
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
        }
        else{
            [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
        }
        
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"头像上传失败，请稍后重试"];
    }];
}

/**
 *  返回上一级
 */
- (void)popViewController
{
    [self removeTempPortriatImage];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  检查个人信息是否修改
 *
 *  @return
 */
- (BOOL)isUserInfoChanged
{
    NSString *nickStr = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![nickStr isEqualToString:self.userinfoModel.nickName])
    {
        return YES;
    }
    
    NSString *nameStr = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((self.userinfoModel.name != nil && ![nameStr isEqualToString:self.userinfoModel.name])
        || (self.userinfoModel.name == nil && nameStr.length > 0))
    {
        return YES;
    }
    
    if (([LoginManager shareInstance].loginAccountInfo.birth == nil && self.userinfoModel.birth != nil)
        || ([LoginManager shareInstance].loginAccountInfo.birth && ![[LoginManager shareInstance].loginAccountInfo.birth isEqualToString:self.userinfoModel.birth]))
    {
        return YES;
    }
    
    if (([LoginManager shareInstance].loginAccountInfo.sex == nil && self.userinfoModel.sex != nil)
        || ([LoginManager shareInstance].loginAccountInfo.sex && ![[LoginManager shareInstance].loginAccountInfo.sex isEqualToString:self.userinfoModel.sex]))
    {
        return YES;
    }

    return NO;
}

/**
 *  更改头像，调用系统相册
 *
 *  @param sender
 */
- (void)portraitViewTapped:(id)sender
{
    [self.nickTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机拍摄",@"相册库", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  选择出生日期
 *
 *  @param sender
 */
- (void)birthdayViewTapped:(id)sender
{
    [self.nickTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    NSDate *currentDate ;
    if (self.birthdayLabel.text.length == 0) {
        //如果日期label没有内容 选择器默认日期为当天日期
        currentDate = [NSDate date];
    }
    else {
        //如果日期label有内容 选择器默认日期为label日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        currentDate = [formatter dateFromString:self.birthdayLabel.text];
    }
    
    [ActionSheetDatePicker showPickerWithTitle:@""
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:currentDate
                                     doneBlock:^(ActionSheetDatePicker *picker,id selectedDate,id origin){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthdayLabel.text = [formatter stringFromDate:selectedDate];
        self.userinfoModel.birth = [self.birthdayLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    cancelBlock:^(ActionSheetDatePicker *picker){
        // 取消，不做其他操作
                                       
    }
    origin:self.view];
}

/**
 *  选择性别
 *
 *  @param sender
 */
- (void)sexViewTapped:(id)sender
{
    [self.nickTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];

    NSInteger currentIndex = [_sexArray indexOfObject:self.sexLabel.text];
    if (currentIndex < 0 || currentIndex > 2) {
        currentIndex = 0;
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"性别"
                                            rows:_sexArray
                                initialSelection:currentIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue){
                                           // 重新选择性别
                                           self.sexLabel.text = [_sexArray objectAtIndex:selectedIndex];
                                           self.userinfoModel.sex = [NSString stringWithFormat:@"%d",selectedIndex];

    }
                                     cancelBlock:^(ActionSheetStringPicker *picker){
                                           // 取消
    }
                                          origin:self.view];
}

#pragma mark - 图片管理

/**
 *  删除缓存目录下的头像文件
 */
- (void)removeTempPortriatImage
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *documentsFileManager = [NSFileManager defaultManager];
    NSError *err;
    [documentsFileManager removeItemAtPath:[path stringByAppendingPathComponent:@"tempPhoto.png"] error:&err];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


#pragma  mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        // 直接返回
        [super click_popViewController];
    }
    else
    {
        // 保存用户信息
        [self saveUserInfo];
    }
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.portraitImgView setImage:image];
    
    // 将图片写入文件
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPhoto.png"];
    [self scaleAndSaveImage:image andFilePath:fullPath];
    
    _isPortraitChanged = YES;
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
