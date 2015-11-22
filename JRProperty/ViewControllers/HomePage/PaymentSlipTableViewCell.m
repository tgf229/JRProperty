//
//  PaymentSlipTableViewCell.m
//  JRProperty
//
//  Created by dw on 14/12/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PaymentSlipTableViewCell.h"
#import "JRDefine.h"
@implementation PaymentSlipTableViewCell

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
    [_nameLabel setTextColor:UIColorFromRGB(0x000000)];
    [_priceLabel setTextColor:UIColorFromRGB(0xcc2a1e)];
    [_timeLabel setTextColor:UIColorFromRGB(0x666666)];
    [_stausLabel setTextColor:UIColorFromRGB(0x666666)];
}


- (void)refrashDataWithChargeModel:(ChargeModel *)chargeModel{
    _nameLabel.text = chargeModel.hName;
    
    if ([@"" isEqualToString:chargeModel.time]||chargeModel.time==nil) {
        _timeLabel.text = @"";
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormatter dateFromString:chargeModel.time];
        [dateFormatter setDateFormat:@"yy年MM月dd日"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        _timeLabel.text = strDate;
    }
    
    
    if ([@"1" isEqualToString:chargeModel.type]) {
        _headImageView.image = [UIImage imageNamed:@"mybill_jiaofei_icon_wuye"];
    }else if ([@"2" isEqualToString:chargeModel.type]){
        _headImageView.image = [UIImage imageNamed:@"mybill_jiaofei_icon_chewei"];
    }else{
        _headImageView.image = [UIImage imageNamed:@"mybill_jiaofei_icon_fentan"];
    }
    
    _priceLabel.text = [@"0" isEqualToString:chargeModel.money]?chargeModel.money:[NSString stringWithFormat:@"- %@",chargeModel.money];;
    
    _stausLabel.text = @"交易成功";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
