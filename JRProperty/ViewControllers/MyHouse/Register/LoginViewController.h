//
//  LoginViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  登录页面

#import "JRViewController.h"

@interface LoginViewController : JRViewController

@property (weak,nonatomic)   IBOutlet UITextField *phoneTextField;  // 手机号码
@property (strong,nonatomic) dispatch_block_t loginButtonBlock;  // 登录成功事件

/**
 *  登陆
 *
 *  @param sender 
 */
- (IBAction)loginButtonPressed:(id)sender;

/**
 *  自动登录
 */
-(void)autoLogin;

- (void)loginWithUserName:(NSString *)userName andMd5Password:(NSString *)md5password;

@end
