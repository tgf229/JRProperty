//
//  PlotSomethingNewTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PlotSomethingNewTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"
#define IMAGEVIEWHEIGHT (UIScreenWidth - 80)/3
@implementation PlotSomethingNewTableViewCell

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
    [_userNameLabel setTextColor:UIColorFromRGB(0x0188be)];
    [_fromHereLabel setTextColor:UIColorFromRGB(0x666666)];
    [_fromHereButton setTitleColor:UIColorFromRGB(0x0188be) forState:UIControlStateNormal];
    [_timeLabel setTextColor:UIColorFromRGB(0x666666)];
    _userNameLabel.text = @"";
    _timeLabel.text = @"";
}

- (void)refrashDataSourceWithNewsModel:(NewsModel *)newsModel{
    _data = (ArticleDetailModel *)newsModel;
    _userNameLabel.text = newsModel.nickName;
    [_fromHereButton setTitle:newsModel.name forState:UIControlStateNormal];

    _timeLabel.text = newsModel.time;
    _contentLabel.text = newsModel.content;
    
    if (newsModel.imageList && newsModel.imageList.count > 0) {
        PlotImageModel *imageModel = (PlotImageModel *)newsModel.imageList[0];
        [self.firstIv sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrlS] placeholderImage:[UIImage imageNamed:@"community_default"]];
        self.contentConstraint.constant = 16.0f;
    } else {
        [self.firstIv setImage:nil];
        self.contentConstraint.constant = -90.0f;
    }
    
    [_zanBtn setTitle:newsModel.praiseNum forState:UIControlStateNormal];
    [_commentBtn setTitle:newsModel.comment forState:UIControlStateNormal];
    
    if ([_data.flag integerValue]==1) {
        [_zanBtn setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateHighlighted];
        [_zanBtn removeTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [_zanBtn addTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_zanBtn setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateHighlighted];
        [_zanBtn removeTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
        [_zanBtn addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (IBAction)fromHereButtonSelected:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(headImageViewSelected:)]) {
        [self.delegate fromHereButtonSelected:self.indexPath];
    }
}

+(CGFloat)height:(NewsModel *)data {
    //计算content的高度
    CGFloat cellHeight;
    CGSize size = CGSizeMake(UIScreenWidth-68,4000);
    CGFloat contentHeight =0.0;
    if (data.content.length != 0) {
        CGSize labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height;
    }
    CGFloat pictureHight=0.0 ;
    CGFloat imageHight =( UIScreenWidth-68-8)/3;
    if (data.imageList.count > 0 && data.imageList.count<=3) {
        pictureHight = imageHight+9;
    }
    else if (data.imageList.count >3){
        pictureHight = imageHight*2+9;
    }
    cellHeight = 60+contentHeight+ pictureHight;
    return cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)praise {
    [UIView animateWithDuration:0.2 animations:^{
        
        _zanBtn.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _zanBtn.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _zanBtn.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _zanBtn.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(praiseClick:)]) {
        [_delegate praiseClick:_data.articleId];
    }
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(praiseClick:withSection:)]) {
        [_delegate praiseClick:_data.articleId withSection:self.indexPath.row];
    }
    // dw end
    
}
- (void)cancelPraise {
    [UIView animateWithDuration:0.2 animations:^{
        
        _zanBtn.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _zanBtn.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _zanBtn.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _zanBtn.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraiseClick:)]) {
        [_delegate cancelPraiseClick:_data.articleId];
    }
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraiseClick:withSection:)]) {
        [_delegate cancelPraiseClick:_data.articleId withSection:self.indexPath.row];
    }
    // dw end
}



- (IBAction)commentClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(commentClick:)]) {
        [_delegate commentClick:_data];
    }
}

- (IBAction)shareClick:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(shareArticle:)]) {
        [_delegate shareArticle:_data.articleId];
    }
    
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(shareArticle:withSection:)]) {
        [_delegate shareArticle:_data.articleId withSection:self.indexPath.row];
    }
    // dw end
}

@end
