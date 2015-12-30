//
//  PublicTopicViewController.m
//  JRProperty
//
//  Created by liugt on 14/12/2.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PublicTopicViewController.h"
#import <ImageIO/ImageIO.h>
#import "CTAssetsPickerController.h"
#import "JRDefine.h"
#import "SVProgressHUD.h"
#import "ImageButtonView.h"
#import "PhotosViewController.h"
#import "ArticleService.h"
#import "LoginManager.h"
#import "UIView+Additions.h"
#import "JRPropertyUntils.h"
#import "CommunityService.h"

#define IMAGE_BASE_TAG  200

@interface PublicTopicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CTAssetsPickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate,ImageButtonViewDelegate,PhotosViewDatasource>
{
    BOOL _isVoteSwitchOn;          // 是否允许投票
    BOOL _isVoteCustomSwitchOn;     //是否开启自定义投票
    BOOL _isScaleImagesFinished;   // 发帖选择的图片是否压缩存储完成
    NSInteger _pWidth;             // 图片宽度
}

@property (weak,nonatomic) IBOutlet UIScrollView       *mainScrollView;
@property (weak,nonatomic) IBOutlet UIView  *contentView;

@property (weak,nonatomic) IBOutlet UILabel            *contentTipLabel;    // 输入提示
@property (weak,nonatomic) IBOutlet UITextView         *contentTextView;    // 输入框
@property (weak,nonatomic) IBOutlet UILabel            *textNumberLabel;    // 输入字数
@property (weak,nonatomic) IBOutlet UIView             *addPicTipView;      // 添加照片的提示
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *addPicTipLeadingCon;// 提示的leading约束
@property (weak,nonatomic) IBOutlet UIView             *picturesView;       // 添加的照片
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *picturesViewHConstriat;  // 照片区域的高度约束

@property (weak,nonatomic) IBOutlet UIView             *voteView;           // 投票view
@property (weak,nonatomic) IBOutlet UIButton           *switchButton;       // 投票开关

@property (weak,nonatomic) IBOutlet UIView *voteCustomView;  //自定义投票view
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *voteCustomViewHeight;
@property (weak,nonatomic) IBOutlet UIButton *switchCustomButton;   //自定义投票开关
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *addVoteTopConstrait;
@property (weak,nonatomic) IBOutlet UIView *addVoteView;    //添加选项的view
@property (weak,nonatomic) IBOutlet UIButton *addVoteButton;    //添加选项的button

@property (nonatomic, strong) NSMutableArray *photoViewArray;               // 选择的图片按钮数组,包括一个添加按钮
@property (nonatomic, strong) NSMutableArray *photoFilePathArray;           // 选择的图片完整路径
@property (nonatomic, strong) UIButton       *addPicButton;                 // 添加照片的按钮
@property (nonatomic, strong) ArticleService *articleService;               //
@property (nonatomic, strong) CommunityService *communityService;

@property (nonatomic, strong) UITextField *textFieldShow;
@property (nonatomic ,strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSMutableArray *textFieldsText;

@property (nonatomic,assign) int index;
@property (assign,nonatomic) int height;
@end

@implementation PublicTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发话题";
    UIImageView * iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_fahuati"]];
    self.navigationItem.titleView = iv;
    self.photoViewArray = [[NSMutableArray alloc] init];
    self.photoFilePathArray = [[NSMutableArray alloc] init];
    self.articleService = [[ArticleService alloc] init];
    self.communityService = [[CommunityService alloc]init];
    self.textFields = [[NSMutableArray alloc]init];
    self.index = 0;
    
    // 进来后删除之前缓存的图片
    [self removeAllImageInCircleCache];
    
    [self createRightBarButtonItem];
    [self pictureViewAddImageButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:_contentTextView];
    
    //页面初始化
    [_addVoteButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [_addVoteButton setTitleColor:[UIColor getColor:@"e7a297"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    
    //初始化第一个自定义投票选项
    self.height = 0;
    [self addCustomItem];
    [_voteCustomView setHidden:YES];
    [_addVoteView setHidden:YES];
    
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.mainScrollView.contentSize = CGSizeMake(UIScreenWidth, 800);
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _pWidth = (UIScreenWidth - 50)/3;
    
    CGRect addButtonFrame = self.addPicButton.frame;
    addButtonFrame.size.width = _pWidth;
    addButtonFrame.size.height = _pWidth;
    self.addPicButton.frame = addButtonFrame;
    
    self.addPicTipLeadingCon.constant = _pWidth+32;
    
    if ([_photoViewArray count] > 3) {
        self.picturesViewHConstriat.constant = 30+_pWidth*2;
    }
    else{
        self.picturesViewHConstriat.constant = 20+_pWidth;
    }
    [self.view layoutIfNeeded];
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


/**
 *  重写导航栏返回按钮事件
 */
- (void)click_popViewController
{
    [super click_popViewController];
    
    [self removeAllImageInCircleCache];
}


/**
 *  标题栏右侧按钮
 */
- (void)createRightBarButtonItem {
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    if (CURRENT_VERSION < 7.0) {
        [postButton setFrame:CGRectMake(0, 0, 32+ 22, 24)];
    }
    else{
        [postButton setFrame:CGRectMake(0, 0,32, 20)];
    }
    [postButton setTitle:@"完成"  forState:UIControlStateNormal];
    [postButton setTitle:@"完成"  forState:UIControlStateHighlighted];
    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    [postButton addTarget:self action:@selector(publicNewTopic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  设置导航栏发表按钮可点击状态
 *
 *  @param isEnable 是否允许点击  yes：允许  no：不允许
 */
- (void)setRightPublicButtonEnable:(BOOL)isEnable
{
    UIButton *rightNavButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    rightNavButton.enabled = isEnable;
}


#pragma  mark - 键盘事件

- (void)hiddenKeyboardTaped:(id)sender
{
    [self.contentTextView resignFirstResponder];
    [self.textFieldShow resignFirstResponder];
    
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
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int keyboardHeight = keyboardRect.size.height;
//    
//    // scrollview偏移
//    CGRect oldFrame = self.contentTextView.frame;
//    int keyboardTopHeight = UIScreenHeight - keyboardHeight;
//    if ( keyboardTopHeight < oldFrame.origin.y + oldFrame.size.height)
//    {
//        self.mainScrollView.contentOffset = CGPointMake(0, oldFrame.origin.y + oldFrame.size.height - keyboardTopHeight);
//    }
//    
//    // scrollview扩充高度
//    NSLayoutConstraint *bottomConstraint = [self.voteView findConstraintForAttribute:NSLayoutAttributeBottom];
//    bottomConstraint.constant = keyboardHeight;
//    [self.view layoutIfNeeded];
//    
//    
    UITapGestureRecognizer *keyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardTaped:)];
    keyboardTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:keyboardTap];
    
}

/**
 *  当键盘退出时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
    // 还原scrollview
//    self.mainScrollView.contentOffset = CGPointMake(0,0);
//    
//    NSLayoutConstraint *bottomConstraint = [self.voteView findConstraintForAttribute:NSLayoutAttributeBottom];
//    bottomConstraint.constant = 0;
//    [self.view layoutIfNeeded];
}

/**
 *  输入框文本变化通知
 *
 *  @param notification
 */
- (void)textViewTextDidChange:(NSNotification *)notification{
    UITextView *textView = (UITextView *)notification.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 200) {
                textView.text = [toBeString substringToIndex:200];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 200) {
            textView.text = [toBeString substringToIndex:200];
        }
    }
    [_textNumberLabel setText:[NSString stringWithFormat:@"%ld/200",_contentTextView.text.length>200?200:_contentTextView.text.length]];
}

#pragma mark - Actions

/**
 *  添加图片按钮
 */
- (void)pictureViewAddImageButton
{
    // 添加默认的添加按钮
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageBtn.frame = CGRectMake(15, 0, 90, 90);
    addImageBtn.tag = IMAGE_BASE_TAG;
    addImageBtn.contentMode = UIViewContentModeScaleAspectFill;
    addImageBtn.userInteractionEnabled = YES;
    self.addPicButton = addImageBtn;
    [addImageBtn addTarget:self action:@selector(addPictureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"public_topic_add_pic.png"] forState:UIControlStateNormal];
    
    [self.picturesView addSubview:addImageBtn];
    [self.photoViewArray insertObject:addImageBtn atIndex:0];
}


/**
 *  发表新话题
 */
- (void)publicNewTopic
{
    [self.contentTextView resignFirstResponder];
    [self.textFieldShow resignFirstResponder];
    
    if (_isVoteCustomSwitchOn){
        BOOL hasData = NO;
        self.textFieldsText = [[NSMutableArray alloc]init];
        for (UITextField *text in self.textFields) {
            NSLog(@"%@",text.text);
            NSString *str = [text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![@"" isEqualToString:str]) {
                hasData = YES;
                [self.textFieldsText addObject:str];
            }
        }
        if (!hasData) {
            [SVProgressHUD showErrorWithStatus:@"请填写自定义投票选项的内容！"];
            return;
        }
    }

    NSString *contentStr = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([@"" isEqualToString:contentStr]||contentStr==nil) {
        // 请输入内容
        self.contentTextView.text = @"";
        [self.contentTextView resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"请输入话题内容！"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self setRightPublicButtonEnable:NO];
    });

    [self checkWriteImageStatusThenPublic];
}

/**
 *  检查大图写入本地是否完成
 */
- (void)checkWriteImageStatusThenPublic
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if([self isPostedImageWritedFinished]) {
            //大图压缩并存储完成后发送请求
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                //获取本地缓存的图片文件
                NSMutableArray *tempPhotoDataArray = [NSMutableArray array];
                for (NSString *filePath in _photoFilePathArray) {
                    NSData *tempData = [NSData dataWithContentsOfFile:filePath];
                    [tempPhotoDataArray addObject:tempData];
                }
                
                //发送请求
                NSString *contentStr = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSString *type;
                if (_isVoteSwitchOn) {
                    type = @"2";
                }else if (_isVoteCustomSwitchOn){
                    type = @"3";
                }else{
                    type = @"1";
                }
                NSArray *voteList = [[NSArray alloc]initWithArray:self.textFieldsText];
                [self.communityService Bus300702:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId content:contentStr flag:[_photoFilePathArray count]>0?@"1":@"0" file:_photoFilePathArray phoneType:@"2" model:[JRPropertyUntils deviceModelString] type:type voteList:voteList success:^(id responseObject)
                {
                    [self setRightPublicButtonEnable:YES];
                    BaseModel *resultModel = (BaseModel *)responseObject;
                    if ([resultModel.retcode isEqualToString:@"000000"])
                    {
                        // 成功
                        [SVProgressHUD showSuccessWithStatus:resultModel.retinfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:PUBLICE_ARTICLE_SUCCESS  object:self];
                        //延迟返回上一级页面
                        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
                    }
                    else{
                        // 失败
                        [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
                    }

                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"发表话题失败，请稍后重试"];
                    [self setRightPublicButtonEnable:YES];
                }];
            });
        }
        else{
            NSLog(@"社区-发帖子:等待图片压缩存入本地...");
            //每隔0.5秒检查一次
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.5),dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self checkWriteImageStatusThenPublic];
            });
            
        }
    });
}


- (void)popViewController
{
    [self removeAllImageInCircleCache];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  点击添加图片按钮，进入图片选择
 *
 *  @param sender
 */
- (void)addPictureButtonPressed:(id)sender
{
    //[self keyBoardHidden];
    [self.contentTextView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机拍摄",@"相册库", nil];
    actionSheet.tag = 101;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}


/**
 *  打开、关闭投票
 */
- (IBAction)swithButtonPressed:(id)sender
{
    _isVoteSwitchOn = !_isVoteSwitchOn;
    
    if (_isVoteSwitchOn) {
        if (_isVoteCustomSwitchOn) {
            _isVoteCustomSwitchOn = NO;
            [_voteCustomView setHidden:YES];
            [_addVoteView setHidden:YES];
            [self.switchCustomButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_off.png"] forState:UIControlStateNormal];
        }
        // 打开投票
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_on.png"] forState:UIControlStateNormal];
    }
    else{
        // 关闭投票
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_off.png"] forState:UIControlStateNormal];
    }

}

- (IBAction)swithButtonPressedCustom:(id)sender
{
    _isVoteCustomSwitchOn = !_isVoteCustomSwitchOn;
    
    if (_isVoteCustomSwitchOn) {
        //和AB投票互斥
        if (_isVoteSwitchOn) {
            _isVoteSwitchOn = NO;
            // 关闭投票
            [self.switchButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_off.png"] forState:UIControlStateNormal];
        }
        // 打开自定义投票
        _addVoteTopConstrait.constant = self.height + 54;
        [_voteCustomView setHidden:NO];
        [_addVoteView setHidden:NO];
        [self.switchCustomButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_on.png"] forState:UIControlStateNormal];
        
    }
    else{
        // 关闭自定义投票
        [_voteCustomView setHidden:YES];
        [_addVoteView setHidden:YES];
        [self.switchCustomButton setBackgroundImage:[UIImage imageNamed:@"myhome_set_btn_switch_off.png"] forState:UIControlStateNormal];
    }
}

-(void)addCustomItem{
    UIView *itemView = [[UIView alloc]init];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.frame = CGRectMake(0, 0+self.height, UIScreenWidth, 55);
    UIImageView *topImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, UIScreenWidth-30, 1)];
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 1, 44)];
    UIImageView *footImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 49, UIScreenWidth-30, 1)];
    UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(UIScreenWidth-15, 5, 1, 44)];
    topImg.image = [UIImage imageNamed:@"line_grey_top_40x1"];
    leftImg.image = [UIImage imageNamed:@"line_vertical_1x20"];
    footImg.image = [UIImage imageNamed:@"line_grey_top_40x1"];
    rightImg.image = [UIImage imageNamed:@"line_vertical_1x20"];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, UIScreenWidth-60, 34)];
    textField.placeholder =@"请输入选项内容（限10字）";
    textField.clearButtonMode = UITextFieldViewModeUnlessEditing;//右边显示的'X'清楚按钮
    [textField setValue:[UIColor getColor:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    textField.borderStyle=UITextBorderStyleNone;
    textField.returnKeyType=UIReturnKeyDone;
    textField.delegate=self;
    
    [itemView addSubview:topImg];
    [itemView addSubview:leftImg];
    [itemView addSubview:footImg];
    [itemView addSubview:rightImg];
    [itemView addSubview:textField];
    //给textfield列表赋值
    [self.textFields addObject:textField];
    [_voteCustomView addSubview:itemView];
     _voteCustomViewHeight.constant = 54+self.height;
    
    if ([self.textFields count] > 4) {
        [_addVoteView setHidden:YES];
    }
}

-(IBAction)addVoteCustomItem:(id)sender{
    self.height = self.height + 54;
    [self addCustomItem];
    _addVoteTopConstrait.constant = 54+self.height;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            //无权限
            [self addAlertViewWithInfo:@"请在iPhone的“设置-隐私-照片”选项中，允许桃花源云社区访问你的手机相册"];
            return;
        }
    }
    
    if (buttonIndex == 0) {
        //先设定sourceType为相机，然后判断相机是否可用，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^(){
                
            }];
        }
        else{
            [self showPhotoCellecitons];
        }
    }
    else if (buttonIndex == 1){
        [self showPhotoCellecitons];
    }
}

/**
 *  显示相册列表
 */
- (void)showPhotoCellecitons
{
    if (CURRENT_VERSION < 7.0) {
        //7.0以下使用系统相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        NSMutableArray *selectedAssets =  [[NSMutableArray alloc] init];
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.assetsFilter         = [ALAssetsFilter allPhotos];
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate             = self;
        picker.selectedAssets       = selectedAssets;
        [self presentViewController:picker animated:YES completion:NULL];

    }
}

/**
 *  添加本地相册隐私检查提示
 *
 *  @param str 提示内容
 */
- (void)addAlertViewWithInfo:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - Camera View Delegate Methods
/**
 *  系统原生:拍照完成或相册选择完成
 *
 *  @param picker 相机或相册
 *  @param info   照片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *thumbnailImage = [self thumbnailWithImage:image size:CGSizeZero];
    
    [self addThumbnialImage:thumbnailImage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);//图片存入相册
        }
        //long index = [self.photoFilePathArray count];
        
        //NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%ld.jpg",index]];
        NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%d.jpg",self.index]];
        self.index ++;
        [self scaleAndSaveImage:image andFilePath:fullPath];
    });
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (error){
        [SVProgressHUD showErrorWithStatus:@"照片存入本地错误，请重试"];
    }
}

/**
 *  在相机或相册 点了取消
 *
 *  @param picker picker description
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark - 多选照片CTAssets Picker Delegate

/**
 *  自定义选择多个照片
 *
 *  @param picker 选择器
 *  @param assets 选择的图片资源
 */
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    for (ALAsset *asset in assets) {
        UIImage *thumbnialImage = [UIImage imageWithCGImage:asset.thumbnail];
        [self addThumbnialImage:thumbnialImage];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //压缩并存储大图
        //long index = [self.photoFilePathArray count];
        //NSLog(@"index %ld",index);
        //long  index = 0;
        for (ALAsset *asset in assets) {
            UIImage *image = [self thumbnailMixSizeLimitForAsset:asset];
            //NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%ld.jpg",index]];
            NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%d.jpg",self.index]];
            //NSLog(@"fullpath %@",fullPath);
            [self scaleAndSaveImage:image andFilePath:fullPath];
            //index ++;
            self.index ++;
        }
    });
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= (6 - [_photoFilePathArray count]))
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"照片"
                                   message:[NSString stringWithFormat:@"最多只能添加%u张照片",6- (int)[_photoFilePathArray count]]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"照片"
                                   message:@"您的照片还未加载到设备中"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < (6 - [_photoFilePathArray count]) && asset.defaultRepresentation != nil);
}


static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

/**
 *  调整大图片尺寸,最小边长度不超过640
 *
 *  @param asset 相册返回的图片对象
 *
 *  @return 压缩调整后的图片
 */
- (UIImage *)thumbnailMixSizeLimitForAsset:(ALAsset *)asset
{
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    NSInteger mixSize = (width <= height) ? width : height;
    NSInteger maxSize = (width > height) ? width : height;
    if (mixSize > 640) {
        maxSize = maxSize * 640 / mixSize;
        image = [self thumbnailForAsset:asset maxPixelSize:maxSize];
    }
    return image;
}

/**
 *  调整大图片尺寸
 *
 *  @param asset 相册返回的图片对象
 *  @param size  限制的最大尺寸
 *
 *  @return 压缩调整后的图片
 */
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInteger:size],
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}


#pragma mark - 大图预览 PhotosViewsDatasource's  methods

- (NSInteger)photosViewNumberOfCount
{
    return [self.photoFilePathArray count];
}

- (UIImage *)photosViewImageAtIndex:(NSInteger)index
{
    NSMutableArray *largeImageArray = [[NSMutableArray alloc]initWithArray:_photoFilePathArray];
    largeImageArray  = (NSMutableArray *)[[largeImageArray reverseObjectEnumerator] allObjects];
    NSData *photoData = [NSData dataWithContentsOfFile:[largeImageArray objectAtIndex:index]];
    return (UIImage *)[UIImage imageWithData:photoData];
}

- (NSString *)photosViewUrlAtIndex:(NSInteger)index
{
    return nil;
}

#pragma mark - ImageButtonViewDelegate
/**
 *  点击小图，预览大图
 *
 *  @param sender 缩略图按钮
 */
- (void)showLargeImageViewWithTag:(int)tag
{
    if([self isPostedImageWritedFinished])
    {
        PhotosViewController *photosController = [[PhotosViewController alloc] init];
        photosController.datasource = self;
        photosController.currentPage = tag-IMAGE_BASE_TAG;
        photosController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:photosController animated:YES];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"图像处理中，请稍后"];
    }
    //_isPreviewBack = YES;
}

- (void)deleteSelectedImageViewWithTag:(int)tag
{
    //删除
    [self removeImageFromSeleted:tag];
}

#pragma mark - 图片管理
/**
 *  生成居中缩略图
 *
 *  @param image  原图片
 *  @param reSize 重新设置的图片size
 *
 *  @return 压缩后的缩略图
 */
- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)reSize
{
    CGSize size = image.size;
    
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    //取最小一边
    width = width > height ? height : width;
    reSize  =CGSizeMake(width, width);
    
    UIGraphicsBeginImageContext(reSize);
    float dwidth = (reSize.width - size.width) / 2.0f;
    float dheight = (reSize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

/**
 *  调整选择的照片质量，并写入临时目录下
 *
 *  @param image    选择的图片
 *  @param fullPath 写入的路径
 */
- (void)scaleAndSaveImage:(UIImage *)image andFilePath:(NSString *)fullPath
{
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
    [self.photoFilePathArray insertObject:fullPath atIndex:[_photoFilePathArray count]];
}

/**
 *  图片存入缓存目录，加入展示图片集合
 *
 *  @param image    选择的图片
 *  @param fullPath 图片完整路径
 */
- (void)addThumbnialImage:(UIImage *)thumbnailImage
{
    //添加缩略图
    for (NSInteger i = 0 ;i < [_photoViewArray count];i++) {
        UIButton *photoView = [_photoViewArray objectAtIndex:i];
        CGRect newRect = photoView.frame;
        newRect.origin.x =  15 + ((i+1)%3)*(_pWidth+10);
        newRect.origin.y =  10 + ((i+1)/3)*(_pWidth+10);
        photoView.frame = newRect;
        photoView.tag += 1;
        if ([photoView isKindOfClass:[ImageButtonView class]]) {
            ImageButtonView *photoButton = (ImageButtonView *)photoView;
            photoButton.deleteButton.tag += 1;
        }
    }
    
    ImageButtonView *imageBtn = [[ImageButtonView alloc] initWithFrame:CGRectMake(15, 10, _pWidth, _pWidth)];
    imageBtn.delegate = self;
    imageBtn.tag = IMAGE_BASE_TAG;
    imageBtn.deleteButton.tag = IMAGE_BASE_TAG;
    imageBtn.contentMode = UIViewContentModeScaleAspectFill;
    imageBtn.userInteractionEnabled = YES;
    [imageBtn.imageButton setImage:thumbnailImage forState:UIControlStateNormal];
    
    [self.picturesView addSubview:imageBtn];
    [self.photoViewArray insertObject:imageBtn atIndex:0];
    
    if ([_photoViewArray count] > 3) {
        self.picturesViewHConstriat.constant = 30+_pWidth*2;
    }
    else{
        self.picturesViewHConstriat.constant = 20+_pWidth;
    }
    [self.view layoutIfNeeded];
    
    if ([_photoViewArray count] > 6) {
        //隐藏添加按钮
        self.addPicButton.hidden = YES;
    }
    
    if ([_photoViewArray count] > 1) {
        self.addPicTipView.hidden = YES;
    }
    else{
    }
    
    _isScaleImagesFinished = NO;
}

/**
 *  移除图片
 *
 *  @param imageTag 移除的图片tag
 */
- (void)removeImageFromSeleted:(int)imageTag
{
    if(![self isPostedImageWritedFinished])
    {
        [SVProgressHUD showErrorWithStatus:@"图片正在处理中，请稍后"];
        
        return;
    }
    
    int index = imageTag - IMAGE_BASE_TAG;
    NSLog(@"shanchu idnex %d",index);
    [self.photoViewArray removeObjectAtIndex:index];
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    for (int i = (int)[self.photoFilePathArray count]-1; i>=0; i--) {
        NSString *string = [NSString stringWithFormat:@"%d",i];
        [indexArray addObject:string];
    }
    int photoIndex = [[indexArray objectAtIndex:index]intValue];
    NSLog(@"photoIndex %d",photoIndex);
    //删除缓存图片
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *filePath = [self.photoFilePathArray objectAtIndex:photoIndex];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:filePath error:&err];
    }
    [self.photoFilePathArray removeObjectAtIndex:photoIndex];
    
    //倒序拍数组array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
    //从视图上移除图片
    UIButton *deletedImage = (UIButton *)[self.view viewWithTag:imageTag];
    [deletedImage removeFromSuperview];
    
    //调整删除项后面图片的坐标和tag
    int begin = (int)[_photoViewArray count] - 1;
    for (int i = begin; i >= index; i--) {
        UIButton *photoView = (UIButton *)[_photoViewArray objectAtIndex:i];
        CGRect newRect = photoView.frame;
        newRect.origin.x =  15 + i%3*(_pWidth+10);
        newRect.origin.y =  10 + i/3*(_pWidth+10);

        photoView.frame = newRect;
        photoView.tag -= 1;
        if ([photoView isKindOfClass:[ImageButtonView class]]) {
            ImageButtonView *photoButton = (ImageButtonView *)photoView;
            photoButton.deleteButton.tag -= 1;
        }
    }
    
    
    if ([_photoViewArray count] == 1) {
        self.addPicTipView.hidden = NO;
    }
    
    if ([_photoViewArray count] <= 6) {
        self.addPicButton.hidden = NO;
    }
    
    if ([_photoViewArray count] <= 3) {
        // 更新照片view高度
        self.picturesViewHConstriat.constant = 20+_pWidth;
        [self.view layoutIfNeeded];
    }
}

/**
 *  发帖的图片是否压缩写入本地完成
 *
 *  @return 是否完成
 */
- (BOOL)isPostedImageWritedFinished
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Circle"];
    NSFileManager *circleFileManager = [NSFileManager defaultManager];
//    NSDirectoryEnumerator *circleCacheEnumerator = [circleFileManager enumeratorAtPath:path];
//    
//    NSUInteger imageCount = 0;
//    while ([circleCacheEnumerator nextObject]) {
//        imageCount ++;
//    }
//    
//    if (imageCount + 1 == [_photoViewArray count]) {
//        _isScaleImagesFinished = YES;
//        return YES;
//    }
//    else{
//        return NO;
//    }
    
    int imageCount = 0;
    NSArray *arr = [circleFileManager contentsOfDirectoryAtPath:path error:nil];
    for (id object in arr) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)object;
            if ([@"jpg" isEqualToString:[str pathExtension]]) {
                imageCount++;
            }
        }
    }
    
    NSLog(@"本地已存储 count : %d 实际选择图片 count : %d",imageCount,(int)[_photoViewArray count]-1);
    if (imageCount == [_photoViewArray count]-1) {
        _isScaleImagesFinished = YES;
        return YES;
    }
    
    else{
        return NO;
    }
}

/**
 *  删除发帖缓存目录下的图片文件
 */
- (void)removeAllImageInCircleCache
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Circle"];
    NSFileManager *circleFileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *circleCacheEnumerator = [circleFileManager enumeratorAtPath:path];
    
    NSString *imageFile;
    while (imageFile = [circleCacheEnumerator nextObject]) {
        if ([[imageFile pathExtension] isEqualToString:@"jpg"]) {
            NSError *err;
            [circleFileManager removeItemAtPath:[path stringByAppendingPathComponent:imageFile] error:&err];
        }
    }
}

/**
 *  获取图片缓存的完整路径
 *
 *  @param file 文件名称
 *
 *  @return 图片完整路径
 */
- (NSString *)dataPath:(NSString *)file
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Circle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *oldTime = [dateFormatter stringFromDate:now];
    
    NSString *result = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",oldTime,file]];
    return result;
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.contentTipLabel.text = @"随时随地，分享新鲜事！";
    }else{
        self.contentTipLabel.text = @"";
    }
    
    [self.textNumberLabel setText:[NSString stringWithFormat:@"%lu/200",textView.text.length > 200 ? 200:textView.text.length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([toBeString length] > 200) {
        textView.text = [toBeString substringToIndex:200];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按下Done按钮时调用这个方法，可让按钮消失
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    return YES;
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    //同时在这里是可以做文本长度限制的判断处理的
    if (range.location>= 20)
    {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [textField resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldShow = textField;
    //    键盘高度216
//    if (textField.frame.origin.y>216) {
//        
//        CGRect frame =  self.view.frame;
//        frame.origin.y -=216;
//        frame.size.height +=216;
//        self.view.frame=frame;
//    }
}



@end
