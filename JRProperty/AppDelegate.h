//
//  AppDelegate.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRHeader.h"
#import "YLTabBarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) YLTabBarController *tabBarController;

+ (AppDelegate *) appDelegete;
- (void)initDataFromService;
// dw add V1.1
- (void)autoLoginIsSelectedPlot:(BOOL)_isSelected;
// dw end
@end

