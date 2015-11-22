//
//  CommunityModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol MemberModel
@end

@interface MemberModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * uId     ; // 用户ID
@property (copy, nonatomic) NSString<Optional> * nickName; // 用户昵称
@property (copy, nonatomic) NSString<Optional> * userLevel ; // 用户等级 1 大V
@property (copy, nonatomic) NSString<Optional> * image   ; // 用户头像（3.3.4接口使用）
@property (copy, nonatomic) NSString<Optional> * imageUrl; // 用户头像（3.3.13接口使用）
@property (copy, nonatomic) NSString<Optional> * desc    ; // 用户签名
@end

@interface CommunityModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * id          ; // 社区ID
@property (copy, nonatomic) NSString<Optional> * name        ; // 社区名称
@property (copy, nonatomic) NSString<Optional> * desc        ; // 社区公告描述
@property (copy, nonatomic) NSString<Optional> * icon        ; // 社区LOGO
@property (copy, nonatomic) NSString<Optional> * uId         ; // 社区管理员ID
@property (copy, nonatomic) NSString<Optional> * nickName    ; // 社区管理员昵称
@property (copy, nonatomic) NSString<Optional> * flag        ; // 加入标志位
@property (copy, nonatomic) NSString<Optional> * userCount   ; // 用户关注数量
@property (copy, nonatomic) NSString<Optional> * articleCount; // 话题数量
@property (strong, nonatomic) NSMutableArray<MemberModel, Optional> *member;

@end
