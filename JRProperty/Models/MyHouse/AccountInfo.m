//
//  AccountInfo.m
//  JRProperty
//
//  Created by liugt on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AccountInfo.h"
#import "LoginManager.h"

@implementation AccountInfo

- (void)resetAccountInfo
{
    self.username = nil;
    self.password = nil;
    self.image = nil;
    self.nickName = nil;
    self.name = nil;
    self.sex = nil;
    self.birth = nil;
    self.uId = nil;
    self.baseKey = nil;
    self.isLogin = NO;
}

+ (AccountInfo *)getAccountInfo
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *accountData = [defaults objectForKey:@"userinfo"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:accountData];
}

+ (void)saveAccountInfo:(AccountInfo *)accountInfo
{
    [LoginManager shareInstance].loginAccountInfo = accountInfo;
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:accountInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userinfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
