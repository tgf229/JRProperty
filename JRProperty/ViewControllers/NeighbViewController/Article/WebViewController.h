//
//  WebViewController.h
//  JRProperty
//
//  Created by tingting zuo on 15-4-7.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface WebViewController : JRViewControllerWithBackButton<UIWebViewDelegate>
@property (nonatomic,copy) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
