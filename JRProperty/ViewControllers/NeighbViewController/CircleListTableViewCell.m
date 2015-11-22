//
//  CircleListTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "CircleListTableViewCell.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "JRDefine.h"
@implementation CircleListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (self != nil) {
            [self awakeFromNib];
        }
    }
    
    return self;
}
- (void)awakeFromNib {
    self.nameLabel.textColor = [UIColor getColor:@"bb474d"];
    self.numberLabel.textColor = [UIColor getColor:@"666666"];
    self.contentLabel.textColor = [UIColor getColor:@"666666"];
    
}
- (void)setType:(NSInteger)type {
    self.circleType = type;
    
}
- (void)isLastRow:(BOOL)isLast {
    self.isLast = isLast;
}
- (void)setData:(CircleInfoModel *)data {
    NSString *str = [NSString stringWithFormat:@"%@关注  %@发帖",data.userCount,data.articleCount];
    self.numberLabel.text =str;
    self.nameLabel.text = data.name;
    
    if (self.circleType == kMyManageCircle) {
        
        NSString *time ;
        if (data.time.length >= 14) {
            time =[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",[data.time substringWithRange:NSMakeRange(0,4)],[data.time substringWithRange:NSMakeRange(4,2)],[data.time substringWithRange:NSMakeRange(6,2)],[data.time substringWithRange:NSMakeRange(8,2)],[data.time substringWithRange:NSMakeRange(10,2)],[data.time substringWithRange:NSMakeRange(12,2)]];
        }

        self.contentLabel.text = [NSString stringWithFormat:@"创建时间: %@",time];
    }
    else {
        if (data.desc.length == 0) {
            self.contentLabel.text = @"公告: ";
        }
        else {
            self.contentLabel.text = [NSString stringWithFormat:@"公告: %@",data.desc];

        }
    }
    [self.iconImageView sd_setImageWithURL: [NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"community_default"]];
    if (self.isLast) {
        [self.shortLine setHidden:YES];
        [self.longLine setHidden:NO];
    }
    else {
        [self.shortLine setHidden:NO];
        [self.longLine setHidden:YES];
    }
}

@end
