//
//  ArticleBottom.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
@class ArticleBottom;
@protocol ArticleBottomDelegate <NSObject>
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

@optional
// dw add
// 点赞触发
-(void) praiseClick:(NSString*) articleId withSection:(NSInteger)section;
// 取消赞触发
-(void) cancelPraiseClick:(NSString*) articleId withSection:(NSInteger)section;
// 首页新鲜事儿
- (void)shareArticle:(NSString *)articleId withSection:(NSInteger)section;
// dw end

@end
@interface ArticleBottom : UIView
@property (strong ,nonatomic) ArticleDetailModel *data;
@property (weak, nonatomic) IBOutlet UIButton *priseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)commentClick:(id)sender;
- (IBAction)shareClick:(id)sender;
@property (weak, nonatomic) id<ArticleBottomDelegate> delegate; // 代理

// dw add
@property (assign, nonatomic) NSInteger section;
// dw end


- (void)setData:(ArticleDetailModel *)  data;
-(void)initial;
@end
