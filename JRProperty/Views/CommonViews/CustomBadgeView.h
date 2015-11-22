//
//  CustomBadgeView.h
//  CenterMarket
//
//  Created by dawei on 14-5-15.
//  Copyright (c) 2014年 yurun. All rights reserved.
//  自定义小图标

#import <UIKit/UIKit.h>

@interface CustomBadgeView : UIView
@property (nonatomic, strong) UILabel  * numLabel;

/**
 *  设置badge值
 *
 *  @param strValue 数值
 */
-(void)setBadeValue:(NSString*)strValue;
@end
