//
//  CommunityListOfficialCell.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/9.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "CommunityService.h"
#import "ShareView.h"
#import "ShareToSnsService.h"

@interface CommunityListOfficialCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak,nonatomic) IBOutlet UILabel *volLabel;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak,nonatomic) IBOutlet UIButton *praiseButton;
@property (weak,nonatomic) IBOutlet UIButton *commentButton;
@property (weak,nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic,strong)  ShareView    *shareView;// 分享页面

@property (strong,nonatomic) ArticleDetailModel *detailModel;
@property (strong,nonatomic) CommunityService *communityService;
@property (strong,nonatomic) ShareToSnsService *shareService;

-(void)showCell:(ArticleDetailModel *)detailModel;
@end
