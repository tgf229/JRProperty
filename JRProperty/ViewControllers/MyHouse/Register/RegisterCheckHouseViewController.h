//
//  RegisterCheckHouseViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  注册第一步，选择房屋，同意规则

#import "JRViewController.h"
#import "BuildingListModel.h"

@interface RegisterCheckHouseViewController : JRViewControllerWithBackButton

@property (assign,nonatomic)           BOOL        isRegister;           // YES:注册流程  NO:添加房屋流程
@property (strong,nonatomic)           HouseModel  *houseModel;          // 房屋
@property (weak,nonatomic)    IBOutlet UILabel     *houseNumberLabel;    // 房号

@end
