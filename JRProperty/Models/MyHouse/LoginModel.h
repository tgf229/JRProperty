//
//  LoginModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * uId; // 用户ID
// dw add V1.1
@property (copy, nonatomic) NSString<Optional> * cId; // 小区ID
@property (copy, nonatomic) NSString<Optional> * userLevel; // 是否超级管理员
// dw end
@property (copy, nonatomic) NSString<Optional> * baseKey; // 平台密钥
@property (copy, nonatomic) NSString<Optional> * username; // 用户名
@property (copy, nonatomic) NSString<Optional> * image   ; // 头像地址
@property (copy, nonatomic) NSString<Optional> * nickName; // 昵称
@property (copy, nonatomic) NSString<Optional> * name    ; // 姓名
@property (copy, nonatomic) NSString<Optional> * sex     ; // 性别
@property (copy, nonatomic) NSString<Optional> * birth   ; // 生日
@end
