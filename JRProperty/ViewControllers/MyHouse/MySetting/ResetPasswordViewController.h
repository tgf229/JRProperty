//
//  ResetPasswordViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  忘记密码和密码管理 － 重设密码

#import "JRViewController.h"

@interface ResetPasswordViewController : JRViewControllerWithBackButton

@property (assign,nonatomic) BOOL      isForgetPassword;
@property (copy,nonatomic)   NSString  *phoneNumber;       // 手机号码

@end
