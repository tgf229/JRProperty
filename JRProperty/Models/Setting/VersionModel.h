//
//  VersionModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@interface VersionModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * version   ; // 最新版本
@property (copy, nonatomic) NSString<Optional> * content   ; // 更新内容
@property (copy, nonatomic) NSString<Optional> * isUpdate  ; // 是否强制更新
@property (copy, nonatomic) NSString<Optional> * urlAddress; // 下载地址
@end
