//
//  PropertyServiceViewController.m
//  JRProperty
//
//  Created by duwen on 14/11/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PropertyServiceViewController.h"
#import "MyWorkOrderListViewController.h"
#import "PropertyServiceCommonPostViewController.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
@interface PropertyServiceViewController ()

@end

@implementation PropertyServiceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wuyefuwu"]];

    NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAddress"];
    _propertyAddressLabel.text = [NSString stringWithFormat:@"物业地址:%@",addressStr?addressStr:@""];
    
//    for (UIButton * btn in _bottomButtonArray) {
//        [btn addTarget:self action:@selector(holdDownButtonTouchDown:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
//        [btn addTarget:self action:@selector(holdDownButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePropertyInfo) name:@"CHANGEPROPERTYINFO" object:nil];
}

- (void)changePropertyInfo{
    NSString *addressStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAddress"];
    _propertyAddressLabel.text = [NSString stringWithFormat:@"物业地址:%@",addressStr?addressStr:@""];
}


/**
 *  按钮按下效果
 *
 *  @param sender
 */
- (void)holdDownButtonTouchDown:(UIButton *)sender{
    UIView *view = (UIView *)_bottomViewArray[sender.tag - 2];
    [view setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
}

/**
 *  按钮移开效果
 *
 *  @param sender
 */
- (void)holdDownButtonTouchUpOutside:(UIButton *)sender{
    UIView *view = (UIView *)_bottomViewArray[sender.tag - 2];
    [view setBackgroundColor:UIColorFromRGB(0xffffff)];
}

/**
 *  按钮点击效果
 *
 *  @param sender
 */
- (IBAction)propertyButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        switch ([btn tag]) {
            case 0:
                // 我的工单
            {
                if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
                        UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    return;
                }

                MyWorkOrderListViewController *myWorkOrderListViewController = [[MyWorkOrderListViewController alloc] init];
                myWorkOrderListViewController.title = @"我的工单";
                myWorkOrderListViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myWorkOrderListViewController animated:YES];
            }
                break;
            case 1:
                // 一键呼叫
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
                // 特点: 直接拨打, 不弹出提示。 并且, 拨打完以后, 留在通讯录中, 不返回到原来的应用。
            {
                NSString *telStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRTel"];
                telStr = [telStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([@"" isEqualToString:telStr]||telStr==nil) {
                    [SVProgressHUD showErrorWithStatus:@"暂无号码信息"];
                    return;
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                // 特点: 拨打前弹出提示。 并且, 拨打完以后会回到原来的应用。
            }
                break;
            case 2:
                // 物业保修
                [self enterPropertyServiceCommonPostViewController:@"报修"];
                break;
            case 3:
                // 投诉建议
                [self enterPropertyServiceCommonPostViewController:@"投诉"];
                break;
            case 4:
                // 表扬感谢
//                [self enterPropertyServiceCommonPostViewController:@"表扬"];
                break;
            case 5:
                //求助
                [self enterPropertyServiceCommonPostViewController:@"求助"];
                break;
            case 6:
                //建议
                [self enterPropertyServiceCommonPostViewController:@"建议"];
            default:
                break;
        }
    }
    
}

/**
 *  进入物业报修 投诉建议 表扬感谢
 *
 *  @param titleName 标题
 */
- (void)enterPropertyServiceCommonPostViewController:(NSString *)titleName{
    if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
        if (![LoginManager shareInstance].loginAccountInfo.isLogin) {
            UIAlertView  *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        return;
    }
    
    PropertyServiceCommonPostViewController *propertyServiceCommonPostVC = [[PropertyServiceCommonPostViewController alloc] init];
    propertyServiceCommonPostVC.title = titleName;
    propertyServiceCommonPostVC.hidesBottomBarWhenPushed = YES;
    propertyServiceCommonPostVC.propertyServiceCommentSuccessBlock = ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@成功",titleName] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    };
    [self.navigationController pushViewController:propertyServiceCommonPostVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //跳转到登陆页面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //登录返回前需要请求圈子用户信息
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
