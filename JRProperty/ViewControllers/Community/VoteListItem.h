//
//  VoteListItem.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/8.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"

@class VoteListItem;
@protocol VoteListItemDelegate <NSObject>

-(void)voteClick:(NSString *)voteId;

@end


@interface VoteListItem : UIView

@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *numLabel;
@property (weak,nonatomic) IBOutlet UIProgressView *progressView;
@property (weak,nonatomic) IBOutlet UIImageView *choiseImageView;

@property (strong,nonatomic) VoteModel *data;

@property (assign,nonatomic) NSString *isChoise;
@property (weak,nonatomic) id <VoteListItemDelegate> delegate;

-(void)initial;
-(void)setData:(VoteModel *)data totalNum:(int)totalNum;

-(IBAction)voteClick:(id)sender;
@end
