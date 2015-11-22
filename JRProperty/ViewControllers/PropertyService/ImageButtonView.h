//
//  ImageButtonView.h
//  JRProperty
//
//  Created by duwen on 14/11/28.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageButtonViewDelegate <NSObject>

@optional
/**
 *  展示大图
 *
 *  @param tag 点击图片标示
 */
- (void)showLargeImageViewWithTag:(int)tag;

/**
 *  删除图片
 *
 *  @param tag 删除图片标示
 */
- (void)deleteSelectedImageViewWithTag:(int)tag;

@end

@interface ImageButtonView : UIView

@property (strong, nonatomic) id <ImageButtonViewDelegate>delegate;
@property (strong,nonatomic)UIImageView *imageView;     // 背景图
@property (strong,nonatomic)UIButton    *imageButton;   // 背景图点击按钮
@property (strong,nonatomic)UIButton    *deleteButton;  // 删除按钮

@end
