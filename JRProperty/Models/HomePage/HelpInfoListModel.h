//
//  HelpInfoModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
@protocol HelpInfoModel
@end

@interface HelpInfoModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * id     ; // 信息ID
@property (copy, nonatomic) NSString<Optional> * tel    ; // 电话
@property (copy, nonatomic) NSString<Optional> * name   ; // 标题
@property (copy, nonatomic) NSString<Optional> * address; // 地址
@end
@interface HelpInfoListModel : BaseModel
@property (strong, nonatomic) NSArray<HelpInfoModel, Optional> * doc;
@end
