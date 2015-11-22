//
//  PhotoView.h
//  CenterMarket
//
//  Created by 周光 on 14-7-7.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView
@property (nonatomic,copy)void (^singleRecognizerTapBlock)();

@property(nonatomic)float maxScale;//放大倍率（默认为放大2倍）


/**
 *  还原放大缩小倍率
 */
- (void)resetScale;



/**
 *  初始化图片的url和默认图片
 *
 *  @param url
 *  @param image 
 */
- (void)initWithUrl:(NSString *)url  placeholderImage:(UIImage *)image;



/**
 *  初始化 （主要用于本地图片）
 *
 *  @param image 图片
 */
- (void)initWithImage:(UIImage *)image;
@end
