//
//  CommentListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol CommentModel
@end

@interface CommentModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * commentId ; //评论id
@property (copy, nonatomic) NSString<Optional> * uId     ; // 用户ID
@property (copy, nonatomic) NSString<Optional> * nickName; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * userLevel ; // 用户等级 0普通 1大V  2超级管理员
@property (copy, nonatomic) NSString<Optional> * cId;   //此评论用户所属的小区id
@property (copy, nonatomic) NSString<Optional> * cName; //此评论用户所属的小区name
@property (copy, nonatomic) NSString<Optional> * content ; // 评论内容
@property (copy, nonatomic) NSString<Optional> * time    ; // 评论时间
@property (copy, nonatomic) NSString<Optional> * imageUrl; // 用户头像地址
@property (copy, nonatomic) NSString<Optional> * replyUId ; // 被回复的用户id
@property (copy, nonatomic) NSString<Optional> * replyNickName ; //被回复的用户昵称


@end

@interface CommentListModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * queryTime; // 查询时间点
@property (strong, nonatomic) NSMutableArray<CommentModel, Optional> *doc;
@end
