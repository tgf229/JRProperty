//
//  SquareArticleView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "SquareArticleView.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"

@implementation SquareArticleView


#pragma mark 初始化

-(void)initial{
    //self.contentLabel.preferredMaxLayoutWidth = se
    self.circleNameLabel.textColor = [UIColor getColor:@"0188be"];
    self.fromLabel.textColor = [UIColor getColor:@"888888"];
    
}
/**
 *  填充数据
 *
 *  @param data
 *
 */
- (void)setData:(ArticleModel *)data {
    _data = data;
    self.circleNameLabel.text = data.from;
    self.contentLabel.text = data.content;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"default-160x120"]];
}

- (IBAction)gotoArticleDetailPage:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(gotoArticleDetailPage:)]){
        [_delegate gotoArticleDetailPage:_data.id];
    }
    
}
/**
 *  获取评论区域高度
 *
 *  @param data 评论列表
 *
 *  @return 高度
 */
+(CGFloat) height {
    
    return 86.0;
}



@end
