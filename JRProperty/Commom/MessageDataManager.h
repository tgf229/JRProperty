//
//  MessageDataManager.h
//  JRProperty
//
//  Created by duwen on 14/12/3.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MessageListModel.h"
#import "ReplyListModel.h"
#import "JRHeader.h"
#import "JRDefine.h"

@interface MessageDataManager : NSObject
+ (id)defaultManager;
- (BOOL)closeDB;

/**********************************************我的消息**************************************************/

/**
 *  获取我的消息
 *
 *  @param userId   用户id
 *  @param cID      小区id
 
 *  @return 我的消息
 */
-(NSMutableArray *)queryMyMessage:(NSString*)userId cId:(NSString *)_cId;

/**
 *  获取我的未读消息数目
 *
 *  @param storeId  门店id
 *
 *  @return 我的消息
 */
-(int)queryMyUnReadMessage:(NSString*)userId cId:(NSString *)_cId;;

/**
 *  更新信息已读
 *
 *  @param userId  用户id
 *
 *  @return 操作结果
 */
-(BOOL)updateMyMessage:(NSString*)userId cId:(NSString *)_cId;

/**
 *  添加信息
 *
 *  @param messageModel  消息实体
 *
 *  @return 操作结果
 */
-(BOOL)insertMessage:(MessageListModel*)messageListModel userId:(NSString *)_userId cId:(NSString *)_cId;

/**
 *  添加圈子评论记录
 *
 *  @param replyModel  评论实体
 *
 *  @return 操作结果
 */
-(BOOL)insertCircleReply:(ReplyListModel*)replyListModel userId:(NSString *)_userId cId:(NSString *)_cId;
/**
 *  查询圈子回复消息记录
 *
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 操作结果
 */
-(NSMutableArray*)queryCircleReply:(NSString *)userId cId:(NSString *)_cId Page:(int)page;
/**********************************************轮播通告**************************************************/
/**
 *  插入赞或踩轮播数据
 *
 *  @param aId    轮播通告ID
 *  @param _staus 1 赞 0 踩
 *
 *  @return 操作结果
 */
- (BOOL)insertAnnounceWithId:(NSString *)aId staus:(NSString *)_staus;

/**
 *  查询是否赞或踩
 *
 *  @param aId 轮播通告ID
 *
 *  @return 操作结果
 */
- (int)queryStausWithAnnounceId:(NSString *)aId;

@end
