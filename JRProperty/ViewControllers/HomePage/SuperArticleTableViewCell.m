//
//  SuperArticleTableViewCell.m
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "SuperArticleTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"


@implementation SuperArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _attentionLabel.textColor = UIColorFromRGB(0x888888);
    _postLabel.textColor = UIColorFromRGB(0x888888);
    _contentLabel.textColor = UIColorFromRGB(0x888888);
}


- (void)refrashDataWithCircleInfoModel:(CircleInfoModel *)circleInfoModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:circleInfoModel.icon] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    _nameLabel.text = circleInfoModel.name;
    _attentionLabel.text = [NSString stringWithFormat:@"%@关注",circleInfoModel.userCount];
    _postLabel.text = [NSString stringWithFormat:@"%@发帖",circleInfoModel.articleCount];
    _contentLabel.text = [NSString stringWithFormat:@"公告:%@",circleInfoModel.desc];
    
    
}

- (IBAction)singleButtonSelected:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellSingleButtonClickWithIndexPath:)]) {
        [self.delegate cellSingleButtonClickWithIndexPath:_indexPath];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
