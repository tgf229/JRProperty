//
//  InitModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@interface InitModel : BaseModel

@property (copy, nonatomic) NSString<Optional> * flag   ; // 客户端根据该字段判断是否退出应用
@property (copy, nonatomic) NSString<Optional> * id     ; // 物业公司ID
@property (copy, nonatomic) NSString<Optional> * name   ; // 物业公司名称
@property (copy, nonatomic) NSString<Optional> * address; // 物业在小区内的位置
@property (copy, nonatomic) NSString<Optional> * tel    ; // 电话
@property (copy, nonatomic) NSString<Optional> * title  ; // 物业资质名称
@property (copy, nonatomic) NSString<Optional> * titleUrl; //物业资质url地址
@property (copy, nonatomic) NSString<Optional> * content; // 物业公司介绍
@property (copy, nonatomic) NSString<Optional> * logo   ; // 物业公司logo

@end
