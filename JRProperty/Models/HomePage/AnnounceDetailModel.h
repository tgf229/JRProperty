//
//  AnnounceDetailModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"


@protocol AnnounceCommentModel
@end

@interface AnnounceCommentModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * name; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * image;// 用户头像
@property (copy, nonatomic) NSString<Optional> * time; // 评论时间
@property (copy, nonatomic) NSString<Optional> * desc; // 评论内容
@end

@interface AnnounceDetailModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * id       ; // 通告活动ID
@property (copy, nonatomic) NSString<Optional> * name     ; // 通告活动名称
@property (copy, nonatomic) NSString<Optional> * desc     ; // 通告活动描述
@property (copy, nonatomic) NSString<Optional> * imageUrl ; // 活动图片
@property (copy, nonatomic) NSString<Optional> * praiseNum; // 被点赞次数
@property (copy, nonatomic) NSString<Optional> * blameNum ; // 被踩次数
@property (copy, nonatomic) NSString<Optional> * shareNum ; // 被分享次数
@property (strong, nonatomic) NSArray<AnnounceCommentModel, Optional> * comment; // 评论数据列表
@end
