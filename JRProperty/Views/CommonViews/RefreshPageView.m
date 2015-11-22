//
//  RefreshPageView.m
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "RefreshPageView.h"
#import "UIColor+extend.h"

@implementation RefreshPageView


-(void)initial {
    [self setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    self.tipLabel.textColor = [UIColor getColor:@"666666"];
}

- (IBAction)refreshButtonClick:(id)sender {
    if (self.callBackBlock) {
        self.callBackBlock();
    }
}

@end
