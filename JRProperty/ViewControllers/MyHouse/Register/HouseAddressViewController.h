//
//  HouseAddressViewController.h
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  小区住址选择控制器，包括栋，单元，室

#import "JRViewController.h"
@class BuildingModel;
@class UnitModel;
@class HouseModel;

typedef enum : NSUInteger {
    BuildingNumner,
    UnitNumber,
    RoomNumber,
} HouseNumberType;

@interface HouseAddressViewController : JRViewControllerWithBackButton

@property  (assign,nonatomic)  HouseNumberType houseNumberType;     // 选择的类型，栋，单元，室
@property  (strong,nonatomic)  BuildingModel   *buildModel;
@property  (strong,nonatomic)  UnitModel       *unitModel;
@property  (strong,nonatomic)  HouseModel      *houseModel;


// dw add V1.1
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *plotNameLab;
@property (strong, nonatomic) NSString * plotsName;
@property (strong, nonatomic) NSString * plotsCid;
// dw end

- (void)refreshHouseDataWithBuildingModel:(BuildingModel *)buildingModel;
- (void)refreshHouseDataWithUnitModel:(BuildingModel *)buildingModel andUnitModel:(UnitModel *)unitModel;



@end
