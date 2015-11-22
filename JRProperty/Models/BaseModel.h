//
//  BaseModel.h
//  JRProperty
//
//  Created by wangzheng on 14-11-7.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  实体类基类

#import "JSONModel.h"

/**
 * 实体类基类
 */
@interface BaseModel : JSONModel
@property(nonatomic,copy)NSString<Optional> *retcode;                     //返回code
@property(nonatomic,copy)NSString<Optional> *retinfo;                     //返回信息
/**
 * 加密数据调用此方法实现对象反射
 */
- (instancetype)initWithEncryptData:(NSData *)data error:(NSError **)error;

@end
