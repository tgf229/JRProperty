//
//  RegisterUserInfoViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
@class HouseModel;

@interface RegisterUserInfoViewController : JRViewControllerWithBackButton

@property (assign,nonatomic)  BOOL        isProprietor;         // YES:业主  NO:住户
@property (strong,nonatomic)  HouseModel  *houseModel;          // 房屋信息

// dw add V1.1
@property (strong, nonatomic) NSString * selCID;    // 注册选择的小区
// dw end
@end
