//
//  MyBillViewController.m
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyBillViewController.h"
#import "JRDefine.h"


#define SlideConstraintLeft (UIScreenWidth / 2 - 100) / 2
#define SlideConstraintRight (UIScreenWidth - SlideConstraintLeft - 100)

@interface MyBillViewController ()
{
    UIButton * btn1;
    UIButton * btn2;
    UIImageView * switchView;
}

@end

@implementation MyBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTitleView];
    // Do any additional setup after loading the view from its nib.
    float height = 64.0f;
    if (CURRENT_VERSION < 7.0f) {
//        _topConstraint.constant = 0.0f;
        height = 0.0f;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [_accountManageButton setTitleColor:UIColorFromRGB(0xcc2a1e) forState:UIControlStateNormal];
//    [_paymentSlipButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
//    _slideImageViewLeftLayoutConstraint.constant = SlideConstraintLeft;
    
    _accountManageVC = [[AccountManageViewController alloc] init];
    _accountManageVC.view.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height);
    _paymentSlipVC = [[PaymentSlipViewController alloc] init];
    _paymentSlipVC.view.frame = CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height);
    
    [self.view addSubview:self.paymentSlipVC.view];
    [self.view addSubview:self.accountManageVC.view];
    
    [self addChildViewController:_paymentSlipVC];
    [self addChildViewController:_accountManageVC];
    
    self.currentVC = self.accountManageVC;
}

-(void)createTitleView
{
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 211, 44)];
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli_press"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli_press"] forState:UIControlStateHighlighted];
//    [btn1 setTitle:@"账号管理" forState:UIControlStateNormal];
//    [btn1 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(switchBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn1];
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(121, 0, 90, 44)];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan"] forState:UIControlStateHighlighted];
//    [btn2 setTitle:@"缴费清单" forState:UIControlStateNormal];
//    [btn2 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(switchBtnClick2) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn2];
    UIImageView * spView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 1, 24)];
    [spView setImage:[UIImage imageNamed:@"line_vertical_1x20"]];
    [titleView addSubview:spView];
    switchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 90, 2)];
    [switchView setBackgroundColor:UIColorFromRGB(0xbb474d)];
    [titleView addSubview:switchView];
    self.navigationItem.titleView = titleView;
}

-(void)switchBtnClick1
{
    // 账号管理
//    [btn1 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
//    [btn2 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli_press"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli_press"] forState:UIControlStateHighlighted];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan"] forState:UIControlStateHighlighted];

    [self replaceController:self.currentVC newController:self.accountManageVC];
    [UIView animateWithDuration:0.35f animations:^{
        [switchView setFrame:CGRectMake(0, 42, 90, 2)];
    }];
}
-(void)switchBtnClick2
{
    // 缴费清单
    // 账号管理
//    [btn2 setTitleColor:UIColorFromRGB(0xbb474d) forState:UIControlStateNormal];
//    [btn1 setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"title_zhangdanguanli"] forState:UIControlStateHighlighted];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan_press"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"title_jiaofeiqingdan_press"] forState:UIControlStateHighlighted];

    [self replaceController:self.currentVC newController:self.paymentSlipVC];
    [UIView animateWithDuration:0.35f animations:^{
        [switchView setFrame:CGRectMake(121, 42, 90, 2)];
    }];
}

/**
 *  滑动按钮点击
 *
 *  @param sender
 */
- (IBAction)myBillButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        if (btn.tag == 0) {
            // 账号管理
            _slideImageViewLeftLayoutConstraint.constant = SlideConstraintLeft;
            [_accountManageButton setTitleColor:UIColorFromRGB(0xcc2a1e) forState:UIControlStateNormal];
            [_paymentSlipButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [self replaceController:self.currentVC newController:self.accountManageVC];
        }else{
            // 缴费清单
            _slideImageViewLeftLayoutConstraint.constant = SlideConstraintRight;
            [_accountManageButton setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [_paymentSlipButton setTitleColor:UIColorFromRGB(0xcc2a1e) forState:UIControlStateNormal];
            [self replaceController:self.currentVC newController:self.paymentSlipVC];
        }
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.35f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}


//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    if (oldController == newController) {
        return;
    }
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
