//
//  ArticleView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleView.h"
#import "SquareArticleView.h"
#import "JRDefine.h"


@implementation ArticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        //初始化
        [self initial];
    }
    
    return self;
}

-(void)initial{
    for (int i = 0; i < 2; i++) {
        SquareArticleView *articleView = [[[NSBundle mainBundle] loadNibNamed:@"SquareArticleView" owner:self options:nil]objectAtIndex:0];
        articleView.tag = i;
        articleView.delegate = self;
        [articleView initial];
        [self addSubview:articleView];
    }
}

#pragma mark 设置数据，返回高度
-(void) setData:(NSArray *)data{
    CGFloat width;
    CGFloat height;
    for (int i = 0; i < self.subviews.count; i++) {
        
        width = UIScreenWidth;
        height = 86;
        
        SquareArticleView * item = self.subviews[i];
        if(i < data.count) {
            
            //设置显示
            item.hidden = NO;
            //设置frame
            item.frame = CGRectMake(0, i*height, width, height);
            //设置数据
            ArticleModel *model =[data objectAtIndex:i];
            [item setData:model];
            
        }
        else{
            item.hidden = YES;
        }
    }
}


- (void)gotoArticleDetailPage:(NSString *)articleId {
    if(_delegate && [_delegate respondsToSelector:@selector(gotoArticleDetailPage:)]){
        [_delegate gotoArticleDetailPage:articleId];
    }
    
}

#pragma mark 返回高度
+(CGFloat) height:(NSInteger) data {
        return data*86;
}


@end
