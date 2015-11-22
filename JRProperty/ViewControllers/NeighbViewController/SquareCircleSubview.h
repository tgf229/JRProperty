//
//  SquareCircleSubview.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"
@class SquareCircleSubview;
@protocol CircleSubviewDelegate <NSObject>
/**
 *  点击小图进入圈子详情
 *
 *  @param circleId 圈子id
 */
-(void) imageClick:(SquareCircleSubview *)circleSubView withCircleId:(NSString *)circleId circleName:(NSString *)circleName;

@end

@interface SquareCircleSubview : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong,nonatomic) CircleInfoModel  *data;
@property (weak, nonatomic) id<CircleSubviewDelegate> delegate; //代理
- (void)setData:(CircleInfoModel *)data;
-(void)initial;
- (IBAction)gotoCircleDetail:(id)sender;

@end
