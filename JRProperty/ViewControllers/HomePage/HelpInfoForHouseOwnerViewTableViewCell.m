//
//  HelpInfoForHouseOwnerViewTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "HelpInfoForHouseOwnerViewTableViewCell.h"
#import "JRDefine.h"
@implementation HelpInfoForHouseOwnerViewTableViewCell

- (void)setFrame:(CGRect)frame{
    if (CURRENT_VERSION < 7.0f) {
        frame.origin.x -= 15;
        frame.size.width += 30;
    }
    [super setFrame:frame];
}
- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundView:[[UIView alloc] init]];
    [_plotPhoneLabel setTextColor:UIColorFromRGB(0x666666)];
    [_plotAddressLabel setTextColor:UIColorFromRGB(0x666666)];
    [_plotPhoneButton setImage:[UIImage imageNamed:@"bianming_btn_call_press"] forState:UIControlStateHighlighted];
}

- (void)refrashDataWithHelpInfoModel:(HelpInfoModel *)helpInfoModel{
    _plotNameLabel.text = helpInfoModel.name;
    _plotPhoneLabel.text = helpInfoModel.tel;
    _plotAddressLabel.text = helpInfoModel.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
