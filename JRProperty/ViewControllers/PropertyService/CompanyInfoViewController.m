//
//  CompanyInfoViewController.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "UIColor+extend.h"
#import "JRDefine.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"

@interface CompanyInfoViewController ()

@property (strong,nonatomic) NSTimer *myTimer;

@end

@implementation CompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_wuyegongsi"]];
    
    _mainView.backgroundColor = [UIColor getColor:@"eeeeee"];
    _contentTextView.editable = NO;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    

//    [[NSUserDefaults standardUserDefaults] setObject:initModel.titleUrl forKey:@"JRTitleUrl"];
//    [[NSUserDefaults standardUserDefaults] setObject:initModel.logo forKey:@"JRLogo"];
    
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"CHANGEPROPERTYINFO" object:nil];
    
    [_mainView setHidden:YES];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(scrollTimer) userInfo:nil repeats:NO];
}

-(void)scrollTimer{
    [SVProgressHUD dismiss];
    [_mainView setHidden:NO];
}

- (void)initData{
    NSString *content = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRContent"];
    NSString *logo = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRLogo"];
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"community_default.png"]];
    _nameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRName"];
    _contentTextView.text = content;
    _titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRTitle"];
    _addressLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRAddress"];
    _telLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRTel"];
    
    CGSize size = CGSizeMake(UIScreenWidth-36,4000);
    CGFloat contentHeight =0.0;
    if (content.length != 0) {
        CGSize labelsize =[content  sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        contentHeight = labelsize.height + 22;
    }
    
    _contentHeightConstraint.constant = contentHeight;
    _firstViewHeightConstraint.constant = 24+80+14+20+15+contentHeight;
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _mainView.frame = CGRectMake(0, 0, UIScreenWidth, 500);
    _mainScrollView.contentSize = CGSizeMake(UIScreenWidth, 500);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//NSString *content = self.articleDetailModel.content;
//NSURL *url = [NSURL URLWithString:content];
//NSURLRequest *request = [NSURLRequest requestWithURL:url];
- (IBAction)selectUrl:(id)sender{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"JRTitleUrl"];
    if (url != nil && ![@"" isEqualToString:url]) {
        WebViewController *controller = [[WebViewController alloc]init];
        controller.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(IBAction)dial:(id)sender{
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
