//
//  SquareArticleView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"
@class SquareArticleView;
@protocol SquareArticleDelegate <NSObject>

/**
 *  去话题详情
 *
 *  @param articleId 话题id
 */
-(void) gotoArticleDetailPage:(NSString*) articleId;

@end


@interface SquareArticleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong,nonatomic) ArticleModel *data;
@property (weak,nonatomic) id <SquareArticleDelegate> delegate;

+(CGFloat) height;
-(void)initial;
- (void)setData:(ArticleModel *)data;

- (IBAction)gotoArticleDetailPage:(id)sender;


@end
