//
//  JRPropertyUntils.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-14.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JRPropertyUntils : NSObject

/**
 *  计算控制器可展示视图的大小
 *
 *  @param owner 控制器的拥有者
 *  @param exist 是否存在TabBar
 *
 *  @return 返回展示区域的大小
 */
+ (CGRect)layoutVisitOwner:(UIViewController *)owner existTabBar:(BOOL)exist;

/**
 *  设置用户头像
 *
 *  @param imageView 头像view
 *
 *  @return 
 */
+ (void)refreshUserPortraitInView:(UIImageView *)imageView;

/**
 *  更新用户头像，覆盖本地头像
 *
 *  @param filePath 新头像路径
 */
+ (void)updateUserPortraitImageWithFilePath:(NSString *)filePath;

/**
 *  获取设备名称
 *
 *  @return 设备名称
 */
+ (NSString *)deviceModelString;
/**
 *  获取距离当前时间的时间差
 *  compareDate 时间
 *  @return 时间差
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
@end
