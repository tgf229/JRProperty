//
//  MyMessageBoxListModel.h
//  JRProperty
//
//  Created by YMDQ on 16/1/4.
//  Copyright © 2016年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol MyMessageBoxModel

@end

@interface MyMessageBoxModel : JSONModel
@property(copy,nonatomic) NSString<Optional> * mId;
@property(copy,nonatomic) NSString<Optional> * type;
@property(copy,nonatomic) NSString<Optional> * cId;
@property(copy,nonatomic) NSString<Optional> * cName;
@property(copy,nonatomic) NSString<Optional> * aId;
@property(copy,nonatomic) NSString<Optional> * content;
@property(copy,nonatomic) NSString<Optional> * time;
@property(copy,nonatomic) NSString<Optional> * imageUrl;
@property(copy,nonatomic) NSString<Optional> * replyUId;
@property(copy,nonatomic) NSString<Optional> * replyNickName;
@property(copy,nonatomic) NSString<Optional> * replyCommentId;
@property(copy,nonatomic) NSString<Optional> * replyContent;
@property(copy,nonatomic) NSString<Optional> * replyHeadUrl;
@property(copy,nonatomic) NSString<Optional> * userLevel;
@property(copy,nonatomic) NSString<Optional> * beReplyUId;
@property(copy,nonatomic) NSString<Optional> * beReplyNickName;
@end

@interface MyMessageBoxListModel : BaseModel
@property(nonatomic,strong) NSArray<MyMessageBoxModel,Optional> * doc;
@end
