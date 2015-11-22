//
//  NewPackageNumModel.h
//  JRProperty
//
//  Created by duwen on 14/12/1.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@interface NewPackageNumModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * theNewPost; // 未收取的邮包数量
@property (copy, nonatomic) NSString<Optional> * theNewReply; // 未读圈子回复数量
@end
