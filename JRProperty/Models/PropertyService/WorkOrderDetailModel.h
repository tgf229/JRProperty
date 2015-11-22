//
//  WorkOrderDetailModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"


@protocol WorkImageModel
@end

@protocol WorkPathModel
@end

@interface WorkImageModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * imageUrlS; // 缩略图地址
@property (copy, nonatomic) NSString<Optional> * imageUrlL; // 大图地址
@end

@interface WorkPathModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * uName    ; // 处理人
@property (copy, nonatomic) NSString<Optional> * uImageUrl; // 处理人头像
@property (copy, nonatomic) NSString<Optional> * depName  ; // 处理人部门名称
@property (copy, nonatomic) NSString<Optional> * content  ; // 处理描述
@property (copy, nonatomic) NSString<Optional> * desc   ;   // 内容
@property (copy, nonatomic) NSString<Optional> * time     ; // 处理时间距离当前时间
@property (strong, nonatomic) NSArray<WorkImageModel, Optional> * imageList;
@end

@interface WorkOrderDetailModel : BaseModel
@property (copy, nonatomic) NSString<Optional> * uId    ; // 提交工单的用户ID
@property (copy, nonatomic) NSString<Optional> * uName  ; // 提交工单的用户昵称
@property (copy, nonatomic) NSString<Optional> * image  ; // 提交工单的用户头像
@property (copy, nonatomic) NSString<Optional> * time   ; // 工单创建时间
@property (copy, nonatomic) NSString<Optional> * content; // 内容
@property (copy, nonatomic) NSString<Optional> * type   ; // 类型
@property (copy, nonatomic) NSString<Optional> * status ; // 当前状态
@property (strong, nonatomic) NSArray<WorkImageModel, Optional> * imageList;
@property (strong, nonatomic) NSArray<WorkPathModel, Optional> * path;

@end
