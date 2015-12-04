//
//  CommunityListCell.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"

@interface CommunityListCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *headImageView;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *timeLabel;
@property (weak,nonatomic) IBOutlet UILabel *contentLabel;
@property (strong,nonatomic) IBOutletCollection(UIImageView) NSArray *imagesImageView;
@property (weak,nonatomic) IBOutlet UIButton *praiseButton;
@property (weak,nonatomic) IBOutlet UIButton *commentButton;
@property (weak,nonatomic) IBOutlet UIButton *moreButton;

-(void)showCell:(ArticleDetailModel *)detailModel;
+(CGFloat)height:(ArticleDetailModel *)data;
@end
