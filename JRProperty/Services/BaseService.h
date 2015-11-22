//
//  BaseService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-7.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  Service基类

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "DES3Util.h"
#import "BaseModel.h"
#import "JRDefine.h"
#import "JRHeader.h"
@interface BaseService : NSObject

/**
 * service方法示例
 * @param inputString 入参  根据实际业务，可有多个，也可多种类型
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) serviceDemo:(NSString *)inputString
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
@end
