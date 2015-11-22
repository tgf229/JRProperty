//
//  UIButton+Addtions.h
//  CenterMarket
//
//  Created by 周光 on 14-5-16.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton* btn);

@interface UIButton (Addtions)
/**
 *  设置UIButton的动作
 *
 *  @param block 动作所触发的函数,Event默认为：UIControlEventTouchUpInside
 */
- (void)addAction:(ButtonBlock)block;



/**
 *  设置UIButton的动作
 *
 *  @param block         动作所触发的函数
 *  @param controlEvents Event
 */
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents;

/**
 *  扩展UIButton的作用区域，扩展大小为edge
 *
 *  @param edge 设置向四个方向扩展edge的大小
 */
- (void) setEnlargeEdge:(CGFloat) edge;



/**
 *  扩展UIButton的作用区域，扩展大小为edge
 *
 *  @param top    向上的大小
 *  @param right  向右的大小
 *  @param bottom 向下的大小
 *  @param left   向左的大小
 */
- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
