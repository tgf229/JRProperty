//
//  ArticleBottomView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
@class ArticleBottomView;
@protocol ArticleBottomViewDelegate <NSObject>
/**
 *  评论触发
 *
 *  @param articleId 话题id
 */
-(void) commentClick:(ArticleDetailModel*) data;
/**
 *  点赞触发
 *
 *  @param articleId 话题id
 */
-(void) praiseClick:(NSString*) articleId;
/**
 *  取消赞触发
 *
 *  @param articleId 话题id
 */
-(void) cancelPraiseClick:(NSString*) articleId;

/**
 *  分享
 *
 *  @param articleId 话题id
 */
- (void)shareArticle:(NSString *)articleId;
@end

@interface ArticleBottomView : UIView

@property (strong ,nonatomic) ArticleDetailModel *data;
@property (weak, nonatomic) IBOutlet UIButton *priaseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)commentClick:(id)sender;
//- (IBAction)setClick:(id)sender;
- (IBAction)shareClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@property (weak, nonatomic) id<ArticleBottomViewDelegate> delegate; // 代理

- (void)setData:(ArticleDetailModel *)  data;

-(void)initial;
@end

