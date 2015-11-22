//
//  CircleListModel.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
#import "SquareModel.h"

@interface CircleListModel : BaseModel
@property (strong, nonatomic) NSMutableArray<CircleInfoModel, Optional>  *doc;
@end
