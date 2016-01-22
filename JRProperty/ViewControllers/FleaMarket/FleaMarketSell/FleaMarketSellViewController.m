//
//  FleaMarketSellViewController.m
//  JRProperty
//
//  Created by YMDQ on 15/12/22.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "FleaMarketSellViewController.h"
#import "FleaMarketService.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "JRPropertyUntils.h"

#import "ImageButtonView.h"
#import "PhotosViewController.h"
#import "CTAssetsPickerController.h"
#import <ImageIO/ImageIO.h>
#import "SVProgressHUD.h"

#define IMAGE_BASE_TAG  200

@interface FleaMarketSellViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CTAssetsPickerControllerDelegate,UITextViewDelegate,ImageButtonViewDelegate,PhotosViewDatasource>

{
    BOOL _isScaleImagesFinished;   // 发帖选择的图片是否压缩存储完成
    NSInteger _pWidth;             // 图片宽度
}


@property (nonatomic, strong) NSMutableArray *photoViewArray;               // 选择的图片按钮数组,包括一个添加按钮
@property (nonatomic, strong) NSMutableArray *photoFilePathArray;           // 选择的图片完整路径
@property (nonatomic, strong) UIButton       *addPicButton;                 // 添加照片的按钮
@property (nonatomic,assign) int index;

@property(nonatomic,assign) int type;


@property(strong,nonatomic) FleaMarketService * fleaMarketService; // 跳蚤市场service

@end

@implementation FleaMarketSellViewController

-(void)config{
    self.index = 0;
    self.photoViewArray = [[NSMutableArray alloc] init];
    self.photoFilePathArray = [[NSMutableArray alloc] init];
    
    self.fleaMarketService = [[FleaMarketService alloc] init];
    
    self.type = 0; // 0售卖1求购
    
    [self removeAllImageInCircleCache];
    [self pictureViewAddImageButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userConPhone.text = [LoginManager shareInstance].loginAccountInfo.username;
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.priceView addGestureRecognizer:tapGestureRecognizer];
    
    
    [self.sliderView setThumbImage:[UIImage imageNamed:@"uesd_public_btn_money"] forState:UIControlStateNormal];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"uesd_public_btn_money_press"] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [self setRightBarButtonItem]; // 设置title右按钮
    [self config];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//
//    // scrollview偏移
    
    if ([self.photoFilePathArray count] > 0) {
        self.scrollView.contentOffset = CGPointMake(0, keyboardHeight);
    }
    
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
    [self.view addGestureRecognizer:keyboardTap];
    
}

/**
 *  当键盘退出时调用
 *
 *  @param aNotification 通知
 */
- (void)keyboardWillHide:(NSNotification *)aNotification {
//    // 还原scrollview
    self.scrollView.contentOffset = CGPointMake(0,0);
//
//    NSLayoutConstraint *bottomConstraint = [self.voteView findConstraintForAttribute:NSLayoutAttributeBottom];
//    bottomConstraint.constant = 20;
//    [self.view layoutIfNeeded];
}

/**
 *  添加图片按钮
 */
- (void)pictureViewAddImageButton
{
    // 添加默认的添加按钮
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageBtn.frame = CGRectMake(15, 10, 90, 90);
    addImageBtn.tag = IMAGE_BASE_TAG;
    addImageBtn.contentMode = UIViewContentModeScaleAspectFill;
    addImageBtn.userInteractionEnabled = YES;
    self.addPicButton = addImageBtn;
    [addImageBtn addTarget:self action:@selector(addImagesAction:) forControlEvents:UIControlEventTouchUpInside];
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"public_topic_add_pic.png"] forState:UIControlStateNormal];
    
    [self.imagesView addSubview:addImageBtn];
    [self.photoViewArray insertObject:addImageBtn atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _pWidth = (UIScreenWidth - 50)/3;
    
    CGRect addButtonFrame = self.addPicButton.frame;
    addButtonFrame.size.width = _pWidth;
    addButtonFrame.size.height = _pWidth;
    self.addPicButton.frame = addButtonFrame;
    
//    self.addPicTipLeadingCon.constant = _pWidth+32;
    self.addImgtipsConstraint.constant = _pWidth+32;
    
    if ([_photoViewArray count] > 3) {
//        self.picturesViewHConstriat.constant = 30+_pWidth*2;
        self.imagesViewConstraints.constant = 30+_pWidth*2;
    }
    else{
//        self.picturesViewHConstriat.constant = 20+_pWidth;
        self.imagesViewConstraints.constant = 20+_pWidth;
    }
    [self.view layoutIfNeeded];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placelabel.hidden = NO;
    }else{
        self.placelabel.hidden = YES;
    }
    
    //    [self.textNumberLabel setText:[NSString stringWithFormat:@"%u/100",textView.text.length > 100 ? 100:textView.text.length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([toBeString length] > 200) {
        textView.text = [toBeString substringToIndex:200];
        return NO;
    }
    
    return YES;
}

/**
 *  给tableview加的手势触发事件  点击空白处 隐藏键盘
 *
 *  @param tap 点击手势
 */
//-(void)keyboardHide:(UITapGestureRecognizer *)tap {
//    [self.prodInfoTextView resignFirstResponder];
//    [self.nowPrice resignFirstResponder];
//    [self.oldPrice resignFirstResponder];
//}

- (void)hiddenKeyboardTaped:(id)sender
{
    [self.prodInfoTextView resignFirstResponder];
    [self.nowPrice resignFirstResponder];
    [self.oldPrice resignFirstResponder];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    [self.view removeGestureRecognizer:tap];
}


- (IBAction)sliderAction:(id)sender {
    UISlider * slider = (UISlider*)sender;
    if(slider.value > 0.5){
        [self priceOrNoPriceSlide:NO];
    }else{
        [self priceOrNoPriceSlide:YES];
    }
}


- (IBAction)priceAction:(id)sender {
    [self priceOrNoprice:YES];
    [self priceOrNoPriceSlide:YES];
}

- (IBAction)noPriceAction:(id)sender {
    [self priceOrNoprice:NO];
    [self priceOrNoPriceSlide:NO];
}


- (IBAction)sliderDragAction:(id)sender {
    UISlider * slider = (UISlider*)sender;
    if (slider.value >= 0.5) {
        [slider setThumbImage:[UIImage imageNamed:@"uesd_public_btn_none_press"] forState:UIControlStateHighlighted];
        [self priceOrNoprice:NO];
    }else{
        [self.sliderView setThumbImage:[UIImage imageNamed:@"uesd_public_btn_money_press"] forState:UIControlStateHighlighted];
        [self priceOrNoprice:YES];
    }
}

-(void)priceOrNoprice:(BOOL)p{
    if (p) {
        [self.priceButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        self.priceButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        [self.noPriceButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.noPriceButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        BOOL t = self.priceView2.hidden; // priceview2当前可视状态
        self.priceView2.hidden = NO;
        if (t == YES) {
            [self.phoneView setFrame:CGRectMake(self.phoneView.frame.origin.x, self.phoneView.frame.origin.y+self.priceView2.frame.size.height, self.phoneView.frame.size.width, self.phoneView.frame.size.height)];
            self.toPriceViewConstraint.constant = 47;
        }
        
    }else{
        [self.noPriceButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        self.noPriceButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        
        [self.priceButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.priceButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        BOOL t = self.priceView2.hidden; // priceview2当前可视状态
        self.priceView2.hidden = YES;
        if (t == NO) {
            [self.phoneView setFrame:CGRectMake(self.phoneView.frame.origin.x, self.phoneView.frame.origin.y-self.priceView2.frame.size.height, self.phoneView.frame.size.width, self.phoneView.frame.size.height)];
            self.toPriceViewConstraint.constant = 0;
        }
        
    }
}


-(void)priceOrNoPriceSlide:(BOOL) p{
    if (p) {
        [self.sliderView setValue:0.0 animated:YES];
        [self.sliderView setThumbImage:[UIImage imageNamed:@"uesd_public_btn_money"] forState:UIControlStateNormal];
    }else{
        [self.sliderView setValue:1.0 animated:YES];
        [self.sliderView setThumbImage:[UIImage imageNamed:@"uesd_public_btn_none"] forState:UIControlStateNormal];
    }
}

/**
 *  设置导航栏右键
 */
- (void)setRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 32 + 22, 15)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 32, 15)];
    }
    //[editButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
    //    [editButton setTitle:@"提交" forState:UIControlStateNormal];
    //    [editButton setTitle:@"提交" forState:UIControlStateHighlighted];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateHighlighted];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    //    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [editButton addTarget:self action:@selector(submitFleaSell) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 10000;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  发布我要卖的跳蚤信息
 */
-(void)submitFleaSell{
    NSString * content = [self.prodInfoTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.prodInfoTextView.text = content;
    float v = self.sliderView.value;
    if (v == 1) {
        self.nowPrice.text = @"";
        self.oldPrice.text = @"";
    }else{
        NSString * cp = [self.nowPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString * op = [self.oldPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString * regex = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$";
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if (![predicate evaluateWithObject:cp]) {
            [self addAlertViewWithInfo:@"请填写正确的现价金额,金额在0到亿元之间"];
            return;
        }
        if ((![@"" isEqualToString:op]) && (![predicate evaluateWithObject:op])) {
            [self addAlertViewWithInfo:@"请填写正确的原价金额"];
            return;
        }
        self.nowPrice.text = cp;
        self.oldPrice.text = op;
    }
    if ((content==nil || [@"" isEqualToString:content]) && [self.photoFilePathArray count] == 0) {
        [self addAlertViewWithInfo:@"请填写宝贝信息或者上传图片"];
        return;
    }
    
    
    [self checkWriteImageStatusThenPublic];
}



/**
 *  点击添加图片按钮，进入图片选择
 *
 *  @param sender
 */
- (void)addImagesAction:(id)sender {
    //[self keyBoardHidden];
    [self.prodInfoTextView resignFirstResponder];
    
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
                
                [self.fleaMarketService Bus600501:@""
                                              uId:[LoginManager shareInstance].loginAccountInfo.uId
                                          content:self.prodInfoTextView.text
                                             flag:[_photoFilePathArray count] > 0 ? @"1" : @"0"
                                             file:_photoFilePathArray phoneType:@"2"
                                            model:[JRPropertyUntils deviceModelString]
                                             type:[NSString stringWithFormat:@"%d",self.type]
                                           oPrice:self.oldPrice.text
                                           cPrice:self.nowPrice.text
                                        showPhone:self.isPhoneView.on?self.userConPhone.text:@""
                                          success:^(id responseObject) {
                    BaseModel *resultModel = (BaseModel *)responseObject;
                    if ([RETURN_CODE_SUCCESS isEqualToString:resultModel.retcode]) {
                        [SVProgressHUD showSuccessWithStatus:resultModel.retinfo];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:PUBLICE_ARTICLE_SUCCESS  object:self];
                                                 //延迟返回上一级页面
                                                 [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popViewController) userInfo:nil repeats:NO];
                    }else{
                        // 失败
                                                 [SVProgressHUD showErrorWithStatus:resultModel.retinfo];
                    }
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"发布我的跳走宝贝失败，请稍后重试"];
                                        
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




#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            //无权限
            [self addAlertViewWithInfo:@"请在iPhone的“设置-隐私-照片”选项中，允许桃花源访问你的手机相册"];
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
    
//    [self.picturesView addSubview:imageBtn];
    [self.imagesView addSubview:imageBtn];
    [self.photoViewArray insertObject:imageBtn atIndex:0];
    
    if ([_photoViewArray count] > 3) {
//        self.picturesViewHConstriat.constant = 30+_pWidth*2;
        self.imagesViewConstraints.constant = 30+_pWidth*2;
    }
    else{
//        self.picturesViewHConstriat.constant = 20+_pWidth;
        self.imagesViewConstraints.constant = 20+_pWidth;
    }
    [self.view layoutIfNeeded];
    
    if ([_photoViewArray count] > 6) {
        //隐藏添加按钮
        self.addPicButton.hidden = YES;
    }
    
    if ([_photoViewArray count] > 1) {
//        self.addPicTipView.hidden = YES;
        self.addImgtipsView.hidden = YES;
        self.addImgtipsView2.hidden = YES;
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
//        self.addPicTipView.hidden = NO;
        self.addImgtipsView.hidden = NO;
        self.addImgtipsView2.hidden = NO;
    }
    
    if ([_photoViewArray count] <= 6) {
        self.addPicButton.hidden = NO;
    }
    
    if ([_photoViewArray count] <= 3) {
        // 更新照片view高度
//        self.picturesViewHConstriat.constant = 20+_pWidth;
        self.imagesViewConstraints.constant = 20+_pWidth;
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





- (IBAction)wantSellAction:(id)sender {
    [self.sellBtn setTitleColor:UIColorFromRGB(0xd96e5d) forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.35f animations:^{
        //        self.saleingBtn.center;
        CGPoint point = self.slideImgView.center;
        point.x = self.sellBtn.center.x;
        [self.slideImgView setCenter:point];
    }];
    self.type = 0;
    [self clearView];
}
- (IBAction)wantSaleAction:(id)sender {
    [self.saleBtn setTitleColor:UIColorFromRGB(0xd96e5d) forState:UIControlStateNormal];
    [self.sellBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.35f animations:^{
        //        self.saleingBtn.center;
        CGPoint point = self.slideImgView.center;
        point.x = self.saleBtn.center.x;
        [self.slideImgView setCenter:point];
    }];
    self.type = 1;
    [self clearView];
    
}

-(void) clearView{
    self.prodInfoTextView.text = @"";
    self.isPhoneView.on = YES;
    self.nowPrice.text = @"";
    self.oldPrice.text = @"";
    

    while ([self.photoFilePathArray count]) {
        [self removeImageFromSeleted:IMAGE_BASE_TAG];
    }
    
//    for (int i = 0; i < [self.photoFilePathArray count]; i++) {
//        [self removeImageFromSeleted:IMAGE_BASE_TAG];
//    }
    
}
@end
