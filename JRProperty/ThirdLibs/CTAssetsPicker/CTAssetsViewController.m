/*
 CTAssetsViewController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "CTAssetsPickerCommon.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsViewController.h"
#import "CTAssetsViewCell.h"
#import "CTAssetsSupplementaryView.h"
#import "CTAssetsPageViewController.h"
#import "CTAssetsViewControllerTransition.h"
#import "PhotosViewController.h"
#import "CustomBadgeView.h"





NSString * const CTAssetsViewCellIdentifier = @"CTAssetsViewCellIdentifier";
NSString * const CTAssetsSupplementaryViewIdentifier = @"CTAssetsSupplementaryViewIdentifier";



@interface CTAssetsPickerController ()

- (void)finishPickingAssets:(id)sender;

- (NSString *)toolbarTitle;
- (UIView *)noAssetsView;

@end



@interface CTAssetsViewController ()<PhotosViewDatasource,PhotosViewDelegate>
{
    NSMutableArray *_assetsImageArray;
    UIButton       *_previewButton;
    BOOL           _isPreviewBack;
}

@property (nonatomic, weak)   CTAssetsPickerController *picker;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) CustomBadgeView  *photoCountView;  //选择的图片个数


@end





@implementation CTAssetsViewController


- (id)init
{
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutOfOrientation:self.interfaceOrientation];
    
    if (self = [super initWithCollectionViewLayout:layout])
    {
        self.collectionView.allowsMultipleSelection = YES;
        
        [self.collectionView registerClass:CTAssetsViewCell.class
                forCellWithReuseIdentifier:CTAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:CTAssetsSupplementaryView.class
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:CTAssetsSupplementaryViewIdentifier];
        
        self.preferredContentSize = CTAssetPickerPopoverContentSize;
    }
    
    [self addNotificationObserver];
    [self addGestureRecognizer];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _assetsImageArray = [[NSMutableArray alloc] init];
    
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupButtons];
    [self setupToolbar];
    [self setupAssets];
}

- (void)dealloc
{
    [self removeNotificationObserver];
}


#pragma mark - Accessors

- (CTAssetsPickerController *)picker
{
    return (CTAssetsPickerController *)self.navigationController.parentViewController;
}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayoutOfOrientation:toInterfaceOrientation];
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}


#pragma mark - Setup

/**
 *  添加预览和完成按钮
 */
- (void)setupViews
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)setupButtons
{
    //左键返回相册按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [backBtn setFrame:CGRectMake(0, 0, 20, 20)];
    } else {
        [backBtn setFrame:CGRectMake(0, 0, 20 + 22, 20)];
    }
    [backBtn setImage:[UIImage imageNamed:@"return_40x40"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_40x40_press"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"相册" forState:UIControlStateNormal];
    [backBtn setTitle:@"相册" forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(leftBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //设置导航栏
    UILabel * myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [myTitleLabel setBackgroundColor:[UIColor clearColor]];
    myTitleLabel.font = [UIFont systemFontOfSize:20];
    myTitleLabel.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];;
    self.navigationItem.titleView = myTitleLabel;
    
    //右键取消按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        rightButton.frame = CGRectMake(0, 0, 40 + 22, 28);
    } else {
        rightButton.frame = CGRectMake(0, 0, 40, 28);
    }
    [rightButton setTitleEdgeInsets: UIEdgeInsetsMake(0, -14, 0, 0)];
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor getColor:@"bb474d"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor getColor:@"000000"] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    [rightButton setImage:[UIImage imageNamed:@"complaints_btn_right_108x56"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"complaints_btn_right_108x56_press"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(cancelPhotoPicker:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
    rightItem.customView = rightButton;
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  返回相册
 *
 *  @param sender 返回按钮
 */
- (void)leftBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  取消按钮响应
 *
 *  @param sender 取消按钮
 */
- (void)cancelPhotoPicker:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


- (void)setupToolbar
{
    UIBarButtonItem *previewItem = [self previewButtonItem];
    UIBarButtonItem *doneItem = [self doneButtonItem];
    
    if (_isPreviewBack) {
        _isPreviewBack = NO;
    }
    else{
        [self.picker.selectedAssets removeAllObjects];
    }
    
    self.toolbarItems = @[previewItem, [self.picker.toolbarItems objectAtIndex:1], doneItem];
    [self.navigationController setToolbarHidden:(self.picker.selectedAssets.count == 0) animated:YES];
}

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        return;
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            BOOL shouldShowAsset;
            
            if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldShowAsset:)])
                shouldShowAsset = [self.picker.delegate assetsPickerController:self.picker shouldShowAsset:asset];
            else
                shouldShowAsset = YES;
            
            if (shouldShowAsset)
                [self.assets addObject:asset];
        }
        else
        {
            [self reloadData];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}


- (UIBarButtonItem *)previewButtonItem
{
    UIButton *previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previewButton.frame = CGRectMake(15, 10, 70, 32);
    previewButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitle:@"预览" forState:UIControlStateHighlighted];
    [previewButton setTitleColor:[UIColor getColor:@"e84b06"] forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor getColor:@"e84b06"] forState:UIControlStateHighlighted];
    [previewButton setBackgroundImage:[UIImage imageNamed:@"picture_btn_look_140x64"] forState:UIControlStateNormal];
    [previewButton setBackgroundImage:[UIImage imageNamed:@"picture_btn_look_140x64_press"] forState:UIControlStateHighlighted];
    [previewButton addTarget:self action:@selector(previewPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:previewButton];
    
}

- (UIBarButtonItem *)doneButtonItem
{
    //添加完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(CTScreenSize.width - 85, 10, 70, 32);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
    [doneButton setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"picture_btn_complete_140x64"] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"picture_btn_complete_140x64_press"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    
    CustomBadgeView *tempCountView = [[CustomBadgeView alloc] initWithFrame:CGRectMake(doneButton.bounds.size.width/2+25, -2, 18, 18)];
    self.photoCountView = tempCountView;
    [doneButton addSubview:tempCountView];
    [self.photoCountView setBadeValue:nil];
    
    return [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

#pragma mark - Actions
/**
 *  预览选中的照片
 *
 *  @param sender 预览按钮
 */
- (void)previewPickingAssets:(id)sender
{    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
    {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
        ALAssetRepresentation *representation = asset.defaultRepresentation;
        UIImage *image = [UIImage imageWithCGImage:representation.fullResolutionImage
                                             scale:1.0f
                                       orientation:(UIImageOrientation)representation.orientation];
        [_assetsImageArray addObject:image];
    }
    
    PhotosViewController *photosController = [[PhotosViewController alloc] init];
    photosController.datasource = self;
    photosController.currentPage = 0;
    photosController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:photosController animated:YES];
    _isPreviewBack = YES;
}

/**
 *  完成照片选择
 *
 *  @param sender
 */
- (void)finishPickingAssets:(id)sender
{
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didFinishPickingAssets:)])
    {
        [self.picker.delegate assetsPickerController:self.picker didFinishPickingAssets:self.picker.selectedAssets];
    }
}



#pragma mark -
#pragma mark - PhotosViewsDatasource's  methods 大图预览

- (NSInteger)photosViewNumberOfCount
{
    return [_assetsImageArray count];
}

- (UIImage *)photosViewImageAtIndex:(NSInteger)index
{
    return (UIImage *)[_assetsImageArray objectAtIndex:index];
}

- (NSString *)photosViewUrlAtIndex:(NSInteger)index
{
    return nil;
}

#pragma mark - Collection View Layout

- (UICollectionViewFlowLayout *)collectionViewFlowLayoutOfOrientation:(UIInterfaceOrientation)orientation
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize             = CTAssetThumbnailSize;
    layout.footerReferenceSize  = CGSizeMake(0, 47.0);
    
    if (UIInterfaceOrientationIsLandscape(orientation) && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad))
    {
        layout.sectionInset            = UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);
        layout.minimumInteritemSpacing = (CTIPhone6Plus) ? 1.0 : ( (CTIPhone6) ? 2.0 : 3.0 );
        layout.minimumLineSpacing      = (CTIPhone6Plus) ? 1.0 : ( (CTIPhone6) ? 2.0 : 3.0 );
    }
    else
    {
        layout.sectionInset            = UIEdgeInsetsMake(9.0, 0, 0, 0);
        layout.minimumInteritemSpacing = (CTIPhone6Plus) ? 0.5 : ( (CTIPhone6) ? 1.0 : 2.0 );
        layout.minimumLineSpacing      = (CTIPhone6Plus) ? 0.5 : ( (CTIPhone6) ? 1.0 : 2.0 );
    }
    
    return layout;
}


#pragma mark - Notifications

- (void)addNotificationObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(assetsLibraryChanged:)
                   name:ALAssetsLibraryChangedNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(selectedAssetsChanged:)
                   name:CTAssetsPickerSelectedAssetsChangedNotification
                 object:nil];
}

- (void)removeNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CTAssetsPickerSelectedAssetsChangedNotification object:nil];
}


#pragma mark - Assets Library Changed

- (void)assetsLibraryChanged:(NSNotification *)notification
{
    // Reload all assets
    if (notification.userInfo == nil)
        [self performSelectorOnMainThread:@selector(reloadAssets) withObject:nil waitUntilDone:NO];
    
    // Reload effected assets groups
    if (notification.userInfo.count > 0)
        [self reloadAssetsGroupForUserInfo:notification.userInfo];
}


#pragma mark - Reload Assets Group

- (void)reloadAssetsGroupForUserInfo:(NSDictionary *)userInfo
{
    NSSet *URLs = [userInfo objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
    NSURL *URL  = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", URL];
    NSArray *matchedGroups = [URLs.allObjects filteredArrayUsingPredicate:predicate];
    
    // Reload assets if current assets group is updated
    if (matchedGroups.count > 0)
        [self performSelectorOnMainThread:@selector(reloadAssets) withObject:nil waitUntilDone:NO];
}



#pragma mark - Selected Assets Changed

- (void)selectedAssetsChanged:(NSNotification *)notification
{
    NSArray *selectedAssets = (NSArray *)notification.object;
    
    [[self.toolbarItems objectAtIndex:1] setTitle:[self.picker toolbarTitle]];
    
    [self.photoCountView setBadeValue:[NSString stringWithFormat:@"%lu",(unsigned long)selectedAssets.count]];

    
    [self.navigationController setToolbarHidden:(selectedAssets.count == 0) animated:YES];
}



#pragma mark - Gesture Recognizer

- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pushPageViewController:)];
    
    [self.collectionView addGestureRecognizer:longPress];
}


#pragma mark - Push Assets Page View Controller

- (void)pushPageViewController:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point           = [longPress locationInView:self.collectionView];
        NSIndexPath *indexPath  = [self.collectionView indexPathForItemAtPoint:point];

        CTAssetsPageViewController *vc = [[CTAssetsPageViewController alloc] initWithAssets:self.assets];
        vc.pageIndex = indexPath.item;

        [self.navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - Reload Assets

- (void)reloadAssets
{
    self.assets = nil;
    [self setupAssets];
}



#pragma mark - Reload Data

- (void)reloadData
{
    if (self.assets.count > 0)
    {
        [self.collectionView reloadData];
        
        if (self.collectionView.contentOffset.y <= 0)
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionViewLayout.collectionViewContentSize.height)];
    }
    else
    {
        [self showNoAssets];
    }
}


#pragma mark - No assets

- (void)showNoAssets
{
    self.collectionView.backgroundView = [self.picker noAssetsView];
    [self setAccessibilityFocus];
}

- (void)setAccessibilityFocus
{
    self.collectionView.isAccessibilityElement  = YES;
    self.collectionView.accessibilityLabel      = self.collectionView.backgroundView.accessibilityLabel;
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.collectionView);
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:CTAssetsViewCellIdentifier
                                              forIndexPath:indexPath];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldEnableAsset:)])
        cell.enabled = [self.picker.delegate assetsPickerController:self.picker shouldEnableAsset:asset];
    else
        cell.enabled = YES;
    
    // XXX
    // Setting `selected` property blocks further deselection.
    // Have to call selectItemAtIndexPath too. ( ref: http://stackoverflow.com/a/17812116/1648333 )
    if ([self.picker.selectedAssets containsObject:asset])
    {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [cell bind:asset];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsSupplementaryView *view =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                       withReuseIdentifier:CTAssetsSupplementaryViewIdentifier
                                              forIndexPath:indexPath];
    
    [view bind:self.assets];
    
    if (self.assets.count == 0)
        view.hidden = YES;
    
    return view;
}


#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    CTAssetsViewCell *cell = (CTAssetsViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.isEnabled)
        return NO;
    else if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldSelectAsset:)])
        return [self.picker.delegate assetsPickerController:self.picker shouldSelectAsset:asset];
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    [self.picker selectAsset:asset];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didSelectAsset:)])
        [self.picker.delegate assetsPickerController:self.picker didSelectAsset:asset];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldDeselectAsset:)])
        return [self.picker.delegate assetsPickerController:self.picker shouldDeselectAsset:asset];
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    [self.picker deselectAsset:asset];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didDeselectAsset:)])
        [self.picker.delegate assetsPickerController:self.picker didDeselectAsset:asset];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:shouldHighlightAsset:)])
        return [self.picker.delegate assetsPickerController:self.picker shouldHighlightAsset:asset];
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didHighlightAsset:)])
        [self.picker.delegate assetsPickerController:self.picker didHighlightAsset:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.picker.delegate respondsToSelector:@selector(assetsPickerController:didUnhighlightAsset:)])
        [self.picker.delegate assetsPickerController:self.picker didUnhighlightAsset:asset];
}


@end