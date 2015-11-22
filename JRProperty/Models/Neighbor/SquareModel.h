//
//  SquareModel.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-14.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol ArticleModel
@end

@protocol CircleInfoModel
@end

@interface ArticleModel : JSONModel
@property (copy, nonatomic) NSString<Optional>    *id;          // 话题id
@property (copy, nonatomic) NSString<Optional>    *content;     // 文本内容
@property (copy, nonatomic) NSString<Optional>    *from;        // 来自圈子
@property (copy, nonatomic) NSString<Optional>    *image;       // 图片
@end

@interface CircleInfoModel : JSONModel
@property (copy, nonatomic) NSString<Optional>    *id;       // 圈子id
@property (copy, nonatomic) NSString<Optional>    *name;     // 圈子名称
@property (copy, nonatomic) NSString<Optional>    *icon;     // 图标
@property (copy, nonatomic) NSString<Optional>    *desc;     // 描述
@property (copy, nonatomic) NSString<Optional>    *time;     // 创建日期
@property (copy, nonatomic) NSString<Optional>    *userCount;   // 圈子加入人数
@property (copy, nonatomic) NSString<Optional>    *articleCount;     // 话题数目
@end

@interface SquareModel : BaseModel
@property (strong, nonatomic) NSMutableArray<CircleInfoModel, Optional>  * ocList;
@property (strong, nonatomic) NSMutableArray<CircleInfoModel, Optional>  * hcList;
@property (strong, nonatomic) NSMutableArray<ArticleModel, Optional>     * ocArticleList;
@property (strong, nonatomic) NSMutableArray<ArticleModel, Optional>     * hcArticleList;
@end
