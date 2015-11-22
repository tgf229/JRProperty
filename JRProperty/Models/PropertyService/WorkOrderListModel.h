//
//  WorkOrderListModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@protocol WorkOrderModel
@end

@interface WorkOrderModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * hId     ; // 房屋ID
@property (copy, nonatomic) NSString<Optional> * hName   ; // 房屋名称
@property (copy, nonatomic) NSString<Optional> * id      ; // 工单ID
@property (copy, nonatomic) NSString<Optional> * time    ; // 工单创建时间
@property (copy, nonatomic) NSString<Optional> * uId     ; // 提交工单的用户ID
@property (copy, nonatomic) NSString<Optional> * nickName; // 提交工单的用户昵称
@property (copy, nonatomic) NSString<Optional> * image   ; // 提交工单的用户头像
@property (copy, nonatomic) NSString<Optional> * content ; // 内容
@property (copy, nonatomic) NSString<Optional> * type    ; // 类型
@property (copy, nonatomic) NSString<Optional> * status  ; // 当前状态
@end

@interface WorkOrderListModel : BaseModel
@property (strong, nonatomic) NSArray<WorkOrderModel, Optional> * doc;
@end
