//
//  ReportViewController.m
//  JRProperty
//
//  Created by tingting zuo on 15-3-24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//
#import "UIColor+extend.h"
#import "ReportViewController.h"
#import "ArticleService.h"
#import "SVProgressHUD.h"
#import "LoginManager.h"
@interface ReportViewController ()
@property (nonatomic,assign) int selectIndex;
@property (strong,nonatomic)  ArticleService      *articleService;

@end

@implementation ReportViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    self.title = @"举报";
    [super viewDidLoad];
    if (CURRENT_VERSION <7) {
        self.topConstraint.constant = 14;
    }
    self.view.backgroundColor = [UIColor getColor:@"eeeeee"];
    self.articleService = [[ArticleService alloc]init];
    self.selectIndex = 7;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button0Click:(id)sender {
    self.selectIndex = 0;
    [self.button0 setSelected:YES];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:NO];
}

- (IBAction)button1Click:(id)sender {
    self.selectIndex = 1;
    [self.button0 setSelected:NO];
    [self.button1 setSelected:YES];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:NO];
}

- (IBAction)button2Click:(id)sender {
    self.selectIndex = 2;

    [self.button0 setSelected:NO];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:YES];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:NO];
}

- (IBAction)button3Click:(id)sender {
    self.selectIndex = 3;

    [self.button0 setSelected:NO];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:YES];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:NO];
}

- (IBAction)button4Click:(id)sender {
    self.selectIndex = 4;

    [self.button0 setSelected:NO];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:YES];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:NO];
}

- (IBAction)button5Click:(id)sender {
    self.selectIndex = 5;
    [self.button0 setSelected:NO];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:YES];
    [self.button6 setSelected:NO];
}

- (IBAction)button6Click:(id)sender {
    self.selectIndex = 6;
    [self.button0 setSelected:NO];
    [self.button1 setSelected:NO];
    [self.button2 setSelected:NO];
    [self.button3 setSelected:NO];
    [self.button4 setSelected:NO];
    [self.button5 setSelected:NO];
    [self.button6 setSelected:YES];
}

- (IBAction)submit:(id)sender {
    if (self.selectIndex == 7) {
        UIAlertView *noticeAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"还未选择举报原因！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [noticeAlert show];
    }
    else {
        NSString *type = [NSString stringWithFormat:@"%d",self.selectIndex];
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        [self.articleService Bus302201:self.articleId uId:[LoginManager shareInstance].loginAccountInfo.uId type:type success:^(id responseObject) {
            BaseModel *baseModel = (BaseModel *)responseObject;
            if ([baseModel.retcode isEqualToString:RETURN_CODE_SUCCESS]) {
                [SVProgressHUD  showSuccessWithStatus:@"举报成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else  {
                [SVProgressHUD  showErrorWithStatus:baseModel.retinfo];
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD  showErrorWithStatus:OTHER_ERROR_MESSAGE];
        }];
    }
    
}

@end
