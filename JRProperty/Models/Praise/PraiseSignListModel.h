//
//  PraiseSignListModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/5.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol PraiseSignModel
@end

@interface PraiseSignModel : JSONModel

@property(copy,nonatomic) NSString<Optional> * tId; // 表扬标签id
@property(copy,nonatomic) NSString<Optional> * tName; // 表扬标签名称
@property(copy,nonatomic) NSString<Optional> * tStatus; // 表扬标签状态0停用1启用

@end

@interface PraiseSignListModel : BaseModel
@property (strong, nonatomic) NSArray<PraiseSignModel, Optional> * doc;
@end
