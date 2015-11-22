//
//  AccountInfo.h
//  JRProperty
//
//  Created by liugt on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  登录账户信息

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface AccountInfo : LoginModel

@property (copy, nonatomic)  NSString<Optional> * password; // 用户密码
@property (assign,nonatomic) BOOL isLogin;                 // 是否已登录
@property (assign,nonatomic) BOOL isAutoLogin;             // 是否自动已登录

/**
 *  重置用户信息
 */
- (void)resetAccountInfo;
/**
 *  获取用户信息
 *
 *  @return accontInfo
 */
+ (AccountInfo *)getAccountInfo;
/**
 *  保存用户信息到本地
 *
 *  @param m accontInfo
 */
+ (void)saveAccountInfo:(AccountInfo *)accountInfo;

@end
