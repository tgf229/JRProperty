//
//  MyHouseTableViewCell.m
//  JRProperty
//
//  Created by liugt on 14/11/14.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyHouseTableViewCell.h"
#import "UIView+Additions.h"

@implementation MyHouseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)updateSperatorLineLeadingConstraint:(NSUInteger)constant
{
    NSLayoutConstraint *constrait = [self.speratorLine findConstraintForAttribute:NSLayoutAttributeLeading];
    constrait.constant = constant;
    [self layoutIfNeeded];
}

- (IBAction)editButtonPressed:(id)sender
{
    if (self.editButtonPressedBlock) {
        self.editButtonPressedBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
