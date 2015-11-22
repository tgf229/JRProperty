//
//  SquareTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SquareArticleView.h"
#import "ArticleView.h"
#import "CircleView.h"
@class SquareTableViewCell;
@protocol SquareCellDelegate <NSObject>
/**
 *  点击小图进入圈子详情
 *
 *  @param circleId 圈子id
 */
-(void) imageClick:(SquareTableViewCell *)cellView withCircleId:(NSString *)circleId circleName:(NSString *)circleName;

/**
 *  去话题详情
 *
 *  @param articleId 话题id
 */
-(void) gotoArticleDetailPage:(NSString*) articleId;

@end
@interface SquareTableViewCell : UITableViewCell<CircleViewDelegate,ArticleDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong,nonatomic) ArticleView       *articleView;
@property (strong,nonatomic) CircleView    *circleView;
@property (weak, nonatomic) id<SquareCellDelegate> delegate; //代理
/**
 *  填充数据
 *
 *  @param data
 *
 */
-(void) setData:(NSArray *)circleArray :(NSArray *)articleArray;

+ (CGFloat)heighWithCircleArray:(NSArray *)circleArray articleArray:(NSArray *)articleArray ;

@end
