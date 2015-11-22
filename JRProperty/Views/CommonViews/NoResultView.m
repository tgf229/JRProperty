//
//  NoResultView.m
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "NoResultView.h"
#import "UIColor+extend.h"
@implementation NoResultView

-(void)initialWithTipText:(NSString *)tipText {
    [self setBackgroundColor:[UIColor getColor:@"eeeeee"]];
    self.tipLabel.textColor = [UIColor getColor:@"666666"];
    self.tipLabel.text = tipText;
}

@end
