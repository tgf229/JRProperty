//
//  ArticleView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"
#import "SquareArticleView.h"
@class  ArticleView;
@protocol  ArticleDelegate <NSObject>

/**
 *  去话题详情
 *
 *  @param articleId 话题id
 */
-(void) gotoArticleDetailPage:(NSString*) articleId;

@end


@interface ArticleView : UIView<SquareArticleDelegate>
@property (weak,nonatomic) id <ArticleDelegate> delegate;
-(void) setData:(NSArray *)data;
-(void)initial;
+(CGFloat) height:(NSInteger) data;
@end
