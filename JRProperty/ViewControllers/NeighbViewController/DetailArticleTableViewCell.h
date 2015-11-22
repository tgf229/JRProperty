//
//  DetailArticleTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "ArticlePictureView.h"
#import "ArticleVoteView.h"
#import "ArticleBottomView.h"
@class DetailArticleTableViewCell;
@protocol DetailArticleTableViewCellDelegate <NSObject>
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
 *  置顶 取消置顶 shanchu
 *
 *  @param articleId 话题id
 *  @param type 类型 1 置顶  2 取消置顶  3 删除
 */
- (void)setArticle:(NSString *)articleId  forIndexPath:(NSIndexPath*) indexPath;

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
@end


@interface DetailArticleTableViewCell : UITableViewCell<ArticleVoteViewDelegate,ArticleBottomViewDelegate,ArticlePictureDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *userTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong,nonatomic) ArticleDetailModel *data;
@property (strong,nonatomic) ArticlePictureView *pictureView;
@property (strong,nonatomic) ArticleVoteView  *voteView;
@property (strong,nonatomic) ArticleBottomView  *detailBottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopContraint;

@property (weak, nonatomic) id<DetailArticleTableViewCellDelegate> delegate; //代理

+(CGFloat)height:(ArticleDetailModel *)data;
- (void)setData:(ArticleDetailModel *)data createUid:(NSString *)uId;
@end
