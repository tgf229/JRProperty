//
//  AboutViewController.m
//  JRProperty
//
//  Created by liugt on 14/11/29.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AboutViewController.h"
#import "JRDefine.h"

@interface AboutViewController ()

@property (weak,nonatomic) IBOutlet UILabel      *textNumberLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_guanyu"]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if (CURRENT_VERSION>=7.0)
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif

    //版本号
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!curVersion) {
        curVersion=@"";
    }
    
    self.textNumberLabel.text = [NSString stringWithFormat:@"软件版本：%@",curVersion];
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
