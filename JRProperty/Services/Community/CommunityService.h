//
//  CommunityService.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface CommunityService : BaseService

//话题列表查询
-(void) Bus302301:  (NSString *)uId
              cId:  (NSString *)cId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//话题详情查询
-(void) Bus301902:  (NSString *)uId
              aId:  (NSString *)aId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//评论列表查询
-(void) Bus301202:  (NSString *)aId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//点赞&取消赞
-(void) Bus300802:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
             type:  (NSString *)type
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

@end
