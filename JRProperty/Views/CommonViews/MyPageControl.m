//
//  MyPageControl.m
//  CenterMarket
//
//  Created by 郑小贺 on 13-11-5.
//  Copyright (c) 2013年 yurun. All rights reserved.
//

#import "MyPageControl.h"

@interface MyPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用
- (void)updateDots;
@end


@implementation MyPageControl  // 实现部分


@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;


- (id)initWithFrame:(CGRect)frame
{ // 初始化
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}


- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    imagePageStateHighlighted = image;
    [self updateDots];
}


- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    imagePageStateNormal = image;
    [self updateDots];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}
/**
 *  更新按钮图片
 */
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:[self.subviews objectAtIndex: i]];
        if (i == self.currentPage)
            dot.image = imagePageStateNormal;
        else
            dot.image = imagePageStateHighlighted;
    }
}
- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            dot.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

@end