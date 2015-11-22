//
//  PageNumView.h
//  CenterMarket
//
//  Created by 周光 on 14-7-9.
//  Copyright (c) 2014年 yurun. All rights reserved.
//  显示图片的num公共类

#import <UIKit/UIKit.h>

@interface PageNumView : UIView


@property (nonatomic,assign) BOOL   blackGroundFlag;            //是否是黑色背景，否则就是白色的


@property (nonatomic,assign) int countNum;                      //总个数




@property (nonatomic,assign) int currentPage;                   //当前个数





@end
