//
//  PopShareBtnView.m
//  CenterMarket
//
//  Created by liugt on 14-8-18
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "PopSocialShareView.h"
#import "UIShareItemButton.h"
#import "SVProgressHUD.h"

//当前设备屏幕高度
#define UIScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define UIScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define RETINA4        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define CURRENT_VERSION [[UIDevice currentDevice].systemVersion floatValue]


@interface PopSocialShareView()

@property (nonatomic,strong) UIToolbar *toolbar;
@property (nonatomic,copy)   NSArray   *socialArray;

@end

@implementation PopSocialShareView


/**
 *  根据传入的sns平台数组展示
 *
 *  @param frame       view的frame
 *  @param socialArray sns平台数组
 *
 *  @return id
 */
- (id)initWithFrame:(CGRect)frame snsArray:(NSArray *)socialArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.toolbar =[[UIToolbar alloc]initWithFrame:frame];
        [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
        
        [self setupBackground];
        
        [self setupShareItems:socialArray];
        
        [self setupCloseButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    //展示全部的分享平台
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.toolbar =[[[UIToolbar alloc]initWithFrame:frame] autorelease];
//        [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
        
        [self setupBackground];
        
        [self setupCloseButton];
        
        [self setupShareItems:nil];
        
    }
    return self;
}

/**
 *  设置背景，有淡入效果，点击后移除分享页面
 */
- (void)setupBackground
{
    UIButton *backGround = [UIButton buttonWithType:UIButtonTypeCustom];
    backGround.contentMode = UIViewContentModeScaleAspectFit;
    backGround.frame = [UIScreen mainScreen].bounds;
    if (UIScreenHeight > 480) {
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg"] forState:UIControlStateNormal];
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg"] forState:UIControlStateSelected];
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg"] forState:UIControlStateHighlighted];
    }
    else{
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg_640x960"] forState:UIControlStateNormal];
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg_640x960"] forState:UIControlStateSelected];
        [backGround setBackgroundImage:[UIImage imageNamed:@"share_allbg_640x960"] forState:UIControlStateHighlighted];
    }
    [backGround addTarget:self action:@selector(removeShareSubView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backGround];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

/**
 *  设置分享按钮区域，按钮按照时间差移动，移动到位置后抖动
 */
- (void)setupShareItems:(NSArray *)snsArray
{
    self.socialArray = [NSArray arrayWithObjects:ShareToWechat,ShareToWechatTimeline,ShareToTencentBlog,ShareToQQ,ShareToQzone,ShareToSms,ShareToRenren,ShareToSinaBlog, nil];
    
    if (snsArray != nil) {
        self.socialArray = snsArray;
    }
    
    int numsProcolumn = 3;   // 每行展示3个
    NSUInteger colNum = ([_socialArray count] + 2)/3;  //展示出来的行数
    CGFloat viewWH = (UIScreenWidth - 35)/3;
    for (int i = 0; i < [_socialArray count]; i ++) {
        int posY = UIScreenHeight - 120 - colNum*viewWH;
        int row = i / numsProcolumn;
        int col = i % numsProcolumn;
        CGFloat margin = (UIScreenWidth - 3*95)/4;
        UIShareItemButton *itemButton = [UIShareItemButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = i + 10;
        itemButton.bounds = CGRectMake(0, 0, 60, 60);
        itemButton.center = CGPointMake( col * 60, row *60);
        itemButton.frame = CGRectMake(margin + (2+viewWH)*col, posY+(11+viewWH)*row, viewWH, viewWH);
        itemButton.nameLabel.text = [_socialArray objectAtIndex:i];
        [itemButton setItemButtonType:itemButton.nameLabel.text];
        [itemButton setItemButtonImageName];
        [itemButton.iconView setImage:[UIImage imageNamed:itemButton.normalImgName]];
        [itemButton addTarget:self action:@selector(socialItemImageSelected:) forControlEvents:UIControlEventTouchDown];
        [itemButton addTarget:self action:@selector(socialItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        
        //设置初始y方向偏移
        CGAffineTransform trans = CGAffineTransformTranslate  (itemButton.transform,  0, (400 + row *viewWH));
        itemButton.transform = trans;
        
        //清空偏移量的动画
        [UIView animateWithDuration:0.25 delay:i/20.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            //清空偏移量
            itemButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //抖动动画
            CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
            shakeAnim.keyPath = @"transform.translation.y";
            shakeAnim.duration = 0.2;
            CGFloat delta = 10;
            shakeAnim.values = @[@0, @(-delta), @(delta), @0];
            shakeAnim.repeatCount = 0;
            [itemButton.layer addAnimation:shakeAnim forKey:nil];
        }];
    }
}

/**
 *  设置关闭按钮，有旋转效果
 */
- (void)setupCloseButton
{
    // 关闭按钮
    UIButton *closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn.layer setMasksToBounds:YES];
    [closeBtn.layer setCornerRadius:25.0f];
    [closeBtn setImage:[UIImage imageNamed:@"share_bottom_btn_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"share_bottom_btn_close_select"] forState:UIControlStateSelected];
    [closeBtn setImage:[UIImage imageNamed:@"share_bottom_btn_close_select"] forState:UIControlStateHighlighted];
    [closeBtn setFrame:CGRectMake((UIScreenWidth- 50)/2, self.frame.size.height-50, 50, 50)];
    [closeBtn addTarget:self action:@selector(removeShareSubView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    CGAffineTransform tf1 = CGAffineTransformMakeRotation(M_PI_2);
    [UIView animateWithDuration:0.5 animations:^{
        closeBtn.transform = tf1; //图片旋转
    }];
}

#pragma  mark - Actions
/**
 *  点击某个社区
 *
 *  @param sender 社区控件
 */
- (void)socialItemSelected:(id)sender
{
    UIShareItemButton *itemButton = (UIShareItemButton *)sender;
    if (itemButton.type == ZYSocialSnsTypeRenRen
        || itemButton.type == ZYSocialSnsTypeSina)
    {
        [SVProgressHUD showErrorWithStatus:@"平台暂未开通"];
        return;
    }
 
    [self socialItemImageUnSelected:itemButton];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectSocialPlatform:)]) {
        [_delegate didSelectSocialPlatform:itemButton.type];
    }
}

/**
 *  button为选择图片
 *
 *  @param sender 社区平台button
 */
- (void)socialItemImageSelected:(id)sender
{
    UIShareItemButton *itemButton = (UIShareItemButton *)sender;

    [itemButton.iconView setImage:[UIImage imageNamed:itemButton.selectImgName]];
}

/**
 *  button为未选择图片
 *
 *  @param sender 社区平台button
 */
- (void)socialItemImageUnSelected:(id)sender
{
    UIShareItemButton *itemButton = (UIShareItemButton *)sender;
    [itemButton.iconView setImage:[UIImage imageNamed:itemButton.normalImgName]];
}

/**
 *  移除社区分享视图，带有移动动画；
 *  社区按钮和关闭按钮参与动画，背景按钮不做移动
 */
- (void)removeShareSubView
{
    NSUInteger snsViewStartIndex = 2;
    NSUInteger snsViewEndIndex = [_socialArray count] + 3;
    if (CURRENT_VERSION < 7.0) {
        snsViewStartIndex = 3;
        snsViewEndIndex = [_socialArray count] + 4;
    }

    [UIView animateWithDuration:0.4 animations:^{
        
        self.alpha = 0;// 淡出
        
        for (NSUInteger i = snsViewStartIndex;i < snsViewEndIndex;i++) {
            UIView *snsItemView = [self.toolbar.subviews objectAtIndex:i];
            snsItemView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

@end
