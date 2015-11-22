//
//  BillListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol MoneyModel
@end

@protocol FeeModel
@end

@protocol BillModel
@end

@interface MoneyModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * money; // 缴费金额
@property (copy, nonatomic) NSString<Optional> * time ; // 缴费时间
@end
@interface FeeModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * name      ; // 费用名称
@property (copy, nonatomic) NSString<Optional> * type      ; // 费用类型ID
@property (copy, nonatomic) NSString<Optional> * typeName  ; // 费用类型名称
@property (copy, nonatomic) NSString<Optional> * totalMoney; // 应收金额
@property (copy, nonatomic) NSString<Optional> * money     ; // 已缴费用
@property (copy, nonatomic) NSString<Optional> * status    ; // 缴费状态
@property (strong, nonatomic) NSArray<MoneyModel, Optional> * moneyList;
@end
@interface BillModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * hId  ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName; // 房屋名称
@property (strong, nonatomic) NSArray<FeeModel, Optional> * hList;
@end
@interface BillListModel : BaseModel
@property (strong, nonatomic) NSArray<BillModel, Optional> * doc;
@end
