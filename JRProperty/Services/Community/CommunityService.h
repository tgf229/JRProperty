//
//  CommunityService.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseService.h"

@interface CommunityService : BaseService

-(void) Bus302301:  (NSString *)uId
              cId:  (NSString *)cId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;


@end
