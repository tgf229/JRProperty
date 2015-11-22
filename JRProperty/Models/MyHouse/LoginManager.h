//
//  LoginManage.h
//
//
//  Created by song_tiger on 13-4-22.
//  Copyright (c) 2013年 broadengate. All rights reserved.
//  登录和用户信息相关信息保存方法

#import <Foundation/Foundation.h>
#import "AccountInfo.h"

@interface LoginManager : NSObject

@property (nonatomic, strong) AccountInfo    *loginAccountInfo;       // 登录账户信息

/**
 *  单例接口
 *
 *  @return 用户信息
 */
+ (LoginManager *)shareInstance;

/**
 *  注册成功之后保存用户名和密码
 *
 *  @param accountInfo 用户信息
 */
-(void)saveAccountInfo:(AccountInfo *)accountInfo;

/**
 *  注销清空用户数据
 */
- (void)resetAccountInfo;
@end
