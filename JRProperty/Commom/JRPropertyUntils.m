//
//  JRPropertyUntils.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-14.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#import "UIView+Additions.h"
#import "JRPropertyUntils.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "UIImageView+WebCache.h"
#import <sys/utsname.h>

@implementation JRPropertyUntils

/**
 *  计算控制器可展示视图的大小
 *
 *  @param owner 控制器的拥有者
 *  @param exist 是否存在TabBar
 *
 *  @return 返回展示区域的大小
 */
+ (CGRect)layoutVisitOwner:(UIViewController *)owner existTabBar:(BOOL)exist
{
    CGRect rect = CGRectMake(0, 0, owner.view.frameWidth, owner.view.frameHeight);
    BOOL flag = exist;
    float tabBarHeight = 0;
    if (flag)
    {
        tabBarHeight = owner.tabBarController.tabBar.frameHeight;
    }
    if (CURRENT_VERSION < 7.0)
    {
        rect.size.height = owner.view.frameHeight - 44 - tabBarHeight;
    }
    else
    {
        rect.size.height = owner.view.frameHeight - tabBarHeight;
    }
    return rect;
}

+ (void)refreshUserPortraitInView:(UIImageView *)imageView
{
    UIImage *portriatImage = nil;
    
    // 先获取本地头像图片
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userPhoto.png"];
    portriatImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (portriatImage != nil) {
        // 获取本地头像图片
        [imageView setImage:portriatImage];
    }
    else{
        // 从网络获取
        [imageView sd_setImageWithURL:[NSURL URLWithString:[LoginManager shareInstance].loginAccountInfo.image] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140.png"] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL)
        {
            // 获取成功后保存到本地Documents下并命名为userPhoto.png
            NSString *portriatPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userPhoto.png"];
            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
            [imageData writeToFile:portriatPath atomically:NO];

        }];
    }
}

+ (void)updateUserPortraitImageWithFilePath:(NSString *)filePath
{
    // 覆盖原来的图片
    NSString *portriatPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userPhoto.png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    [imageData writeToFile:portriatPath atomically:NO];
    
    // 更新之后删除
    NSFileManager *documentsFileManager = [NSFileManager defaultManager];
    NSError *err;
    [documentsFileManager removeItemAtPath:filePath error:&err];

}

+ (NSString*)deviceModelString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"])    return @"iPhone 6Plus";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,3"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,3"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}



/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate
//
{
   
    NSTimeInterval  timeInterval =[compareDate timeIntervalSinceNow];
    //[currentDate timeIntervalSinceDate:compareDate];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"片刻之前"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

@end
