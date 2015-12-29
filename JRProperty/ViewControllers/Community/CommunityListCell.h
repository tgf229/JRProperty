//
//  CommunityListCell.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/1.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "ArticlePictureView.h"
#import "CommunityService.h"
#import "ShareView.h"
#import "ShareToSnsService.h"

@interface CommunityListCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *headImageView;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *timeLabel;
@property (weak,nonatomic) IBOutlet UILabel *contentLabel;
@property (strong,nonatomic) IBOutletCollection(UIImageView) NSArray *imagesImageView;
@property (weak,nonatomic) IBOutlet UIButton *praiseButton;
@property (weak,nonatomic) IBOutlet UIButton *commentButton;
@property (weak,nonatomic) IBOutlet UIButton *moreButton;
@property (weak,nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak,nonatomic) IBOutlet UIImageView *voteImageView;
@property (strong,nonatomic) IBOutletCollection(UIButton) NSArray *imagesButton;

@property (nonatomic,strong)  ShareView    *shareView;// 分享页面

@property (strong,nonatomic) ArticleDetailModel *detailModel;
@property (strong,nonatomic) CommunityService *communityService;
@property (strong,nonatomic) ShareToSnsService *shareService;

-(void)showCell:(ArticleDetailModel *)detailModel;
+(CGFloat)height:(ArticleDetailModel *)data;

-(void)setData:(ArticleDetailModel *)detailModel;
@end
