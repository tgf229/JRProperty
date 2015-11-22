//
//  InitService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface InitService : BaseService

/**
 * 初始化接口
 * @param version 版本号
 * @param type    手机类型  1安卓 2苹果
 * @param model   手机型号  如:HTCxx
 * @param imei    手机设备唯一号
 * @param cId     小区ID
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus100101:(NSString *)version
             type:(NSString *)type
             model:(NSString *)model
             imei:(NSString *)imei
             cid:(NSString *)cId
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

@end
