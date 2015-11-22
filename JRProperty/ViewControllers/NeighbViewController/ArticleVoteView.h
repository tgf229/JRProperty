//
//  ArticleVoteView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
@class ArticleVoteView;
@protocol ArticleVoteViewDelegate <NSObject>
/**
 *  投票、
 *
 *  @param articleId 话题id
 *  @param   type   0 反对  1 支持
 */
-(void) voteClick:(ArticleVoteView *)voteView withArticleId:(NSString *)articleId type:(NSString *)type;

@end


@interface ArticleVoteView : UIView
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (strong,nonatomic) ArticleDetailModel *data;
@property (weak, nonatomic) id<ArticleVoteViewDelegate> delegate; //代理

- (IBAction)chooeYes:(id)sender;
- (IBAction)chooseNo:(id)sender;
- (void)setData:(ArticleDetailModel *)  data;
-(void)initial;
@end
