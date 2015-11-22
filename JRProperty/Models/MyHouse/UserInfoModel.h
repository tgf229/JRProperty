//
//  UserInfoModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol UserInfoModel
@end

@interface UserInfoModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * username; // 用户名
@property (copy, nonatomic) NSString<Optional> * image   ; // 头像地址
@property (copy, nonatomic) NSString<Optional> * nickName; // 昵称
@property (copy, nonatomic) NSString<Optional> * name    ; // 姓名
@property (copy, nonatomic) NSString<Optional> * sex     ; // 性别
@property (copy, nonatomic) NSString<Optional> * birth   ; // 生日
@property (copy, nonatomic) NSString<Optional> * uId     ; // 用户ID
@property (copy, nonatomic) NSString<Optional> * phone   ; // 用户电话
@property (copy, nonatomic) NSString<Optional> * level   ; // 用户级别
@property (copy, nonatomic) NSString<Optional> * status  ; // 状态

@end

@interface UserInfoListModel : BaseModel
@property (strong, nonatomic) NSMutableArray<UserInfoModel,Optional> *doc;
@end
