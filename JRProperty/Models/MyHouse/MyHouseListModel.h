//
//  MyHouseListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol MyHouseModel
@end

@interface MyHouseModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * cId  ; // 小区ID
@property (copy, nonatomic) NSString<Optional> * cName; // 小区名称
@property (copy, nonatomic) NSString<Optional> * bId  ; // 栋ID
@property (copy, nonatomic) NSString<Optional> * bName; // 栋名称
@property (copy, nonatomic) NSString<Optional> * dId  ; // 单元ID
@property (copy, nonatomic) NSString<Optional> * dName; // 单元名称
@property (copy, nonatomic) NSString<Optional> * hId  ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName; // 房号
@property (copy, nonatomic) NSString<Optional> * flag; //  状态：0:正常 1:冻结

@end
@interface MyHouseListModel : BaseModel
@property (strong, nonatomic) NSMutableArray<MyHouseModel, Optional> *doc;
@end
