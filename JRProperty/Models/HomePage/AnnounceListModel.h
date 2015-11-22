//
//  AnnounceListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  

#import "BaseModel.h"

@protocol AnnounceModel
@end

@interface AnnounceModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * id      ; // 通告活动ID
@property (copy, nonatomic) NSString<Optional> * name    ; // 通告活动名称
@property (copy, nonatomic) NSString<Optional> * desc    ; // 通告活动描述
@property (copy, nonatomic) NSString<Optional> * imageUrl; // 活动图片
@end


@interface AnnounceListModel : BaseModel
@property (strong, nonatomic) NSArray<AnnounceModel, Optional> * doc;
@end
