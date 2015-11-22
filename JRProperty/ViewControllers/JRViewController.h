//
//  JRViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-10.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+extend.h"
#import "JRHeader.h"

@interface JRViewController : UIViewController

@end

/**
 * UIViewController基类,带导航栏返回按钮
 */
@interface JRViewControllerWithBackButton :JRViewController
- (void)click_popViewController;
@end

/**
 * UINavigationController基类,暂时继承此类，目前未实现任何代码
 */
@interface JRUINavigationController : UINavigationController
@end
