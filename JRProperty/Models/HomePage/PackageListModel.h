//
//  PackageListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol PackageModel
@end

@interface PackageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * id   ; // 邮包ID
@property (copy, nonatomic) NSString<Optional> * hId  ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName; // 房屋名称
@property (copy, nonatomic) NSString<Optional> * name ; // 物流公司名称
@property (copy, nonatomic) NSString<Optional> * logo ; // 物流公司LOGO
@property (copy, nonatomic) NSString<Optional> * num  ; // 物流单号
@property (copy, nonatomic) NSString<Optional> * time ; // 送达时间
@property (copy, nonatomic) NSString<Optional> * type ; // 状态类型（1 待领取 2 已领取）
@end

@interface PackageListModel : BaseModel
@property (strong, nonatomic) NSArray<PackageModel, Optional> * doc;
@end
