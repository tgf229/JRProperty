//
//  FleaMarketCommentListModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
@protocol FleaMarketCommentListModel
@end

@protocol FleaMarketCommentModel
@end

@interface FleaMarketCommentModel : BaseModel  // 评论 回复 model
@property (copy, nonatomic) NSString<Optional> * commentId     ; // 评论ID
@property (copy, nonatomic) NSString<Optional> * uId   ; // 用户id
@property (copy, nonatomic) NSString<Optional> * imageUrl      ; // 用户头像
@property (copy, nonatomic) NSString<Optional> * time    ; // 评论时间
@property (copy, nonatomic) NSString<Optional> * nickName     ; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * replyUId; // 被回复的用户id
@property (copy, nonatomic) NSString<Optional> * replyNickName   ; // 被回复的用户昵称
@property (copy, nonatomic) NSString<Optional> * content ; // 评论内容
@end

@interface FleaMarketCommentListModel : BaseModel
@property(copy,nonatomic) NSString<Optional> * queryTime       ; //查询时间点
@property (strong, nonatomic) NSArray<FleaMarketCommentModel, Optional> * doc;
@end
