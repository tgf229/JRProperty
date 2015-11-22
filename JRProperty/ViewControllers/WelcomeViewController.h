//
//  WelcomeViewController.h
//  JRProperty
//
//  Created by liugt on 14/12/9.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@protocol WelcomeControllerDelegate <NSObject>

/**
 *  引导页点击立刻体验按钮
 */
- (void)enterButtonPressed;

@end


@interface WelcomeViewController : JRViewController

@property(nonatomic,weak) id<WelcomeControllerDelegate> delegate;


/**
 *  创建并展示引导页
 */
- (void)createGuidePageView;

@end
