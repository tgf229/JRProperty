//
//  VoteListView.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/8.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "VoteListView.h"
#import "VoteListItem.h"
#import "JRDefine.h"
#import "LoginManager.h"


@implementation VoteListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        //初始化
//        [self initial];
    }
    
    return self;
}

-(void)initial:(ArticleDetailModel *)data{
    _data = data;
    CGFloat height = 72;
    
    int sumVote = 0;
    for (VoteModel *item in data.voteList) {
        sumVote = sumVote + [item.voteNum intValue];
        if ([@"1" isEqualToString:item.myVote]) {
            self.hasChoise = YES;
        }
    }
    
    for (int i=0; i<[data.voteList count]; i++) {
        VoteListItem *item = [[[NSBundle mainBundle] loadNibNamed:@"VoteListItem" owner:self options:nil]objectAtIndex:0];
//        item.tag = i;
        item.delegate = self;
        [item initial];
        item.frame = CGRectMake(15, i*height, UIScreenWidth-30, height);
        VoteModel *model = [data.voteList objectAtIndex:i];
        [item setData:model totalNum:sumVote];
        [self addSubview:item];
    }
}

-(void)voteClick:(NSString *)voteId{
  
    for (VoteModel *model in _data.voteList) {
        //将选中的选项赋值 选中，并增加数量
        if ([voteId isEqualToString: model.voteId]) {
            int num = [model.voteNum intValue]+1;
            model.voteNum = [NSString stringWithFormat:@"%d",num];
            model.myVote = @"1";
        }else{
            //当前未选中的选项,如果操作前是 选中项，则改为未选中,并减少数量
            if ([@"1" isEqualToString:model.myVote]) {
                model.myVote = @"0";
                int num = [model.voteNum intValue]-1;
                model.voteNum = [NSString stringWithFormat:@"%d",num];
            }
        }
    }
    
    [self initial:_data];
    
    self.communityService = [[CommunityService alloc]init];
    //调接口
    [self.communityService Bus301002:CID_FOR_REQUEST aId:_data.aId uId:[LoginManager shareInstance].loginAccountInfo.uId voteId:voteId success:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

@end
