//
//  ExpressMessageTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ExpressMessageTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"

@implementation ExpressMessageTableViewCell

- (void)setFrame:(CGRect)frame{
    if (CURRENT_VERSION < 7.0f) {
        frame.origin.x -= 15;
        frame.size.width += 30;
    }
    [super setFrame:frame];
}

- (void)awakeFromNib {
    // Initialization code
    _logoImageView.layer.borderColor = RGB(238, 238, 238).CGColor;
    _logoImageView.layer.borderWidth = 1.0;
    [_expressTimeLabel setTextColor:UIColorFromRGB(0x666666)];
    [_orderNumberLabel setTextColor:UIColorFromRGB(0x666666)];
    [self setBackgroundView:[[UIView alloc] init]];
}

- (void)refrashDataWithPackageModel:(PackageModel *)packageModel{
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:packageModel.logo] placeholderImage:[UIImage imageNamed:@"community_default"]];
    _expressNameLabel.text = packageModel.hName;
    
    if ([@"" isEqualToString:packageModel.time]||packageModel.time==nil) {
        _expressTimeLabel.text = @"";
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormatter dateFromString:packageModel.time];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        _expressTimeLabel.text = strDate;
    }
    
    _orderNumberLabel.text = [NSString stringWithFormat:@"物流单号：%@",packageModel.num];
    if ([@"1" isEqualToString:packageModel.type]) {
        // 待领取
        _tipImageVew.image = [UIImage imageNamed:@"service_icon_processing"];
        _tipLabel.text = @"待领取";
    }else{
        // 已领取
        _tipImageVew.image = [UIImage imageNamed:@"service_icon_complete"];
        _tipLabel.text = @"已领取";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
