//
//  RegisterCheckHouseViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "RegisterCheckHouseViewController.h"
#import "RegisterCheckAuthViewController.h"
#import "HouseAddressViewController.h"
#import "PrivacyViewController.h"
#import "SVProgressHUD.h"
#import "SelectedPlotsViewController.h"

@interface RegisterCheckHouseViewController ()
{
    BOOL _isAgreePrivacy;  // 是否同意条款
}

@property (weak,nonatomic)  IBOutlet UIScrollView    *mainScrollView;
@property (weak,nonatomic)  IBOutlet  UIView         *headerGuideView;     // 步骤指示图
@property (weak,nonatomic)  IBOutlet UIView          *houseNoView;         // 房号view
@property (weak,nonatomic)  IBOutlet UIButton        *checkPrivacyButton;  // 同意条款按钮

@property (weak,nonatomic)  IBOutlet NSLayoutConstraint *mainScrollTopConstraint; // 整体的top约束
@property (weak,nonatomic)  IBOutlet NSLayoutConstraint *selectTipTopConstraint;  // 选择房屋的提示语top约束

// dw add V1.1
@property (weak, nonatomic) IBOutlet UIView *PlotNoView;
@property (weak, nonatomic) IBOutlet UILabel *PlotNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PlotCityLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) NSString * cidStr;
// dw end


@end

@implementation RegisterCheckHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_zhuce"]];

    self.mainScrollView.backgroundColor = [UIColor getColor:@"eeeeee"];
    [self.nextBtn setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[[UIImage imageNamed:@"btn_redbg_40x40_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    if(!self.isRegister)
    {
        self.headerGuideView.hidden = YES;
        self.selectTipTopConstraint.constant = - 50;
        [self.view layoutIfNeeded];
    }

    // dw add V1.1
    UITapGestureRecognizer *PlotNoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPlotName)];
    [self.PlotNoView addGestureRecognizer:PlotNoTap];
    // dw end
    
    UITapGestureRecognizer *houseNoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectHouseNumber)];
    [self.houseNoView addGestureRecognizer:houseNoTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Actions

/**
 *  选择小区
 */
- (void)selectPlotName{
    SelectedPlotsViewController * vc = [[SelectedPlotsViewController alloc] init];
    vc.title = @"选择小区";
    vc.hidesBottomBarWhenPushed = YES;
    vc.isHomePass = NO;
    vc.cidStr = self.cidStr?self.cidStr:@"";
    vc.buttonBlock = ^(NSString *titleStr, NSString * cid, NSString *city){
        self.PlotNameLabel.text = titleStr;
        self.cidStr = cid;
        self.PlotCityLabel.text = city;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  选择房屋房号
 */
- (void)selectHouseNumber
{
    if (self.cidStr && ![@"" isEqualToString:self.cidStr]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
        
        HouseAddressViewController *selectHouseController = [storyboard instantiateViewControllerWithIdentifier:@"HouseAddressViewController"];
        selectHouseController.title = @"小区住址";
        selectHouseController.plotsName = self.PlotNameLabel.text;
        selectHouseController.plotsCid = self.cidStr?self.cidStr:@"1";
        [self.navigationController pushViewController:selectHouseController animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请先选择小区"];
    }
    
}

/**
 *  同意/不同意隐私条款
 *
 *  @param sender
 */
- (IBAction)checkPrivacyAndRulation:(id)sender
{
    _isAgreePrivacy = !_isAgreePrivacy;

    if (_isAgreePrivacy) {
        // 同意条款
        [self.checkPrivacyButton setImage:[UIImage imageNamed:@"myhome_signin_input_checkbox_select.png"] forState:UIControlStateNormal];
    }
    else{
        // 取消同意条款
        [self.checkPrivacyButton setImage:[UIImage imageNamed:@"myhome_signin_input_checkbox.png"] forState:UIControlStateNormal];
    }
    
}

/**
 *  查看协议
 *
 *  @param sender
 */
- (IBAction)checkPrivacy:(id)sender
{
    PrivacyViewController *privacyController = [[PrivacyViewController alloc] init];
    privacyController.title = @"隐私条款与使用规则";
    [self.navigationController pushViewController:privacyController animated:YES];
}

/**
 *  下一步，校验房屋信息
 */
- (IBAction)pushToCheckAuthViewController
{
    if (self.houseNumberLabel.text.length == 0) {
        // 未选择房屋信息，提示
        [SVProgressHUD showErrorWithStatus:@"请选择房号"];
        return;
    }

    if (!_isAgreePrivacy) {
        // 未同意条款，提示
        [SVProgressHUD showErrorWithStatus:@"请阅读并勾选使用协议"];
        return;
    }
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyHouseStoryboard" bundle:nil];
    
    RegisterCheckAuthViewController *checkAuthController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterCheckAuthViewController"];
    checkAuthController.isRegister = self.isRegister;
    checkAuthController.title = _isRegister ? @"注册" : @"添加房屋";
    checkAuthController.houseModel = self.houseModel;
    checkAuthController.selectCID = self.cidStr?self.cidStr:@"1";
    [self.navigationController pushViewController:checkAuthController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
