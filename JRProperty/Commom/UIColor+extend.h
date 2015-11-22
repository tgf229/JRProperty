//
//  UIColor+extend.h
//  DealExtreme
//
//  Created by ccg on 10-8-30.
//  Copyright 2010 epro. All rights reserved.
//扩展UIColor类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 扩展UIColor类
@interface UIColor(extend)

/*
 将十六进制的颜色值转为objective-c的颜色
 */
+ (id)getColor:(NSString *) hexColor;

@end
