//
//  LoginManage.m
//
//
//  Created by song_tiger on 13-4-22.
//  Copyright (c) 2013年 broadengate. All rights reserved.
//

#import "LoginManager.h"
#import "JRDefine.h"

@implementation LoginManager
@synthesize loginAccountInfo;

static LoginManager *loginManage = nil;

+ (LoginManager *)shareInstance {
	@synchronized(self){
		if (loginManage == nil) {
			loginManage = [[LoginManager alloc] init];
		}
	}
	return loginManage;
}

- (id)init {
    self = [super init];
    if(self) {
        AccountInfo *accountInfo = [AccountInfo getAccountInfo];
        if(accountInfo) {
            self.loginAccountInfo = accountInfo;
        }
        else {
            self.loginAccountInfo = [[AccountInfo alloc] init];
        }
    }
    return self;
}

-(void)saveAccountInfo:(AccountInfo *)accountInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:accountInfo.username forKey:LOGIN_ACCOUNT_PHONE];
    [[NSUserDefaults standardUserDefaults]setObject:accountInfo.password forKey:LOGIN_ACCOUNT_PASSWORD];
    
    [AccountInfo saveAccountInfo:accountInfo];
}


- (void)resetAccountInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:LOGIN_ACCOUNT_PASSWORD];
    
    // 移除缓存头像原来的图片
    NSString *portriatPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userPhoto.png"];
    NSFileManager *documentsFileManager = [NSFileManager defaultManager];
    NSError *err;
    [documentsFileManager removeItemAtPath:portriatPath error:&err];

    [AccountInfo saveAccountInfo:nil];
}

@end
