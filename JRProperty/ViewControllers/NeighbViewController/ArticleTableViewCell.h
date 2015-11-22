//
//  ArticleTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  话题cell

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "ArticlePictureView.h"
#import "ArticleVoteView.h"
#import "ArticleBottom.h"
@class ArticleTableViewCell;
@protocol ArticleTableViewViewDelegate <NSObject>

/**
 *  投票、
 *
 *  @param articleId 话题id
 *  @param   type   0 反对  1 支持
 */
-(void) voteClick:(ArticleVoteView *)voteView atIndex:(NSUInteger)index withArticleId:(NSString *)articleId type:(NSString *)type;

/**
 *  评论触发
 *
 *  @param articleId 话题id
 */
-(void) commentClick:(ArticleDetailModel*) data;

/**
 *  点赞
 *
 *  @param articleId 话题id
 *  @param indexPath 行号
 */
-(void) praise:(NSString*) articleId forIndexPath:(NSIndexPath*) indexPath;

/**
 *  取消赞
 *
 *  @param articleId 话题id
 *  @param indexPath 行号
 */
-(void) cancelPraise:(NSString*) articleId forIndexPath:(NSIndexPath*) indexPath;

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


/**
 *  分享
 *
 *  @param articleId 话题id
 */
- (void)shareArticle:(NSString *)articleId  forIndexPath:(NSIndexPath*) indexPath;
- (void)selectUrl:(NSURL *)url;
@end

@interface ArticleTableViewCell : UITableViewCell<ArticleVoteViewDelegate,ArticleBottomDelegate,ArticlePictureDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comeLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleNameLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong,nonatomic) ArticleDetailModel *data;
@property (strong,nonatomic) NSURL *url;

@property (strong,nonatomic) ArticlePictureView *pictureView;
@property (strong,nonatomic) ArticleVoteView  *voteView;
@property (strong,nonatomic) ArticleBottom      *bottomView;
@property (assign,nonatomic) BOOL isDetailPage;

@property (weak, nonatomic) id<ArticleTableViewViewDelegate> delegate; //代理
@property (weak, nonatomic) IBOutlet UIButton *userType;


@property (weak, nonatomic) IBOutlet UIImageView *topIcon;
@property (weak, nonatomic) IBOutlet UIButton *vip;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopContraint;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopContraint;

+(CGFloat)height:(ArticleDetailModel *)data;
- (void)setData:(ArticleDetailModel *)data createUid:(NSString *)uId;
- (void)isDetailPage:(BOOL)isDetail;
@end
