//
//  SuperArticleTableViewCell.h
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListModel.h"

@protocol SuperArticleTableViewCellDelegate <NSObject>
@required
/**
 *  单选按钮选中
 *
 *  @param _indexPath
 */
- (void)cellSingleButtonClickWithIndexPath:(NSIndexPath *)_indexPath;
@end

@interface SuperArticleTableViewCell : UITableViewCell
@property (assign, nonatomic) id<SuperArticleTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (weak, nonatomic) IBOutlet UIButton *singleButton;    // 选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *headImageView; // 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        // 名称
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;   // 关注量
@property (weak, nonatomic) IBOutlet UILabel *postLabel;        // 发帖量
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;     // 内容


- (void)refrashDataWithCircleInfoModel:(CircleInfoModel *)circleInfoModel;

@end
