//
//  PraiseDetailListModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/3.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"
@class PraiseDetailModel;
@protocol PassPraiseDetailModelDelegate <NSObject>
-(void)passPraiseDetailModel2Show:(PraiseDetailModel*)model;
@end

@protocol PraiseDetailModel<NSObject>
@end

@interface PraiseDetailModel:JSONModel
@property(copy,nonatomic) NSString<Optional> * uId; // 用户id
@property(copy,nonatomic) NSString<Optional> * nickName; // 用户昵称
@property(copy,nonatomic) NSString<Optional> * tag; // 标签id数组字符串
@property(copy,nonatomic) NSString<Optional> * content; // 评论内容
@property(copy,nonatomic) NSString<Optional> * time; // 评论发布时间距当前时间
@property(copy,nonatomic) NSString<Optional> * imageUrl; // 用户头像地址
@end

@interface PraiseDetailListModel : BaseModel

@property(copy,nonatomic) NSString<Optional> * queryTime; // 查询时间
@property(strong,nonatomic) NSArray<PraiseDetailModel,Optional> * doc;

@end
