//
//  CircleView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-23.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleView;
#import "SquareCircleSubview.h"

@protocol CircleViewDelegate <NSObject>
/**
 *  点击小图进入圈子详情
 *
 *  @param circleId 圈子id
 */
-(void) imageClick:(CircleView *)circleView withCircleId:(NSString *)circleId circleName:(NSString *)circleName;

@end
@interface CircleView : UIView<CircleSubviewDelegate>
@property (weak, nonatomic) id<CircleViewDelegate> delegate; //代理
+(CGFloat) height;
- (void)setData:(NSArray *)circleList;
@end
