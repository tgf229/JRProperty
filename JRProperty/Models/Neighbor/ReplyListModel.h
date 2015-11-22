//
//  ReplyListModel.h
//  JRProperty
//
//  Created by tingting zuo on 15-3-31.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
@protocol ReplyModel
@end

@interface ReplyModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * userId;
@property (copy, nonatomic) NSString<Optional> * articleId; // 话题ID
@property (copy, nonatomic) NSString<Optional> * time; // 时间
@property (copy, nonatomic) NSString<Optional> * content; // 话题内容
@property (copy, nonatomic) NSString<Optional> * imageUrl ; // 话题图片
@property (copy, nonatomic) NSString<Optional> * replyUId    ; // id
@property (copy, nonatomic) NSString<Optional> * replyNickName; // 回复者
@property (copy, nonatomic) NSString<Optional> * replyCommentId ; // 回复的评论id
@property (copy, nonatomic) NSString<Optional> * replyContent ; //回复内容
@property (copy, nonatomic) NSString<Optional> * beReplyUId ; // 被回复的用户id
@property (copy, nonatomic) NSString<Optional> * beReplyNickName ; //被回复的用户昵称
@property (copy, nonatomic) NSString<Optional> * replyHeadUrl;//头像
@property (copy, nonatomic) NSString<Optional> * userLevel ; // 用户等级 1 大V
@property (copy, nonatomic) NSString<Optional> * cId ; // 用户等级 1 大V
@end

@interface ReplyListModel : BaseModel
@property (strong, nonatomic) NSMutableArray<ReplyModel, Optional> *doc;
@end
