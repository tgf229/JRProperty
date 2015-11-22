//
//  PrivacyViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "PrivacyViewController.h"
#import "SVProgressHUD.h"
#import "JRDefine.h"

@interface PrivacyViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *advertiseWeb;
@property (nonatomic, strong) NSURLRequest *advertiseRequest;

@end


@implementation PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setCommonApperence];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_yinsi"]];

    self.advertiseWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.advertiseWeb.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.advertiseWeb setBackgroundColor:[UIColor clearColor]];
    [self.advertiseWeb setOpaque:NO];
    self.advertiseWeb.scalesPageToFit = YES;
    self.advertiseWeb.delegate=self;
    
    NSURL *advertiseUrl = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",HTTP_PRIVACY_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.advertiseRequest = [[NSURLRequest alloc] initWithURL:advertiseUrl];
    [self.advertiseWeb loadRequest:self.advertiseRequest];
    [self.view addSubview:self.advertiseWeb];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}


- (void)click_popViewController
{
    [SVProgressHUD dismiss];
    
    if ([self.advertiseWeb canGoBack]) {
        [self.advertiseWeb goBack];
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    //设置字体
    //NSString *javaScriptStr = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",@"90%"];
    //[self.payWebView stringByEvaluatingJavaScriptFromString:javaScriptStr];
    //    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    //    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showErrorWithStatus:@"网页请求失败"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [SVProgressHUD dismiss];
    [self setAdvertiseWeb:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
