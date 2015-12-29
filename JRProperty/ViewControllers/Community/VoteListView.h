//
//  VoteListView.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/8.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"
#import "VoteListItem.h"
#import "CommunityService.h"

@interface VoteListView : UIView<VoteListItemDelegate>

@property (assign,nonatomic) BOOL hasChoise;
@property (strong,nonatomic) CommunityService *communityService;

@property (strong,nonatomic)ArticleDetailModel *data;

-(void)initial:(ArticleDetailModel *)data;


@end
