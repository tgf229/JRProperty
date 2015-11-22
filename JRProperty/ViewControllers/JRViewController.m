//
//  JRViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-10.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "JRDefine.h"

@interface JRViewController ()

@end

@implementation JRViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏字体颜色
    UILabel * myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 44)];
    myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [myTitleLabel setBackgroundColor:[UIColor clearColor]];
    myTitleLabel.font = [UIFont systemFontOfSize:19];
    myTitleLabel.textColor = UIColorFromRGB(0x333333);
    
    myTitleLabel.text = self.title;
    self.navigationItem.titleView = myTitleLabel;
    
    // IOS6将导航栏背景设置成白色
    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end

@implementation JRViewControllerWithBackButton

- (void)click_popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    if (CURRENT_VERSION >= 7.0) {
        [backBtn setFrame:CGRectMake(0, 0, 12, 22)];
    } else {
        [backBtn setFrame:CGRectMake(0, 0, 12 + 22, 22)];
    }
    [backBtn setImage:[UIImage imageNamed:@"return_40x40"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_40x40_press"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(click_popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

@end

@implementation JRUINavigationController

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
