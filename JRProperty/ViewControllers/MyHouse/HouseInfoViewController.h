//
//  HouseInfoViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  房屋信息

#import "JRViewController.h"
#import "MyHouseListModel.h"

@interface HouseInfoViewController : JRViewControllerWithBackButton

@property (strong,nonatomic) MyHouseModel *myHouseModel;

/**
 *  houseModel传值
 *
 *  @param houseModel 
 */
- (void)setHouseModel:(MyHouseModel *)houseModel;

@end
