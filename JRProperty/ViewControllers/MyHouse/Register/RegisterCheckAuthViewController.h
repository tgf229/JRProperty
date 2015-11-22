//
//  RegisterCheckAuthViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  注册或者添加房屋，校验身份

#import "JRViewController.h"
@class HouseModel;

@interface RegisterCheckAuthViewController : JRViewControllerWithBackButton

@property (assign,nonatomic)  BOOL        isRegister;           // YES:注册流程  NO:添加房屋流程
@property (strong,nonatomic)  HouseModel  *houseModel;          // 房屋

// dw add V1.1
@property (strong, nonatomic) NSString * selectCID; // 注册选择小区
// dw end
@end
