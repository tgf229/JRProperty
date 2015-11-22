//
//  ArticleDetailHeadView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "ArticlePictureView.h"
#import "ArticleVoteView.h"
#import "ArticleBottom.h"

@class ArticleDetailHeadView;
@protocol ArticleHeadViewDelegate <NSObject>
/**
 *  投票
 *  @param   type   0 反对  1 支持
 */
-(void) voteClick:(ArticleVoteView *)voteView type:(NSString *)type;
///**
// *  评论触发
// */
//-(void) commentClick;
///**
// *  点赞
// */
//-(void) praise ;
///**
// *  取消赞
// */
//-(void) cancelPraise;

/**
 *  点击小图进入大图浏览
 *
 *  @param pictureView xiao图区域
 *  @param index    图片下标
 *  @param info     图片数组
 */
-(void) imageClick:(ArticlePictureView *)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *) info;
/**
 *  话题发布者 用户头像点击事件
 *
 *  @param userId 用户id
 */
-(void) userHeadClick:(NSString*)userId;
///**
// *  分享
// *
// *  @param articleId 话题id
// */
//- (void)shareArticle:(NSString *)articleId;
- (void) selectUrl:(NSURL *)url;
@end


@interface ArticleDetailHeadView : UIView<ArticleVoteViewDelegate,ArticlePictureDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comeLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong,nonatomic) ArticlePictureView *pictureView;
@property (strong,nonatomic) ArticleVoteView  *voteView;
@property (weak, nonatomic) id<ArticleHeadViewDelegate> delegate; //代理
@property (strong,nonatomic) ArticleDetailModel *data;
@property (weak, nonatomic) IBOutlet UIButton *daVip;
@property (strong,nonatomic) NSURL  *url;
@property (weak, nonatomic) IBOutlet UILabel *commentBumLabel;

+(CGFloat) height:(ArticleDetailModel *)data;
-(void)initial;
- (void)setData:(ArticleDetailModel *)data;
@end
