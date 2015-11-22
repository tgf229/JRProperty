//
//  SettingService.h
//  JRProperty
//
//  Created by wangzheng on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface SettingService : BaseService


/**
 * 3.5.1	意见反馈
 * @param uId     用户ID
 * @param version 版本号
 * @param type    手机类型
 * @param model   手机型号
 * @param imei    设备唯一号
 * @param contact 用户联系方式
 * @param remark  用户反馈意见信息
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus500101:(NSString *)uId
           version:(NSString *)version
              type:(NSString *)type
             model:(NSString *)model
              imei:(NSString *)imei
           contact:(NSString *)contact
            remark:(NSString *)remark
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/**
 * 3.5.2	版本更新检查
 * @param version 版本号
 * @param type    手机类型
 * @param imei    设备唯一号
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus500201:(NSString *)version
              type:(NSString *)type
              imei:(NSString *)imei
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
