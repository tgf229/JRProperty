//
//  PlotListModel.h
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol PlotModel <NSObject>

@end

@interface PlotModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * cId; // 小区ID
@property (copy, nonatomic) NSString<Optional> * cName; // 小区名称
@property (copy, nonatomic) NSString<Optional> * city; // 小区所属城市名称
@end

@interface PlotListModel : BaseModel
@property (strong, nonatomic) NSArray<PlotModel,Optional> * doc; 
@end
