//
//  PlotSomethingNewTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
#import "ArticleListModel.h"

@protocol PlotSonethingNewTableViewCellDelegate <NSObject>

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
/**
 *  新鲜事儿头像
 *
 *  @param indexPath
 */
- (void)headImageViewSelected:(NSIndexPath *)indexPath;

/**
 *  举报新鲜事儿
 *
 *  @param indexPath
 */
- (void)reportImageViewSelected:(NSIndexPath *)indexPath;

/**
 *  新鲜事儿来自哪儿
 *
 *  @param indexPath
 */
- (void)fromHereButtonSelected:(NSIndexPath *)indexPath;

/**
 *  新鲜事儿图片触发
 *
 *  @param indexPath    行号
 *  @param _selectIndex 图片TAG
 */
- (void)uploadImageViewSelectedWithIndexPath:(NSIndexPath *)indexPath selectIndex:(int)_selectIndex;

// dw add
// 点赞触发
-(void) praiseClick:(NSString*) articleId withSection:(NSInteger)section;
// 取消赞触发
-(void) cancelPraiseClick:(NSString*) articleId withSection:(NSInteger)section;
// 首页新鲜事儿
- (void)shareArticle:(NSString *)articleId withSection:(NSInteger)section;
// dw end

@end



@interface PlotSomethingNewTableViewCell : UITableViewCell

@property(nonatomic,weak) id <PlotSonethingNewTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;               // cellIndex
@property (nonatomic, strong) ArticleDetailModel *data;               // cellIndex
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;        // 用户头像
@property (weak, nonatomic) IBOutlet UILabel *fromHereLabel;        // 来自label
@property (weak, nonatomic) IBOutlet UIButton *fromHereButton;      // 来自Button
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;         // 内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            // 时间
@property (weak, nonatomic) IBOutlet UIImageView *firstIv;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstraint;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *uploadImageViewArray;    // 上传图片数组
- (IBAction)commentClick:(id)sender;
- (IBAction)shareClick:(id)sender;

/**
 *  更新数据源
 *
 *  @param newsModel 新鲜事儿MODEL
 */
- (void)refrashDataSourceWithNewsModel:(NewsModel *)newsModel;
+(CGFloat)height:(NewsModel *)data;
@end
