//
//  MessageDataManager.m
//  JRProperty
//
//  Created by duwen on 14/12/3.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MessageDataManager.h"

@implementation MessageDataManager
{
    FMDatabase *_db;
    dispatch_queue_t _dbQueue;
}

+ (id)defaultManager
{
    static MessageDataManager *_manager = nil;
    
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"messageDatabase.db"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MessageDataManager alloc] initWithDBName:dbPath];
    });
    return _manager;
}

//初始化数据库
- (id)initWithDBName:(NSString *)dbName
{
    if (self = [super init])
    {
        _dbQueue = dispatch_queue_create("messageDataManagerQueue", 0);
        typeof(MessageDataManager*) bself = self;
        __block BOOL _bResult = YES;
        dispatch_sync(_dbQueue, ^{
            bself->_db = [FMDatabase databaseWithPath:dbName];
            FMDBRetain(bself->_db);
            if (![bself->_db open])
            {
                NSLog(@"open db error");
                _bResult = NO;
                return ;
            }
            
            // 我的消息 isRead 1 未读 0 已读
            if (![bself->_db executeUpdate:@"CREATE TABLE IF NOT EXISTS my_message(ROWID integer PRIMARY KEY AUTOINCREMENT UNIQUE, userId TEXT,cId TEXT,mId TEXT,content TEXT,time TEXT,isRead TEXT)"])
            {
                NSLog(@"create table my_message error");
                _bResult = NO;
                return;
            }
            
            // 轮播通告 isPrise 1 赞 0 踩
            if (![bself->_db executeUpdate:@"CREATE TABLE IF NOT EXISTS announce_table(ROWID integer PRIMARY KEY AUTOINCREMENT UNIQUE, announceId TEXT,isPrise TEXT)"])
            {
                NSLog(@"create table my_message error");
                _bResult = NO;
                return;
            }
            // 圈子评论消息 v1.1
            if (![bself->_db executeUpdate:@"CREATE TABLE IF NOT EXISTS circle_reply(ROWID integer PRIMARY KEY AUTOINCREMENT UNIQUE, userId TEXT,articleId TEXT,time TEXT,content TEXT,imageUrl TEXT,replyUId TEXT,replyNickName TEXT, replyCommentId TEXT,replyContent TEXT,replyHeadUrl TEXT,beReplyUId TEXT,beReplyNickName TEXT,userLevel TEXT,cId TEXT)"])
            {
                NSLog(@"create table circle_reply error");
                _bResult = NO;
                return;
            }
            // 我的消息 v2.0
            if (![bself->_db executeUpdate:@"CREATE TABLE IF NOT EXISTS my_message_box(ROWID integer PRIMARY KEY AUTOINCREMENT UNIQUE, mId TEXT,type TEXT,aId TEXT,time TEXT,content TEXT,imageUrl TEXT,replyNickName TEXT, replyCommentId TEXT,replyContent TEXT,replyHeadUrl TEXT,beReplyUId TEXT,beReplyNickName TEXT,userLevel TEXT,replyUId TEXT,userId TEXT,cId TEXT,cName TEXT,isRead TEXT)"]) {
                NSLog(@"create table my_message_box error");
                _bResult = NO;
                return;
            }

            // dw add V1.1
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isUpdateDB"] == 1 || ![[NSUserDefaults standardUserDefaults] integerForKey:@"isUpdateDB"]) {
                [[NSUserDefaults standardUserDefaults] setInteger:VERSION_NUM_FOR_DB forKey:@"isUpdateDB"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (![bself->_db executeUpdate:@"ALTER TABLE my_message ADD COLUMN name text"])
                {
                    _bResult = NO;
                    return;
                }
                if (![bself->_db executeUpdate:@"ALTER TABLE my_message ADD COLUMN type text"])
                {
                    _bResult = NO;
                    return;
                }
            }
            // dw end
        });
        
        if (!_bResult)
        {
            NSLog(@"initWithDBName :error");
            return nil;
        }
    }
    return self;
}

//关闭数据库
- (BOOL)closeDB
{
    __block BOOL bResult = YES;
    typeof(MessageDataManager*) bself = self;
    dispatch_sync(_dbQueue, ^{
        bResult = [bself->_db close];
        FMDBRelease(bself->_db);
        bself->_db = 0x00;
    });
    return bResult;
}

/********************************************** 我的消息**************************************************/

/**
 *  查询我的消息
 *
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 操作结果
 */
-(NSMutableArray*)queryMyMessage:(NSString *)userId cId:(NSString *)_cId{
    typeof(MessageDataManager*) bself = self;
    __block NSMutableArray *_messageArray = [NSMutableArray array];
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = nil;
//        if([@"" isEqualToString:userId] ){
//            rs = [bself->_db executeQuery:@"SELECT * FROM my_message  order by time"];
//        }else{
            rs = [bself->_db executeQuery:@"SELECT * FROM my_message WHERE userId = ? and cId = ? order by time desc ", userId,_cId];
//        }
        while ([rs next]) {
            @autoreleasepool {
                MessageModel *_info = [[MessageModel alloc] init];
                _info.time = [rs stringForColumn:@"time"];                  // 消息时间
                _info.id = [rs stringForColumn:@"mId"];        // 消息id
                _info.content = [rs stringForColumn:@"content"];            // 消息内容
                _info.name = [rs stringForColumn:@"name"];
                _info.type = [rs stringForColumn:@"type"];
                NSString *isRead = [rs stringForColumn:@"isRead"];
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_info,@"messageModel",isRead,@"isRead", nil];
                [_messageArray addObject:dic];
            }
        }
    });
    return _messageArray;
}

/**
 *  更新信息已读
 *
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 操作结果
 */
-(BOOL)updateMyMessage:(NSString *)userId cId:(NSString *)_cId{
    typeof(MessageDataManager*) bself = self;
    __block BOOL _bResult = YES;
    dispatch_sync(_dbQueue, ^{
        _bResult = [bself->_db executeUpdate:@"update my_message set isRead = 0 where userid = ? and cId = ?",userId,_cId];
    });
    
    return _bResult;
}

/**
 *  获取我的未读消息数目
 *
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 我的消息
 */
-(int)queryMyUnReadMessage:(NSString *)userId cId:(NSString *)_cId{
    typeof(MessageDataManager*) bself = self;
    __block int _count = 0;
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = [bself->_db executeQuery:@"SELECT * FROM my_message WHERE userid = ? and cId = ? and isRead = 1 ", userId,_cId];
        while ([rs next]) {
            @autoreleasepool {
                _count +=1;
            }
        }
    });
    return _count;
}

/**
 *  添加信息
 *
 *  @param messageListModel  消息实体
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 操作结果
 */
-(BOOL)insertMessage:(MessageListModel*)messageListModel userId:(NSString *)_userId cId:(NSString *)_cId{
    __block BOOL _bResult = YES;
    typeof(MessageDataManager*) bself = self;
    dispatch_sync(_dbQueue, ^{
        for (MessageModel *messageModel in messageListModel.doc) {
            FMResultSet *rs = [bself->_db executeQuery:@"SELECT * FROM my_message WHERE userId = ? and cId = ? and mId = ?",_userId,_cId,messageModel.id];
            if (![rs next]) {
                _bResult = [bself->_db executeUpdate:@"INSERT INTO my_message (userId,cId,mId,content,time,isRead,name,type) VALUES (?,?,?,?,?,?,?,?)",_userId,_cId,messageModel.id,messageModel.content,messageModel.time,@"1",messageModel.name,messageModel.type];
            }
        }
    });
    return _bResult;
}


-(BOOL)insertCircleReply:(ReplyListModel*)replyListModel userId:(NSString *)_userId cId:(NSString *)_cId{
    __block BOOL _bResult = YES;
    typeof(MessageDataManager*) bself = self;
    dispatch_sync(_dbQueue, ^{
        for (ReplyModel *replyModel in replyListModel.doc) {
            
            _bResult = [bself->_db executeUpdate:@"INSERT INTO circle_reply (userId,articleId ,time ,content ,imageUrl ,replyUId ,replyNickName , replyCommentId ,replyContent ,replyHeadUrl ,beReplyUId ,beReplyNickName ,userLevel,cId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",_userId,replyModel.articleId,replyModel.time,replyModel.content,replyModel.imageUrl,replyModel.replyUId,replyModel.replyNickName,replyModel.replyCommentId,replyModel.replyContent,replyModel.replyHeadUrl,replyModel.beReplyUId,replyModel.beReplyNickName,replyModel.userLevel,_cId];
        }
    });
    return _bResult;
}
/**
 *  查询圈子回复消息记录
 *
 *  @param userId   用户id
 *  @param cId      小区id
 *
 *  @return 操作结果
 */
-(NSMutableArray*)queryCircleReply:(NSString *)userId cId:(NSString *)_cId Page:(int)page{
    typeof(MessageDataManager*) bself = self;
    __block NSMutableArray *_messageArray = [NSMutableArray array];
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = nil;
       
        rs = [bself->_db executeQuery:@"SELECT * FROM circle_reply WHERE userId = ?  and cId = ? order by time desc", userId,_cId];
        //        }
        while ([rs next]) {
            @autoreleasepool {
                ReplyModel *_info = [[ReplyModel alloc] init];
                _info.time = [rs stringForColumn:@"time"];                  // 消息时间
                _info.content = [rs stringForColumn:@"content"];        // 消息id
                _info.replyContent = [rs stringForColumn:@"replyContent"];            // 消息内容
                _info.userId = [rs stringForColumn:@"userId"];
                _info.replyHeadUrl = [rs stringForColumn:@"replyHeadUrl"];
                _info.replyCommentId = [rs stringForColumn:@"replyCommentId"];                  // 消息时间
                _info.articleId = [rs stringForColumn:@"articleId"];        // 消息id
                _info.beReplyNickName = [rs stringForColumn:@"beReplyNickName"];            // 消息内容
                _info.beReplyUId = [rs stringForColumn:@"beReplyUId"];
                _info.userLevel = [rs stringForColumn:@"userLevel"];
                _info.imageUrl = [rs stringForColumn:@"imageUrl"];            // 消息内容
                _info.replyNickName = [rs stringForColumn:@"replyNickName"];
                _info.replyUId = [rs stringForColumn:@"replyUId"];
                _info.cId = [rs stringForColumn:@"cId"];
                [_messageArray addObject:_info];
            }
        }
    });
    return _messageArray;
}

/**********************************************轮播通告**************************************************/

/**
 *  插入赞或踩轮播数据
 *
 *  @param aId    轮播通告ID
 *  @param _staus 1 赞 0 踩
 *
 *  @return 操作结果
 */
- (BOOL)insertAnnounceWithId:(NSString *)aId staus:(NSString *)_staus{
    __block BOOL _bResult = YES;
    typeof(MessageDataManager*) bself = self;
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = [bself->_db executeQuery:@"SELECT * FROM announce_table WHERE and announceId = ?",aId];
        if ([rs next]) {
            _bResult = NO;
        }else{
            _bResult = [bself->_db executeUpdate:@"INSERT INTO announce_table (announceId,isPrise) VALUES (?,?)",aId,_staus];
        }
    });
    return _bResult;
}

/**
 *  查询是否赞或踩
 *
 *  @param aId 轮播通告ID
 *
 *  @return 操作结果
 */
- (int)queryStausWithAnnounceId:(NSString *)aId{
    typeof(MessageDataManager*) bself = self;
    __block int _bResult = 999;
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = [bself->_db executeQuery:@"SELECT * FROM announce_table WHERE announceId = ?",aId];
        if ([rs next]) {
            _bResult = [rs intForColumn:@"isPrise"];
        }
    });
    return _bResult;
}

/**
 *  添加信息
 *
 *  @param messageModel  消息实体
 *
 *  @return 操作结果
 */
-(BOOL)insertMessageBox:(MyMessageBoxListModel*)myMessageBoxListModel userId:(NSString *)_userId{
    __block BOOL _bResult = YES;
    typeof(MessageDataManager*) bself = self;
    dispatch_sync(_dbQueue, ^{
        for (MyMessageBoxModel *myMessageBoxModel in myMessageBoxListModel.doc) {
            FMResultSet *rs = [bself->_db executeQuery:@"SELECT * FROM my_message_box WHERE userId = ? and type = ? and mId = ? and aId = ?",_userId,myMessageBoxModel.type,myMessageBoxModel.mId,myMessageBoxModel.aId];
            if (![rs next]) {
                _bResult = [bself->_db executeUpdate:@"INSERT INTO my_message_box (mId,type,aId,time,content,imageUrl,replyNickName,replyCommentId,replyContent,replyHeadUrl,beReplyUId,beReplyNickName,userLevel,replyUId,userId,cId,cName,isRead) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",myMessageBoxModel.mId,myMessageBoxModel.type,myMessageBoxModel.aId,myMessageBoxModel.time,myMessageBoxModel.content,myMessageBoxModel.imageUrl,myMessageBoxModel.replyNickName,myMessageBoxModel.replyCommentId,myMessageBoxModel.replyContent,myMessageBoxModel.replyHeadUrl,myMessageBoxModel.beReplyUId,myMessageBoxModel.beReplyNickName,myMessageBoxModel.userLevel,myMessageBoxModel.replyUId,_userId,myMessageBoxModel.cId,myMessageBoxModel.cName,@"0"];
            }
        }
    });

    return _bResult;
}

/**
 *  更新信息已读v2.0
 *
 *  @param userId  用户id
 *
 *  @return 操作结果
 */
-(BOOL)updateMyMessageBox:(NSString*)userId rowId:(NSString *)rowId{
    typeof(MessageDataManager*) bself = self;
    __block BOOL _bResult = YES;
    dispatch_sync(_dbQueue, ^{
        _bResult = [bself->_db executeUpdate:@"update my_message_box set isRead = 1 where userid = ? and ROWID = ?",userId,rowId];
    });
    
    return _bResult;
}

/**
 *  获取我的消息v2.0
 *
 *  @param userId   用户id
 *  @param isRead   是否已读0否1是
 
 *  @return 我的消息
 */
-(NSMutableArray *)queryMyMessageBox:(NSString*)userId isRead:(NSString *)isRead{
    typeof(MessageDataManager*) bself = self;
    __block NSMutableArray *_messageArray = [NSMutableArray array];
    dispatch_sync(_dbQueue, ^{
        FMResultSet *rs = nil;
        //        if([@"" isEqualToString:userId] ){
        //            rs = [bself->_db executeQuery:@"SELECT * FROM my_message  order by time"];
        //        }else{
        rs = [bself->_db executeQuery:@"SELECT * FROM my_message_box WHERE userId = ? and isRead = ? order by time desc ", userId,isRead];
        //        }
        while ([rs next]) {
            @autoreleasepool {
                MyMessageBoxModel *_info = [[MyMessageBoxModel alloc] init];
                _info.rowId = [rs stringForColumn:@"ROWID"];                  // 消息时间
                _info.mId = [rs stringForColumn:@"mId"];        // 消息id
                _info.content = [rs stringForColumn:@"content"];            // 消息内容
                _info.aId = [rs stringForColumn:@"aId"];
                _info.type = [rs stringForColumn:@"type"];
                _info.time = [rs stringForColumn:@"time"];
                _info.imageUrl = [rs stringForColumn:@"imageUrl"];
                _info.replyNickName = [rs stringForColumn: @"replyNickName"];
                _info.replyCommentId = [rs stringForColumn:@"replyCommentId"];
                _info.replyContent = [rs stringForColumn:@"replyContent"];
                _info.replyHeadUrl = [rs stringForColumn:@"replyHeadUrl"];
                _info.beReplyUId = [rs stringForColumn:@"beReplyUId"];
                _info.beReplyNickName = [rs stringForColumn:@"beReplyNickName"];
                _info.userLevel = [rs stringForColumn:@"userLevel"];
                _info.replyUId = [rs stringForColumn:@"replyUId"];
                _info.userId = [rs stringForColumn:@"userId"];
                _info.cId = [rs stringForColumn:@"cId"];
                _info.cName = [rs stringForColumn:@"cName"];
                _info.isRead = [rs stringForColumn:@"isRead"];
                
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_info,@"messageModel",isRead,@"isRead", nil];
                [_messageArray addObject:_info];
            }
        }
    });
    return _messageArray;
}


@end
