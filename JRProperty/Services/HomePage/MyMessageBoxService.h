//
//  MyMessageBoxService.h
//  JRProperty
//
//  Created by YMDQ on 16/1/4.
//  Copyright © 2016年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface MyMessageBoxService : BaseService
/**
 *  我的消息查询 V2.0
 *
 *  @param cId     小区ID
 *  @param uId       用户ID
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void) Bus100702:(NSString *)cId
               uId:(NSString *)uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

@end
