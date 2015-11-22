//
//  NeighborViewController.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define kArticleButton   1
#define kSquareButton    0
#import "UIColor+extend.h"
#import "NeighborViewController.h"
#import "ArticleListViewController.h"
#import "NbSquareViewController.h"
#import "UserPageViewController.h"
#import "LoginViewController.h"
#import "ReplyMessageViewController.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "SVProgressHUD.h"
#import "PackageService.h"
#import "NewPackageNumModel.h"
@interface NeighborViewController ()
{
    UIButton * btn1;
    UIButton * btn2;
    UIImageView * switchView;
}
@property (nonatomic,strong)  ArticleListViewController   *articleViewController;  // 圈子动态viewcontroller
@property (nonatomic,strong)  NbSquareViewController    *squareViewController;     // 圈子广场viewcontroller
//@property (nonatomic,retain) UIImageView     * slideImageView;       // 红色游动线视图
@property (nonatomic,retain) UIButton        *messageNumButton;
@property (strong, nonatomic) PackageService     *packageService;

@end

@implementation NeighborViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (self) {
            self.title=@"邻里";
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
 
    [SVProgressHUD dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[[[[self tabBarController] viewControllers] objectAtIndex: 2] tabBarItem] setBadgeValue:0];

    [self requestMessageNumber];
}

-(void)createTitleView
{
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 141, 44)];
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    [btn1 setTitle:@"广场" forState:UIControlStateNormal];
//    [btn1 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang_press"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang_press"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(switchBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn1];
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(81, 0, 60, 44)];
//    [btn2 setTitle:@"动态" forState:UIControlStateNormal];
//    [btn2 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(switchBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn2];
    UIImageView * spView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 1, 24)];
    [spView setImage:[UIImage imageNamed:@"line_vertical_1x20"]];
    [titleView addSubview:spView];
    switchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 60, 2)];
    [switchView setBackgroundColor:UIColorFromRGB(0xbb474d)];
    [titleView addSubview:switchView];
    
    self.navigationItem.titleView = titleView;
}

-(void)switchBtnClick1
{
    // 账号管理
//    [btn1 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
//    [btn2 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang_press"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang_press"] forState:UIControlStateHighlighted];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai"] forState:UIControlStateHighlighted];

    [self showSquarePage];
    [UIView animateWithDuration:0.35f animations:^{
        [switchView setFrame:CGRectMake(0, 42, 60, 2)];
    }];
}
-(void)switchBtnClick2
{
    // 缴费清单
    // 账号管理
//    [btn2 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
//    [btn1 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_guangchang"] forState:UIControlStateHighlighted];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai_press"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_dongtai_press"] forState:UIControlStateHighlighted];
    [self showArticlePage];
    [UIView animateWithDuration:0.35f animations:^{
        [switchView setFrame:CGRectMake(81, 42, 60, 2)];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTitleView];
     [[[[[self tabBarController] viewControllers] objectAtIndex: 2] tabBarItem] setBadgeValue:0];
   
//    // IOS6修改约束
//    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
//        //遍历约束
//        NSArray* constrains = self.view.constraints;
//        for (NSLayoutConstraint* constraint in constrains) {
//            if (constraint.firstAttribute == NSLayoutAttributeTop && constraint.firstItem == self.titleView) {
//                constraint.constant = 0.0;
//                break;
//            }
//        }
//    }
    
//    // IOS6将tabbar背景设置成白色
//    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
//        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//        CGContextFillRect(context, rect);
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        self.titleView.backgroundImage = image;
//    }
//    // IOS6取消tabbar高亮效果
//    if ([[UIDevice currentDevice] systemVersion].floatValue < 7.0) {
//        CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//        UIGraphicsBeginImageContext(rect.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        CGContextFillRect(context, rect);
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        [self.titleView setSelectionIndicatorImage:image];
//    }
    
    float height = 64.0f;
    if (CURRENT_VERSION < 7.0f) {
        height = 0.0f;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //初始化子控制器
    self.articleViewController = [[ArticleListViewController alloc]init];
    self.squareViewController = [[NbSquareViewController alloc]init];
 
    [self.articleViewController.view setFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height - 49)];
    [self.squareViewController.view setFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height - 49)];
    
    [self.view  addSubview:self.articleViewController.view];
    [self.view  addSubview:self.squareViewController.view];
    
    //加入到主控制器
    [self addChildViewController:self.articleViewController];
    [self addChildViewController:self.squareViewController];
    [self createMessageButton];
    //右上角 个人按钮
    [self createPersonButton];
//    //点击滑动线
//    self.slideImageView= [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-200)/4, 42, 100, 2)];
//    self.slideImageView.image = [UIImage imageNamed:@"red_line_160x4"];
//    [self.titleView addSubview:self.slideImageView];
//    
//    [self.articleButton addTarget:self action:@selector(showArticlePage) forControlEvents:UIControlEventTouchUpInside];
//    [self.squareButton addTarget:self action:@selector(showSquarePage) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮样式  默认进来为广场按钮选中
//    [self changeButtonState:kSquareButton];
    
    self.articleViewController.view.hidden = YES;
}
/**
 *  标题栏右侧按钮
 */
- (void)createPersonButton {
    UIButton *myInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [myInfoButton setFrame:CGRectMake(0, 0, 20 + 22, 20)];
    } else {
        [myInfoButton setFrame:CGRectMake(0, 0, 20, 20)];
    }
    [myInfoButton setImage:[UIImage imageNamed:@"user_40x40"] forState:UIControlStateNormal];
    [myInfoButton setImage:[UIImage imageNamed:@"user_press_40x40"] forState:UIControlStateHighlighted];
    [myInfoButton addTarget:self action:@selector(gotoMyPage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:myInfoButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 *  标题栏左侧
 */
- (void)createMessageButton {
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, 20, 30)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [messageButton setFrame:CGRectMake(0, 5, 20+22, 20)];
    } else {
        [messageButton setFrame:CGRectMake(0, 5, 20, 20)];
    }
//    messageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80);
    [messageButton setImage:[UIImage imageNamed:@"icon_comment_40x40"] forState:UIControlStateNormal];
    [messageButton setImage:[UIImage imageNamed:@"icon_comment_40x40_press"] forState:UIControlStateHighlighted];
    [messageButton addTarget:self action:@selector(gotoMessagePage) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:messageButton];
    
    self.messageNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CURRENT_VERSION < 7.0) {
        [self.messageNumButton setFrame:CGRectMake(15, 0, 16+22, 16)];
    } else {
        [self.messageNumButton setFrame:CGRectMake(15, 0, 16, 16)];
    }
    [self.messageNumButton setBackgroundImage:[UIImage imageNamed:@"icon_bg_number_32x32"] forState:UIControlStateNormal];

    self.messageNumButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.messageNumButton.titleLabel.textColor = [UIColor whiteColor];
    [self.messageNumButton addTarget:self action:@selector(gotoMessagePage) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:self.messageNumButton];
    int circleMessageNum =[[[NSUserDefaults standardUserDefaults]objectForKey:@"circleMessageNumber"]intValue];
    if (circleMessageNum ==0) {
        [self.messageNumButton setHidden: YES];
    }
    else {
        [self.messageNumButton setHidden: NO];
        [self.messageNumButton setTitle:[NSString stringWithFormat:@"%d",circleMessageNum] forState:UIControlStateNormal];
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//- (void)refreshForMessage {
//    int circleMessageNum =[[[NSUserDefaults standardUserDefaults]objectForKey:@"circleMessageNumber"]intValue];
//    if (circleMessageNum ==0) {
//        [self.messageNumButton setHidden: YES];
//    }
//    else {
//        [self.messageNumButton setHidden: NO];
//        [self.messageNumButton setTitle:[NSString stringWithFormat:@"%d",circleMessageNum] forState:UIControlStateNormal];
//    }
//}

- (void)requestMessageNumber {
    if (self.packageService==nil) {
        self.packageService = [[PackageService alloc]init];
    }

    [self.packageService Bus101201:CID_FOR_REQUEST uId:[LoginManager shareInstance].loginAccountInfo.uId success:^(id responseObject) {
        NewPackageNumModel *newPackageNumModel = (NewPackageNumModel *)responseObject;
        
        if ([RETURN_CODE_SUCCESS isEqualToString:newPackageNumModel.retcode]) {
            if ([newPackageNumModel.theNewReply intValue]>0) {
                [[NSUserDefaults standardUserDefaults]setObject:newPackageNumModel.theNewReply  forKey:@"circleMessageNumber"];
                [self.messageNumButton setHidden:NO];
                [self.messageNumButton setTitle:[NSString stringWithFormat:@"%@",newPackageNumModel.theNewReply] forState:UIControlStateNormal];
                //self.messageNumButton.titleLabel.text = newPackageNumModel.theNewReply;
               // [[NSNotificationCenter defaultCenter]postNotificationName:HAS_NEW_MESSAGE object:self];
            }
            else {
                [self.messageNumButton setHidden:YES];
            }
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:@"0"  forKey:@"circleMessageNumber"];
        }
    } failure:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0"  forKey:@"circleMessageNumber"];
    }];
}

/**
 *  改变标题栏button展示
 *
 *  @param buttonType 0 动态按钮被选中 1 广场按钮被选中
 */
//- (void)changeButtonState :(NSInteger) buttonType{
//    if (buttonType == kSquareButton) {
//        [self.squareButton setTitleColor:[UIColor getColor:@"cc2a1e"] forState:UIControlStateNormal];
//        [self.articleButton  setTitleColor:[UIColor getColor:@"000000"] forState:UIControlStateNormal];
//        
//    }
//    else {
//        [self.squareButton setTitleColor:[UIColor getColor:@"000000"] forState:UIControlStateNormal];
//        [self.articleButton  setTitleColor:[UIColor getColor:@"cc2a1e"] forState:UIControlStateNormal];    }
//}

/**
 *  动态按钮触发事件 展示动态页
 */
- (void)showArticlePage {
    
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [loginAlert show];
    }
    
    else {
//        [self changeButtonState:kArticleButton];
//        //红色的线游动
//        if( self.slideImageView.frame.origin.x<self.view.frame.size.width/2){
//            [UIView animateWithDuration:0.3f animations:^{
//                self.slideImageView.frame=CGRectMake(3*self.view.frame.size.width/4-50, 42, 100, 2);
//            }
//                             completion:^(BOOL finished) {
//                                 
//                             }];
//        }
        self.squareViewController.view.hidden = YES;
        self.articleViewController.view.hidden = NO;
 
    }
    //    [self.squareViewController.view removeFromSuperview];
//    [self.view  insertSubview:self.articleViewController.view belowSubview:self.titleView];
    
}

/**
 *  广场按钮触发事件 展示广场页
 */
- (void)showSquarePage {
//    [self changeButtonState:kSquareButton];
//;
//    //红色的线游动
//    if(self.slideImageView.frame.origin.x>self.view.frame.size.width/2){
//        [UIView animateWithDuration:0.3f animations:^{
//            self.slideImageView.frame=CGRectMake((self.view.frame.size.width-200)/4, 42, 100, 2);
//        }
//                         completion:^(BOOL finished) {
//                             
//                         }];
//    }
    self.articleViewController.view.hidden = YES;
    self.squareViewController.view.hidden = NO;

//    [self.articleViewController.view removeFromSuperview];
//    [self.view  insertSubview:self.squareViewController.view belowSubview:self.titleView];
}

/**
 *  右上角按钮点击事件  我的主页
 */
- (void)gotoMyPage {
    
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [loginAlert show];
    }
    else {
        UserPageViewController *controller = [[UserPageViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.queryUid = [LoginManager shareInstance].loginAccountInfo.uId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/**
 *  左上角按钮点击事件  我的回复列表
 */
- (void)gotoMessagePage {
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        UIAlertView  *loginAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [loginAlert show];
    }
    else {
        [self.messageNumButton setHidden:YES];
        ReplyMessageViewController *controller = [[ReplyMessageViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //跳转到登陆页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        JRUINavigationController *nav = [[JRUINavigationController alloc]initWithRootViewController:loginViewController];
        loginViewController.loginButtonBlock = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
