//
//  HouseInfoTableViewCell.m
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HouseInfoTableViewCell.h"
#import "UIColor+extend.h"
#import "UIView+Additions.h"

@implementation HouseInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // 头像圆形
    self.portraitView.layer.masksToBounds = YES;
    self.portraitView.layer.cornerRadius = 20;
    self.portraitView.userInteractionEnabled = NO;
    
    self.levelButton.userInteractionEnabled = NO;

}

- (void)updateUserLevel:(NSString *)level withStatus:(NSString *)status
{
    if ([level isEqualToString:@"1"]) {
        // 业主
        self.statuButton.hidden = YES;

        [self.levelButton setBackgroundImage:[UIImage imageNamed:@"myhome_textico_owner"] forState:UIControlStateNormal];
        [self.levelButton setTitle:@"业主" forState:UIControlStateNormal];
        [self.levelButton setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
        [self.statuButton setTitleColor:[UIColor getColor:@"3ab5c4"] forState:UIControlStateNormal];
    }
    else{
        self.statuButton.hidden = NO;
        [self.levelButton setTitle:@"住户" forState:UIControlStateNormal];
        [self.levelButton setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
        
        if ([status isEqualToString:@"0"]) {
            // 冻结状态的住户
            [self.levelButton setBackgroundImage:[UIImage imageNamed:@"myhome_textico_household_freeze"] forState:UIControlStateNormal];
            [self.statuButton setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
        }
        else if ([status isEqualToString:@"1"])
        {
            // 正常状态的住户
            [self.levelButton setBackgroundImage:[UIImage imageNamed:@"myhome_textico_household"] forState:UIControlStateNormal];
            [self.statuButton setTitleColor:[UIColor getColor:@"3ab5c4"] forState:UIControlStateNormal];
        }
    }

}

- (void)updateUserCellEditView:(BOOL)isEdit withStatus:(NSString *)status
{
    if (isEdit) {
        // 编辑状态
        [self.statuButton setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
        [self.statuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        if([status isEqualToString:@"1"])
        {
            [self.statuButton setTitle:@"冻结" forState:UIControlStateNormal];

            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_delete_104x56"] forState:UIControlStateNormal];
            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_delete_104x56_press"] forState:UIControlStateHighlighted];
            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_delete_104x56_press"] forState:UIControlStateSelected];
        }
        else
        {
            [self.statuButton setTitle:@"恢复" forState:UIControlStateNormal];

            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_recover_104x56"] forState:UIControlStateNormal];
            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_recover_104x56_press"] forState:UIControlStateHighlighted];
            [self.statuButton setBackgroundImage:[UIImage imageNamed:@"myhome_text_btn_recover_104x56_press"] forState:UIControlStateSelected];
        }
    }
    else{
        // 展示状态
        [self.statuButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.statuButton setTitle:[status isEqualToString:@"1"] ? @"正常" : @"冻结" forState:UIControlStateNormal];
        [self.statuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }

}

- (void)updateSperatorLineLeadingConstraint:(NSUInteger)constant
{
    NSLayoutConstraint *constrait = [self.speratorLine findConstraintForAttribute:NSLayoutAttributeLeading];
    constrait.constant = constant;
    [self layoutIfNeeded];
}


- (IBAction)statusButtonPressed:(id)sender
{
    if (self.statuButtonBlock) {
        self.statuButtonBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
