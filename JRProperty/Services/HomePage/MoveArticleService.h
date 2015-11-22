//
//  MoveArticleService.h
//  JRProperty
//
//  Created by dw on 15/3/24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface MoveArticleService : BaseService

/**
 *  社区-社区话题转移 V1.1
 *
 *  @param fromId     话题所属的社区ID
 *  @param _toId      要转移到的社区ID
 *  @param _articleId 话题ID
 *  @param _uId       用户ID
 *  @param success    成功回调
 *  @param failure    失败回调  
 */
- (void) Bus101301:(NSString *)fromId
              toId:(NSString *)_toId
         articleId:(NSString *)_articleId
               uId:(NSString *)_uId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end
