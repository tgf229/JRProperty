//
//  PropertyServiceCommonPostViewController.m
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PropertyServiceCommonPostViewController.h"
#import "JRDefine.h"
#import "ImageButtonView.h"
#import "HouseService.h"
#import "PropertyService.h"
#import "LoginManager.h"
#import "MyHouseListModel.h"
#import "CTAssetsPickerController.h"
#import "PhotosViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "NoResultView.h"
#import "PhotosViewController.h"
#import "SVProgressHUD.h"
#define houseTableViewCellHeight    42.0f
#define IMAGEVIEWWIDTH    (UIScreenWidth - 80) / 3
#define PATHCOMPONENT       @"PropertyServiceCommonPostImageViewFiles"
#define PLACEHOLD   @"请选择房屋"
#define HAVENOTHOUSE    @"您暂未绑定任何房屋"
@interface PropertyServiceCommonPostViewController ()<ImageButtonViewDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,PhotosViewDatasource,PhotosViewDelegate,UIImagePickerControllerDelegate>
{
    BOOL _isScaleImagesFinished;   //发帖选择的图片是否压缩存储完成
    int houseRow;
}
@property (nonatomic, strong) HouseService * houseService;          // 绑定房屋列表服务类
@property (nonatomic, strong) PropertyService *propertyService;     // 物业服务类
@property (nonatomic, strong) NSMutableArray * houseArray; // 账户下房子数组
@property (nonatomic, strong) NSMutableArray * assets;              // 缩略图数组
@property (nonatomic, strong) NSMutableArray * imageViewButtonArray;// 展示缩略图控件数组
@property (nonatomic, strong) NSMutableArray * photoFilePathArray;  // 大图本地写入路径数组
@property (nonatomic, strong) NoResultView * noResultView;          // 哭脸
@property (nonatomic, strong) NSTimer   * workTimer;                // 图片写入本地计时器
@end

@implementation PropertyServiceCommonPostViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    [_workTimer invalidate];
}

/**
 *  配置信息
 */
- (void)config{
    _bottomViewHeightConstraint.constant = 0.0f;
    _tipLabel.hidden = YES;
    _mainScrollView.hidden = YES;
    _contentPlaceholderLabel.text = [NSString stringWithFormat:@"请在此描述您的%@信息",self.title];
    self.houseService = [[HouseService alloc] init];
    self.propertyService = [[PropertyService alloc] init];
    self.houseArray = [[NSMutableArray alloc] init];
    self.assets = [[NSMutableArray alloc] init];
    self.imageViewButtonArray = [[NSMutableArray alloc] init];
    self.photoFilePathArray = [[NSMutableArray alloc] init];
    _isScaleImagesFinished = YES;
    _houseAddressLabel.text = @"";
    houseRow = 0;
    
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];
    [self removeAllImageInCircleCache];
    
    _addImageButtonHeightConstraint.constant = IMAGEVIEWWIDTH;
    _addImageButtonWidthConstraint.constant = IMAGEVIEWWIDTH;
    _infoViewHeightConstraint.constant = IMAGEVIEWWIDTH;
    _infoViewWidthConstraint.constant = IMAGEVIEWWIDTH;
    _uploadImageViewHeightConstraint.constant = 20 + IMAGEVIEWWIDTH;
    
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//    [self.mainScrollView.superview addGestureRecognizer:tapGR];
}

//- (void)hideKeyBoard{
//    _selectHouseButton.selected = NO;
//    _houseTableViewHeightConstraint.constant = 0;
//    [_contentTextView resignFirstResponder];
//}

/**
 *  展示页面提示信息
 */
- (void)showView{
    if (![@"报修" isEqualToString:self.title]) {
        _bottomViewHeightConstraint.constant = 0.0f;
        _tipLabel.hidden = YES;
        _uploadImageViewBottomHeightConstraint.constant = 150.0f;
    }else{
        UIImage *image = [[UIImage imageNamed:@"service_bg_bottom"] stretchableImageWithLeftCapWidth:1 topCapHeight:10];
        [_bottomImageView setImage:image];
        _tipLabel.hidden = NO;
        _bottomViewHeightConstraint.constant = 75.0f;
        _uploadImageViewBottomHeightConstraint.constant = 75.0f;
    }
    _mainScrollView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([@"报修" isEqualToString:self.title]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_baoxiu"]];
    } else if ([@"求助" isEqualToString:self.title]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_qiuzhu"]];
    } else if ([@"投诉" isEqualToString:self.title]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_tousu"]];
    } else if ([@"建议" isEqualToString:self.title]) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_jianyi"]];
    }
    [self.view setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    if (CURRENT_VERSION < 7.0f) {
        _topConstraint.constant = 0.0f;
    }
//    _houseAddressLabel.text = houseTableViewDataSourceArray[0];
    _houseTableViewHeightConstraint.constant = 0;
    [_selectHouseButton setImage:[UIImage imageNamed:@"service_icon_arrow_up"] forState:UIControlStateSelected];
    [_contentPlaceholderLabel setTextColor:UIColorFromRGB(0x666666)];
    [_wordsSumNumLabel setTextColor:UIColorFromRGB(0x888888)];
    _contentTextView.text = @"";
    
    
    [_infoLabel1 setTextColor:UIColorFromRGB(0x666666)];
    [_infoLabel2 setTextColor:UIColorFromRGB(0x666666)];
    [_imageViewNumLabel setTextColor:UIColorFromRGB(0x666666)];
    [self config];
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [self.houseService Bus401201:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        if ([responseObject isKindOfClass:[MyHouseListModel class]]) {
            MyHouseListModel * myHouseListModel = (MyHouseListModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:myHouseListModel.retcode]) {
                for (MyHouseModel * houseModel in myHouseListModel.doc) {
                    if ([@"0" isEqualToString:houseModel.flag]) {
                        if ([CID_FOR_REQUEST isEqualToString:houseModel.cId]) {
                            [self.houseArray addObject:houseModel];
                        }
                        
                    }
                }
                if ([self.houseArray count]!=0) {
                    if ([self.houseArray count] > 1) {
                        _selectHouseButton.hidden = NO;
                        _houseAddressLabel.text = PLACEHOLD;
                    }else{
                        _selectHouseButton.hidden = YES;
                        MyHouseModel * myHouseModel = (MyHouseModel *)self.houseArray[0];
                        _houseAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",myHouseModel.cName,myHouseModel.bName,myHouseModel.dName,myHouseModel.hName];

                    }
                    [_houseTableView reloadData];
                }else{
                    _selectHouseButton.hidden = YES;
                    _houseAddressLabel.text = HAVENOTHOUSE;
                }
                [self showView];
                [self setRightBarButtonItem];
            }else{
                [self.noResultView initialWithTipText:myHouseListModel.retinfo];
                [self.noResultView setHidden:NO];
            }
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
        [self.noResultView setHidden:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
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
    
    
//    _contentPlaceholderLabel.hidden = _contentTextView.text.length > 0;
//    if (_contentTextView.text.length > 200) {
//        NSString * str = _contentTextView.text;
//        _contentTextView.text = [str substringToIndex:200];
//    }
    [_wordsSumNumLabel setText:[NSString stringWithFormat:@"%d/200",_contentTextView.text.length>200?200:_contentTextView.text.length]];
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
 *  设置导航栏右键
 */
- (void)setRightBarButtonItem
{
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [editButton setFrame:CGRectMake(0, 0, 32 + 22, 20)];
    } else {
        [editButton setFrame:CGRectMake(0, 0, 32, 20)];
    }
    //[editButton setTitleEdgeInsets: UIEdgeInsetsMake(0, 20, 0, 0)];
    //    [editButton setTitle:@"提交" forState:UIControlStateNormal];
    //    [editButton setTitle:@"提交" forState:UIControlStateHighlighted];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"title_red_tijiao"] forState:UIControlStateHighlighted];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    //    [editButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateHighlighted];
    //    editButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [editButton addTarget:self action:@selector(submitDataToService) forControlEvents:UIControlEventTouchUpInside];
    editButton.tag = 10000;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  提交服务器
 */
- (void)submitDataToService{
    [_contentTextView resignFirstResponder];
    if ([PLACEHOLD isEqualToString:_houseAddressLabel.text]||[HAVENOTHOUSE isEqualToString:_houseAddressLabel.text]) {
        [SVProgressHUD showErrorWithStatus:_houseAddressLabel.text];
        return;
    }
    
    // 不满意 必须填写内容
    NSString * str = [_contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([@"" isEqualToString:str]||str==nil) {
        // 请输入内容
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    
    if (str.length > 200) {
        [SVProgressHUD showErrorWithStatus:@"您输入的内容已超过200字"];
        return;
    }
    
    NSString *typeStr = @"1";
    NSString *flagStr = @"0";
    if ([@"投诉" isEqualToString:self.title]){
        typeStr = @"2";
    }else if ([@"表扬" isEqualToString:self.title]){
        typeStr = @"3";
    }
    else if ([@"求助" isEqualToString:self.title]){
        typeStr = @"4";
    }
    else if([@"建议" isEqualToString:self.title]){
        typeStr = @"5";
    }
    
    if ([self.imageViewButtonArray count]!= 0) {
        flagStr = @"1";
    }
    UIButton * btn = (UIButton *)[self.navigationItem.rightBarButtonItem.customView viewWithTag:1000];
    btn.userInteractionEnabled = NO;
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    }
    if (!_isScaleImagesFinished) {
        _workTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething) userInfo:nil repeats:YES];
        return;
    }
    
    MyHouseModel * myHouseModel = (MyHouseModel *)self.houseArray[houseRow];
    [self.propertyService Bus200101:myHouseModel.cId hId:myHouseModel.hId uId:[LoginManager shareInstance].loginAccountInfo.uId content:str flag:flagStr file:self.photoFilePathArray type:typeStr success:^(id responseObject) {
        if([responseObject isKindOfClass:[BaseModel class]]){
            BaseModel *baseModel = (BaseModel *)responseObject;
            if ([RETURN_CODE_SUCCESS isEqualToString:baseModel.retcode]) {
                // 提交成功
                if (self.propertyServiceCommentSuccessBlock) {
                    self.propertyServiceCommentSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:baseModel.retinfo];
            }
        }
        btn.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:OTHER_ERROR_MESSAGE];
        btn.userInteractionEnabled = YES;
    }];
}
///**
// *  展示错误信息
// *
// *  @param msg 信息
// */
//- (void)showErrorMessageFormServiceWithMsg:(NSString *)msg{
//    [SVProgressHUD showErrorWithStatus:msg];
//}

/**
 *  定时操作
 */
- (void)doSomething{
    if (_isScaleImagesFinished) {
        [_workTimer invalidate];
        [self submitDataToService];
    }
}

/**
 *  选择房屋按钮点击触发
 *
 *  @param sender
 */
- (IBAction)arrowButtonSelected:(id)sender {
    if (_selectHouseButton.selected) {
        _selectHouseButton.selected = NO;
        _houseTableViewHeightConstraint.constant = 0;
    }else{
        _selectHouseButton.selected = YES;
        _houseTableViewHeightConstraint.constant = self.houseArray.count > 3?3*houseTableViewCellHeight:houseTableViewCellHeight * self.houseArray.count;
    }
    [self showAnimateWhenChangeConstraint];
    [_contentTextView resignFirstResponder];
}

/**
 *  添加图片按钮点击触发
 *
 *  @param sender
 */
- (IBAction)addImageViewButtonSelected:(id)sender {
    _houseTableViewHeightConstraint.constant = 0;
    _selectHouseButton.selected = NO;
    [self showAnimateWhenChangeConstraint];
    [_contentTextView resignFirstResponder];
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
 *  显示照片选择列表
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
 *  添加图片按钮布局
 */
- (void)addImageViewButtonLayout{
    if (self.assets.count < 6) {
        _addButtonLeftConstraint.constant = (20 + (IMAGEVIEWWIDTH + 10) * (self.assets.count%3));
        _addButtonTopConstraint.constant = (10 + (IMAGEVIEWWIDTH + 10) * (self.assets.count/3));
    }
    
    if (self.assets.count < 3) {
        _uploadImageViewHeightConstraint.constant = IMAGEVIEWWIDTH + 20;
    }else{
        _uploadImageViewHeightConstraint.constant = IMAGEVIEWWIDTH * 2 + 30;
    }
    
    if (self.assets.count == 0) {
        _addImageInfoView.hidden = NO;
    }else{
        _addImageInfoView.hidden = YES;
    }
    
    _imageViewNumLabel.text = [NSString stringWithFormat:@"%d/6",(int)self.assets.count];
    
}

/**
 *  获取图片距左约束
 *
 *  @param object 图片按钮
 *
 *  @return 约束
 */
- (NSLayoutConstraint *)getObjectLeftLayoutConstraintWithObject:(ImageButtonView *)object{
    for (NSLayoutConstraint *constraint in object.superview.constraints) {
        if (constraint.firstItem == object && constraint.firstAttribute == NSLayoutAttributeLeading) {
            return constraint;
        }
    }
    return nil;
}

/**
 *  获取图片距顶部约束
 *
 *  @param object 图片按钮
 *
 *  @return 约束
 */
- (NSLayoutConstraint *)getObjectTopLayoutConstraintWithObject:(ImageButtonView *)object{
    for (NSLayoutConstraint *constraint in object.superview.constraints) {
        if (constraint.firstItem == object && constraint.firstAttribute == NSLayoutAttributeTop) {
            return constraint;
        }
    }
    return nil;
}

/**
 *  刷新图片那妞布局
 */
- (void)reFrashUploadImageViewUI{
    _imageViewNumLabel.text = [NSString stringWithFormat:@"%d/6",(int)self.assets.count];
    
    if (!self.imageViewButtonArray) {
        self.imageViewButtonArray = [[NSMutableArray alloc] init];
    }
    for (int i = self.imageViewButtonArray.count; i < self.assets.count; i++) {
        _addImageInfoView.hidden = YES;
        ImageButtonView *imageBtn = [[ImageButtonView alloc] initWithFrame:CGRectMake(20 + (IMAGEVIEWWIDTH + 10) * (i%3), 10 + (IMAGEVIEWWIDTH + 10) * (i/3), IMAGEVIEWWIDTH, IMAGEVIEWWIDTH)];
        imageBtn.delegate = self;
        imageBtn.tag = i;
//        ALAsset *asset = [self.assets objectAtIndex:i];
//        imageBtn.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        imageBtn.imageView.image = self.assets[i];
        [_uploadImageView addSubview:imageBtn];
        [self.imageViewButtonArray addObject:imageBtn];
        imageBtn.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *metrics = @{@"hPadding":@(20 + (IMAGEVIEWWIDTH + 10) * (i%3)),@"vPadding":@(10 + (IMAGEVIEWWIDTH + 10) * (i/3)),@"imageEdge":@(IMAGEVIEWWIDTH)};
        [_uploadImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[imageBtn(==imageEdge)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(imageBtn)]];
        [_uploadImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vPadding-[imageBtn(==imageEdge)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(imageBtn)]];
    }
    [self addImageViewButtonLayout];
    [self showAnimateWhenChangeConstraint];
}

/**
 *  开启约束动画
 */
- (void)showAnimateWhenChangeConstraint{
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.35f animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  发帖的图片是否压缩写入本地完成
 *
 *  @return 是否完成
 */
- (BOOL)isPostedImageWritedFinished
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:PATHCOMPONENT];
    NSFileManager *circleFileManager = [NSFileManager defaultManager];
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
    NSLog(@"本地已存储 count : %d 实际选择图片 count : %d",imageCount,(int)[self.assets count]);
    if (imageCount == [self.assets count]) {
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
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:PATHCOMPONENT];
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
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:PATHCOMPONENT];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    NSString *oldTime = [dateFormatter stringFromDate:now];
    
    NSString *result = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",oldTime,file]];
    return result;
}

/**
 *  图片方向纠正
 *
 *  @param srcImg 原图片
 *
 *  @return 纠正后的图片
 */
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp)
        return srcImg;
    
    NSLog(@"fix image orientaion");
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

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
    NSLog(@"thumbnailWithImage preSize,width: %f",width);
    
    
    UIGraphicsBeginImageContext(reSize);
    float dwidth = (reSize.width - size.width) / 2.0f;
    float dheight = (reSize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
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
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
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

/**
 *  调整选择的照片质量，并写入临时目录下
 *
 *  @param image    选择的图片
 *  @param fullPath 写入的路径
 */
- (void)scaleAndSaveImage:(UIImage *)image andFilePath:(NSString *)fullPath
{
    //调整图片方向
    image = [self fixOrientation:image];
    
    float quality = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, quality);
    NSLog(@"before scale:imageData length %d Bytes,%d K",imageData.length,imageData.length/1024);
    
    
    if(imageData.length > 200 * 1024)
    {
        quality = 0.7;
        imageData = UIImageJPEGRepresentation(image, quality);
        
        NSLog(@"0.7 scale:imageData length %d Bytes,%d K",imageData.length,imageData.length/1024);
        
        while (imageData.length < 200 * 1024 && (quality < 1.0)) {
            quality += 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
        
        while (imageData.length > 200 * 1024 && (quality > 0.0)) {
            quality -= 0.1;
            imageData = UIImageJPEGRepresentation(image, quality);
        }
    }
    
    NSLog(@"after scale:imageData length %d Bytes,%d K ,quality:%f",imageData.length,imageData.length/1024,quality);
    
    if ([imageData writeToFile:fullPath atomically:NO]) {
        //写入到缓存目录
        [self.photoFilePathArray addObject:fullPath];
        [self isPostedImageWritedFinished];
    }
}

/**
 *  图片存入缓存目录，加入展示图片集合
 *
 *  @param image    选择的图片
 */
- (void)addThumbnialImage:(UIImage *)thumbnailImage
{
    //添加缩略图
    [self.assets addObject:thumbnailImage];
    _isScaleImagesFinished = NO;
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
        {
            //无权限
            [self addAlertViewWithInfo:@"请在iPhone的“设置-隐私-照片”选项中，允许中央商场访问你的手机相册"];
            return;
        }
    }
    
    if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            //先设定sourceType为相机，然后判断相机是否可用，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:NULL];
            }
            else{
                [self showPhotoCellecitons];
            }
        }
        else if (buttonIndex == 1){
            [self showPhotoCellecitons];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *thumbnailImage = [self thumbnailWithImage:image size:CGSizeZero];
    [self addThumbnialImage:thumbnailImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);//图片存入相册
            //            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            //            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
            //                [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //                    [self.assets addObject:asset];
            //                    [self reFrashUploadImageViewUI];
            //                } failureBlock:^(NSError *error) {
            //
            //                }];
            //            }];
        }
        NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%d.jpg",0]];
        [self scaleAndSaveImage:image andFilePath:fullPath];
    });
    [self reFrashUploadImageViewUI];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (error){
        [SVProgressHUD showErrorWithStatus:@"照片存入本地错误，请重试"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    [self.assets addObjectsFromArray:assets];
    for (ALAsset *asset in assets) {
        UIImage *thumbnialImage = [UIImage imageWithCGImage:asset.thumbnail];
        [self addThumbnialImage:thumbnialImage];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //缩小并存储大图
        int index = 0;
        for (ALAsset *asset in assets) {
            index ++;
            UIImage *image = [self thumbnailMixSizeLimitForAsset:asset];
            NSString *fullPath = [self dataPath:[NSString stringWithFormat:@"-%d.jpg",index]];
            [self scaleAndSaveImage:image andFilePath:fullPath];
        }
    });
    [self reFrashUploadImageViewUI];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= (6 - [_photoFilePathArray count]))
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"照片"
                                   message:[NSString stringWithFormat:@"最多只能添加%d张照片",6- [_photoFilePathArray count]]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"照片"
                                   message:@"您得照片还未加载到设备中"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < (6 - [_photoFilePathArray count]) && asset.defaultRepresentation != nil);
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.houseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"CellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell setBackgroundView:[[UIView alloc] init]];
    }
    MyHouseModel * myHouseModel = (MyHouseModel *)self.houseArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@",myHouseModel.cName,myHouseModel.bName,myHouseModel.dName,myHouseModel.hName];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHouseModel * myHouseModel = (MyHouseModel *)self.houseArray[indexPath.row];
    _houseAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",myHouseModel.cName,myHouseModel.bName,myHouseModel.dName,myHouseModel.hName];
    _houseTableViewHeightConstraint.constant = 0;
    _selectHouseButton.selected = NO;
    [self showAnimateWhenChangeConstraint];
    houseRow = indexPath.row;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _houseTableViewHeightConstraint.constant = 0;
    _selectHouseButton.selected = NO;
    [self showAnimateWhenChangeConstraint];
    return YES;
};

- (void)textViewDidChange:(UITextView *)textView{
    _contentPlaceholderLabel.hidden = textView.text.length > 0;
    
    if (textView.markedTextRange == nil && textView.text.length > 200) {
        NSString * str = textView.text;
        textView.text = [str substringToIndex:200];
    }
    
//    [_wordsSumNumLabel setText:[NSString stringWithFormat:@"%d/200",textView.text.length>200?200:textView.text.length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    if ([text isEqualToString:@"\n"]) {
//        if ([toBeString length] > 200) {
//            textView.text = [toBeString substringToIndex:200];
//        }
//        [_contentTextView resignFirstResponder];
//        return NO;
//    }
//    
//    if (_contentTextView == textView)
//    {
//        if ([toBeString length] > 200) {
//            textView.text = [toBeString substringToIndex:200];
//            return NO;
//        }
//    }
//    return YES;
    
    if ([text isEqualToString:@"\n"]) {
        [_contentTextView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length > 200 && text.length > range.length) {
        return NO;
    }
    return YES;
}

#pragma mark - ImageButtonViewDelegate

- (void)showLargeImageViewWithTag:(int)tag{
    if ([self isPostedImageWritedFinished]) {
        //查看大图
        PhotosViewController      *photosController = [[PhotosViewController alloc] init];
        photosController.datasource = self;
        photosController.currentPage = tag;
        photosController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:photosController animated:YES];
    }
//    else{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            if([self isPostedImageWritedFinished]) {
//                //大图压缩并存储完成后发送请求
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //查看大图
//                    PhotosViewController      *photosController = [[PhotosViewController alloc] init];
//                    photosController.datasource = self;
//                    photosController.currentPage = tag;
//                    [self.navigationController pushViewController:photosController animated:YES];
//                });
//            }
//            else{
//                NSLog(@"预览大图:等待图片压缩存入本地...");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3),dispatch_get_current_queue(), ^{
//                    [self showLargeImageViewWithTag:tag];
//                });
//            }
//        });
//        
//    }
}

- (void)deleteSelectedImageViewWithTag:(int)tag{
    //删除缓存图片
    if ([self isPostedImageWritedFinished]) {
        [self deleteThumImageViewWithTag:tag];
    }
//    else{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            if([self isPostedImageWritedFinished]) {
//                //大图压缩并存储完成后发送请求
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self deleteThumImageViewWithTag:tag];
//                });
//            }
//            else{
//                NSLog(@"预览大图:等待图片压缩存入本地...");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3),dispatch_get_current_queue(), ^{
//                    [self deleteSelectedImageViewWithTag:tag];
//                });
//                
//            }
//        });
//        
//    }
}

- (void)deleteThumImageViewWithTag:(int)tag{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *filePath = [self.photoFilePathArray objectAtIndex:tag];
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet) {
        NSError *err;
        if ([fileMgr removeItemAtPath:filePath error:&err]) {
            [self.photoFilePathArray removeObjectAtIndex:tag];
            [(ImageButtonView *)self.imageViewButtonArray[tag] removeFromSuperview];
            [self.imageViewButtonArray removeObjectAtIndex:tag];
            [self.assets removeObjectAtIndex:tag];
            for (ImageButtonView *imageBtn in self.imageViewButtonArray) {
                int i = [self.imageViewButtonArray indexOfObject:imageBtn];
                NSLayoutConstraint *leftConstraint = [self getObjectLeftLayoutConstraintWithObject:imageBtn];
                NSLayoutConstraint *topConstraint = [self getObjectTopLayoutConstraintWithObject:imageBtn];
                leftConstraint.constant = 20 + (IMAGEVIEWWIDTH + 10) * (i%3);
                topConstraint.constant = 10 + (IMAGEVIEWWIDTH + 10) * (i/3);
                imageBtn.tag = i;
            }
            [self addImageViewButtonLayout];
            [self showAnimateWhenChangeConstraint];
        }
    }
}

#pragma mark - PhotosViewsDatasource's  methods

- (NSInteger)photosViewNumberOfCount
{
    return [self.assets count];
}

- (UIImage *)photosViewImageAtIndex:(NSInteger)index
{
//    ALAsset *asset = [self.assets objectAtIndex:index];
//    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
//    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage] scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
//    return fullScreenImage;
    NSData *photoData = [NSData dataWithContentsOfFile:[_photoFilePathArray objectAtIndex:index]];
    return (UIImage *)[UIImage imageWithData:photoData];
}

- (NSString *)photosViewUrlAtIndex:(NSInteger)index
{
    return nil;//[_photoFilePathArray objectAtIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
