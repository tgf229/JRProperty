//
//  YLTabBar.m
//  YLRiseTabBarDemo
//
//  Created by 杨立 on 15/10/22.
//  Copyright (c) 2015年 杨立. All rights reserved.
//

#import "YLTabBar.h"
#import "UIView+Extension.h"

@implementation YLTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIButton *publishButton = [[UIButton alloc] init];
    [publishButton setBackgroundImage:[UIImage imageNamed:@"home_icon_us"] forState:UIControlStateNormal];
    [self addSubview:publishButton];
    publishButton.size = publishButton.currentBackgroundImage.size;
    publishButton.x = self.width / 3.0 * 2-15;
    publishButton.centerY = 49/ 2 ;
    
    //设置其他按钮位置
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0, j = 0; i < count; i++) {
        UIView *child = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
                child.width = self.width / 2.0 / 3.0;
                child.x = self.width * j / 2.0 / 3.0;
                child.centerY = 49 / 2 + 7;
            j++;
        }
    }
}

@end
