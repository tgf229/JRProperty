//
//  CustomBadgeView.m
//  CenterMarket
//
//  Created by dawei on 14-5-15.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "CustomBadgeView.h"
#import "JRDefine.h"
@implementation CustomBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图片
        UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        bgImageView.image = [UIImage imageNamed:@"bottom_number_bg_36x36"];
        //设置图片为圆形
        //bgImageView.layer.masksToBounds = YES;
        //bgImageView.layer.cornerRadius = bgImageView.frame.size.height/2.0;
        [self addSubview:bgImageView];
        
        //badge数值
        UILabel * tmpNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        self.numLabel = tmpNumLabel;
        self.numLabel.backgroundColor = [UIColor clearColor];
        [self.numLabel setFont:[UIFont systemFontOfSize:10]];
        self.numLabel.textColor = UIColorFromRGB(0xcc2a1e);
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [bgImageView addSubview:self.numLabel];
    }
    return self;
}
/**
 *  为badge设置值
 *
 *  @param strValue 数值
 */
-(void)setBadeValue:(NSString*)strValue{
    if([@"" isEqualToString:strValue]|| [strValue intValue]==0){
        self.hidden = YES;
    }else{
        self.numLabel.text = strValue;
        self.hidden = NO;
    }
}


@end
