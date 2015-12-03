//
//  PraiseListService.h
//  JRProperty
//
//  Created by YMDQ on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface PraiseListService : BaseService

/**
 * 工单提交—报修&投诉&表扬
 * @param cId    小区ID
 * @param uId    用户ID
 * @param time    时间
 * @param success 成功后调用的block
 * @param failure 失败后调用的block
 */
- (void) Bus200501:(NSString *)cId
               uId:(NSString *)uId
               time:(NSString *)time
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
