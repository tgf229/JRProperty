//
//  PraiseListModel.h
//  JRProperty
//
//  Created by YMDQ on 15/12/2.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "BaseModel.h"

@protocol PraiseModel
@end

@interface PraiseModel : JSONModel
@property (copy, nonatomic) NSString<Optional> * eId     ; // 物业员工ID
@property (copy, nonatomic) NSString<Optional> * eName   ; // 物业员工名称
@property (copy, nonatomic) NSString<Optional> * eNum      ; // 物业员工工号
@property (copy, nonatomic) NSString<Optional> * eImageUrl    ; // 物业员工头像
@property (copy, nonatomic) NSString<Optional> * eDepName     ; // 物业员工部门名称
@property (copy, nonatomic) NSString<Optional> * praise; // 物业员工当月被赞次数
@property (copy, nonatomic) NSString<Optional> * top   ; // 此物业员工曾经获得冠军的次数
@property (copy, nonatomic) NSString<Optional> * isPraise ; // 当前用户是否已表扬0否1是
@end

@interface PraiseListModel : BaseModel
@property(copy,nonatomic) NSString<Optional> * praiseTimes       ; //当前用户当月剩余表扬次数
@property(copy,nonatomic) NSString<Optional> * currentTime       ; //当前服务器时间 YYYYMM
@property (strong, nonatomic) NSArray<PraiseModel, Optional> * doc;
@end
