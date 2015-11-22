//
//  MessageListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol MessageModel
@end

@interface MessageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * id     ; // 消息ID
@property (copy, nonatomic) NSString<Optional> * content; // 消息内容
@property (copy, nonatomic) NSString<Optional> * time   ; // 推送时间距离当前时间

// dw add V1.1
@property (copy, nonatomic) NSString<Optional> * name;     // 消息名称
@property (copy, nonatomic) NSString<Optional> * type;     // 消息类型 1通告 2营销推广 3服务信息 4其他 5快递
// dw end
@end

@interface MessageListModel : BaseModel
@property (strong, nonatomic) NSArray<MessageModel, Optional> * doc;
@end
