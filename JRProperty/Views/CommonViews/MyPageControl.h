//
//  MyPageControl.h
//  CenterMarket
//
//  Created by 郑小贺 on 13-11-5.
//  Copyright (c) 2013年 yurun. All rights reserved.
//  自定义pagecontrol

#import <UIKit/UIKit.h>


@interface MyPageControl : UIPageControl
{
    UIImage *imagePageStateNormal; //正常状态点按钮的图片
    UIImage *imagePageStateHighlighted;//高亮状态点按钮图片
}

/*
    初始化
 */
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, strong) UIImage *imagePageStateNormal;//正常状态点按钮的图片
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;//高亮状态点按钮图片

@end
