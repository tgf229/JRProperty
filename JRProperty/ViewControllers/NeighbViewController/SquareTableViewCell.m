//
//  SquareTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "SquareTableViewCell.h"
#import "ArticleView.h"
#import "UIColor+extend.h"
#import "JRDefine.h"
@implementation SquareTableViewCell
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //self.backgroundColor = [UIColor getColor:@"efefef"];
//        if (self != nil) {
//            [self awakeFromNib];
//        }
//    }
//    
//    return self;
//}
- (void)awakeFromNib {
    [self.moreButton setTitleColor:[UIColor getColor:@"666666"] forState:UIControlStateNormal];
    [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 50, 10, 0)];

    self.articleView = [[ArticleView alloc]initWithFrame:CGRectMake(0, 37 , UIScreenWidth, 0)];
    self.articleView.delegate = self;
    [self addSubview:self.articleView];
    self.circleView = [[CircleView alloc]initWithFrame:CGRectMake(0, 0 , UIScreenWidth, 0)];
    self.circleView.delegate = self;
    [self addSubview:self.circleView];

}

/**
 *  填充数据
 *
 *  @param data
 *
 */
-(void) setData:(NSArray *)circleArray :(NSArray *)articleArray {
    CGFloat articleHight = 86* articleArray.count;
    CGFloat circleHeigh =0;
    self.articleView.frame =CGRectMake(0, 37 , UIScreenWidth, articleHight);
    [self.articleView setData:articleArray];
    if (circleArray.count == 0) {
        [self.circleView setHidden:YES];
    }
    else {
        [self.circleView setHidden:NO];
        circleHeigh = [CircleView height];
        self.circleView.frame = CGRectMake(0, 37+articleHight , UIScreenWidth, circleHeigh);
        [self.circleView setData:circleArray];
    }
}

- (void)imageClick:(CircleView *)circleView withCircleId:(NSString *)circleId circleName:(NSString *)circleName{
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:withCircleId:circleName:)]){
        [_delegate imageClick:self withCircleId:circleId circleName:circleName];
    }
}


- (void) gotoArticleDetailPage:(NSString *)articleId {
    if(_delegate && [_delegate respondsToSelector:@selector(gotoArticleDetailPage:)]){
        [_delegate gotoArticleDetailPage:articleId];
    }
}

+ (CGFloat)heighWithCircleArray:(NSArray *)circleArray articleArray:(NSArray *)articleArray {
    CGFloat articleHight = articleArray.count*86;
   
    CGFloat circleHight;
    
    if (circleArray.count == 0) {
        circleHight= 0 ;
    }
    else {
        circleHight = [CircleView height];
    }
    
    CGFloat hight = 37+articleHight+circleHight+1;
    return hight;
}
@end
