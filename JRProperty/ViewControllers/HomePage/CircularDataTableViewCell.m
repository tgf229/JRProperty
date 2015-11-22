//
//  CircularDataTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/12/6.
//  Copyright (c) 2014 YRYZY. All rights reserved.
//

#import "CircularDataTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"
#import "JRPropertyUntils.h"
#import "LoginManager.h"
@implementation CircularDataTableViewCell

- (void)setFrame:(CGRect)frame{
    if (CURRENT_VERSION < 7.0f) {
        frame.origin.x -= 15;
        frame.size.width += 30;
    }
    [super setFrame:frame];
}

- (void)awakeFromNib {
    // Initialization code
//    [self setBackgroundView:[[UIView alloc] init]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15.0f;
    _timeLabel.textColor = UIColorFromRGB(0x888888);
    _contentLabel.textColor = UIColorFromRGB(0x666666);
    _isMyComment = NO;
}

- (void)refreshDataWithAnnounceCommentModel:(AnnounceCommentModel *)announceCommentModel{
    if (_isMyComment) {
        [JRPropertyUntils refreshUserPortraitInView:_headImageView];
    }else{
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:announceCommentModel.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    }
    
    _nameLabel.text = announceCommentModel.name;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:announceCommentModel.time];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    _timeLabel.text = strDate;
    _contentLabel.text = announceCommentModel.desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
