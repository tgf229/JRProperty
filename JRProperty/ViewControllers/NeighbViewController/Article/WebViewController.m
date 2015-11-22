//
//  WebViewController.m
//  JRProperty
//
//  Created by tingting zuo on 15-4-7.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "WebViewController.h"
#import "NoResultView.h"
#import "JRDefine.h"
@interface WebViewController ()
@property (nonatomic,strong)  NoResultView       *noResultView;    // 报错页面
@end

@implementation WebViewController

- (void)viewDidLoad {
    
    //self.title = @"网页";
    
    [super viewDidLoad];

    self.webView.delegate =self;
    NSURLRequest *request =[NSURLRequest requestWithURL:self.url];

    [self.webView loadRequest:request];
   
    //哭脸视图
    self.noResultView = [[[NSBundle mainBundle] loadNibNamed:@"NoResultView" owner:self options:nil]objectAtIndex:0];
    [self.noResultView initialWithTipText:OTHER_ERROR_MESSAGE];
    if (CURRENT_VERSION<7) {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-145, UIScreenWidth, 140);
    }
    else {
        self.noResultView.frame = CGRectMake(0,UIScreenHeight/2-45, UIScreenWidth, 140);
    }
    [self.noResultView setHidden:YES];
    [self.view addSubview:self.noResultView];

    // Do any additional setup after loading the view from its nib.
}
-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
//     self.title =  [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    NSLog(@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
    UILabel * myTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, 44)];
    myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [myTitleLabel setBackgroundColor:[UIColor clearColor]];
    myTitleLabel.font = [UIFont systemFontOfSize:20];
    myTitleLabel.textColor = [UIColor blackColor];
    
    myTitleLabel.text = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.titleView = myTitleLabel;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.noResultView setHidden:NO];
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
