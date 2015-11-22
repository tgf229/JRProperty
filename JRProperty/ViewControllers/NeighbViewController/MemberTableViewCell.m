//
//  MemberTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "MemberTableViewCell.h"
#import "JRDefine.h"

@implementation MemberTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (self != nil) {
            [self awakeFromNib];
        }
    }
    
    return self;
}
- (void)awakeFromNib {
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 20;
    [self.daVip setHidden:YES];

}

- (void)isLastRow:(BOOL)isLast {
    self.isLast = isLast;
}

- (void)setData:(MemberModel *)data {
    self.nameLabel.text = data.nickName;
    [self.iconImageView sd_setImageWithURL: [NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    if ([data.userLevel isEqualToString:@"1"]) {
        [self.daVip setHidden:NO];
    }
    else {
        [self.daVip setHidden:YES];
    }
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
