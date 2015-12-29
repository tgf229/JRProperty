//
//  FleaMarketDetailModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
#import "FleaMarketListModel.h"

@protocol FleaMarketDetailModel
@end

@protocol FleaMarketLikeModel
@end

@interface FleaMarketLikeModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * uId     ; // 用户id
@property (copy, nonatomic) NSString<Optional> * imageUrl   ; // 用户头像地址
@end

@interface FleaMarketDetailModel : BaseModel

@property (copy, nonatomic) NSString<Optional> * uId     ; // 发布此消息的用户ID
@property (copy, nonatomic) NSString<Optional> * nickName   ; // 发布此消息的用户昵称
@property (copy, nonatomic) NSString<Optional> * imageUrl      ; // 用户头像
@property (copy, nonatomic) NSString<Optional> * time    ; // 发布此消息据当前时间
@property (copy, nonatomic) NSString<Optional> * aId     ; // 宝贝id
@property (copy, nonatomic) NSString<Optional> * content; // 宝贝内容
@property (copy, nonatomic) NSString<Optional> * flag   ; // 是否已收藏
@property (copy, nonatomic) NSString<Optional> * praiseNum ; // 收藏数量
@property (copy, nonatomic) NSString<Optional> * commentNum ; // 评论数量
@property (strong, nonatomic) NSArray<FleaMarketImageModel, Optional> * imageList; // 信息包含图片列表地址
@property (strong, nonatomic) NSArray<FleaMarketLikeModel, Optional> * likeList; // 收藏此信息的用户列表
@end
