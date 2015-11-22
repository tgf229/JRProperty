//
//  ChargeListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol ChargeModel
@end

@interface ChargeModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * id   ; // 缴费记录ID
@property (copy, nonatomic) NSString<Optional> * hId  ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName; // 房屋名称
@property (copy, nonatomic) NSString<Optional> * name ; // 费用名称
@property (copy, nonatomic) NSString<Optional> * type ; // 费用类型ID
@property (copy, nonatomic) NSString<Optional> * money; // 缴费金额
@property (copy, nonatomic) NSString<Optional> * time ; // 缴费时间
@end

@interface ChargeListModel : BaseModel
@property (strong, nonatomic) NSArray<ChargeModel, Optional> * doc;
@end

