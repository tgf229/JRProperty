//
//  YLTabBarController.m
//  YLRiseTabBarDemo
//
//  Created by 杨立 on 15/10/22.
//  Copyright (c) 2015年 杨立. All rights reserved.
//

#import "YLTabBarController.h"
#import "HomFragmentController.h"
#import "PropertyServiceViewController.h"
#import "CommunityListController.h"
#import "MemberCenterViewController.h"
#import "YLTabBar.h"

@interface YLTabBarController ()

@end

@implementation YLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置子控制器
    HomFragmentController *homeController = [[HomFragmentController alloc]init];
    JRUINavigationController *navHome = [[JRUINavigationController alloc]initWithRootViewController:homeController];
    [self setChildVC:navHome title:@"首页" image:@"home_icon_home" selectedImage:@"home_icon_home_press"];
    
//    PropertyServiceViewController *propertyServiceController = [[PropertyServiceViewController alloc]init];
//    propertyServiceController.title = @"物业";
//    JRUINavigationController *navHome2 = [[JRUINavigationController alloc]initWithRootViewController:propertyServiceController];
//    [self setChildVC:navHome2 title:@"物业" image:@"home_icon_service" selectedImage:@"home_icon_service_press"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityStoryboard" bundle:nil];
    CommunityListController *communityListController = [storyboard instantiateViewControllerWithIdentifier:@"CommunityListController"];
    JRUINavigationController *navHome3 = [[JRUINavigationController alloc] initWithRootViewController:communityListController];
    [self setChildVC:navHome3 title:@"邻里" image:@"home_icon_neighbor" selectedImage:@"home_icon_neighbor_press"];
    
    MemberCenterViewController *myController = [[MemberCenterViewController alloc]init];
    JRUINavigationController *navHome4 = [[JRUINavigationController alloc]initWithRootViewController:myController];
    [self setChildVC:navHome4 title:@"我的" image:@"home_icon_myhome" selectedImage:@"home_icon_myhome_press"];
    
    YLTabBar *tabBar = [[YLTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc            子控制器
 *  @param title              tabbar标题
 *  @param image              tabbar图片名
 *  @param selectedImage      tabbar选中图片名
 */
-(void)setChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
//    childVC.tabBarItem.title = title;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [childVC.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [self addChildViewController:childVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
