//
//  BuildingListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"


@protocol HouseModel
@end

@protocol UnitModel
@end

@protocol BuildingModel
@end

@interface HouseModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * hId   ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName ; // 房号
@property (copy, nonatomic) NSString<Optional> * idCard; // 业主身份证号
@property (copy, nonatomic) NSString<Optional> * phone ; // 业主预留手机号
@end

@interface UnitModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * dId  ; // 单元ID
@property (copy, nonatomic) NSString<Optional> * dName; // 单元名称
@property (strong, nonatomic) NSMutableArray<HouseModel, Optional> *dList;
@end

@interface BuildingModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * bId  ; // 栋ID
@property (copy, nonatomic) NSString<Optional> * bName; // 栋名称
@property (strong, nonatomic) NSMutableArray<UnitModel, Optional> *bList;
@end

@interface BuildingListModel : BaseModel
@property (strong, nonatomic) NSMutableArray<BuildingModel, Optional> *doc;
@end
