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

//发表话题
-(void) Bus300702:  (NSString *)cId
              uId:  (NSString *)uId
          content:  (NSString *)content
             flag:  (NSString *)flag
             file:  (NSArray *)file
        phoneType:  (NSString *)phoneType
            model:  (NSString *)model
             type:  (NSString *)type
         voteList:  (NSArray *)voteList
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//话题投票
-(void) Bus301002:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
           voteId:  (NSString *)voteId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//话题评论&回复
-(void) Bus301102:  (NSString *)cId
              aId:  (NSString *)aId
              uId:  (NSString *)uId
         replyUId:  (NSString *)replyUId
        commentId:  (NSString *)commentId
          content:  (NSString *)content
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//新回复消息列表
-(void) Bus302102:  (NSString *)cId
              uId:  (NSString *)uId
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//举报
-(void) Bus302202:  (NSString *)aId
              uId:  (NSString *)uId
             type:  (NSString *)type
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

//用户话题列表查询
-(void) Bus301402:  (NSString *)cId
              uId:  (NSString *)uId
         queryUId:  (NSString *)queryUId
             page:  (NSString *)page
              num:  (NSString *)num
        queryTime:  (NSString *)queryTime
          success:  (void (^)(id responseObject))success
          failure:  (void (^)(NSError *error))failure;

@end
