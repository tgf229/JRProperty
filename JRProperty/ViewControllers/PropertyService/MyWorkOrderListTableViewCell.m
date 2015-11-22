//
//  MyWorkOrderListTableViewCell.m
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyWorkOrderListTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"

@implementation MyWorkOrderListTableViewCell
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
    [_timeLabel setTextColor:UIColorFromRGB(0x666666)];
    [_nameLabel setTextColor:UIColorFromRGB(0x666666)];
    _timeLabel.text = @"";
    _nameLabel.text = @"";
    _workOrderInfoLabel.text = @"";
    _workOrderNumberLabel.text = @"";
    _stausLabel.text = @"";
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 12.5;
}

- (void)refrashDataWithWorkOrderModel:(WorkOrderModel *)workOrderModel{
    if ([@"1" isEqualToString:workOrderModel.type]) {
        // 保修
        _typeImageView.image = [UIImage imageNamed:@"service_icon_round_repair"];
    }else if ([@"2" isEqualToString:workOrderModel.type]){
        // 投诉
        _typeImageView.image = [UIImage imageNamed:@"service_icon_round_complaint"];
    }else if ([@"3" isEqualToString:workOrderModel.type]){
        // 表扬
        _typeImageView.image = [UIImage imageNamed:@"service_icon_round_thank"];
    }else if([@"4" isEqualToString:workOrderModel.type]){
        // 求助
        _typeImageView.image = [UIImage imageNamed:@"service_icon_round_help"];
    }
    else{
        // 建议
        _typeImageView.image = [UIImage imageNamed:@"service_icon_round_suggest"];
    }
    _workOrderNumberLabel.text = [NSString stringWithFormat:@"%@",workOrderModel.id];
    _workOrderInfoLabel.text = [NSString stringWithFormat:@"%@",workOrderModel.content];
    
    switch ([workOrderModel.status intValue]) {
        case 1:
            // 待处理
            _stausImageView.image = [UIImage imageNamed:@"service_icon_untreated"];
            _stausLabel.text = @"待处理";
            break;
        case 2:
            // 处理中
            _stausImageView.image = [UIImage imageNamed:@"service_icon_processing"];
            _stausLabel.text = @"处理中";
            break;
        case 3:
            // 已处理
            _stausImageView.image = [UIImage imageNamed:@"service_icon_yichuli"];
            _stausLabel.text = @"已处理";
            break;
        case 4:
            // 已完成
            _stausImageView.image = [UIImage imageNamed:@"service_icon_complete"];
            _stausLabel.text = @"已完成";
            break;
        default:
            break;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:workOrderModel.time];
    [dateFormatter setDateFormat:@"yy年MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    _timeLabel.text = strDate;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:workOrderModel.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    _nameLabel.text = workOrderModel.nickName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
