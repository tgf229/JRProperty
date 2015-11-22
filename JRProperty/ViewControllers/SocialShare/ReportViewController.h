//
//  ReportViewController.h
//  JRProperty
//
//  Created by tingting zuo on 15-3-24.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface ReportViewController : JRViewControllerWithBackButton

@property (nonatomic,retain) NSString *articleId;
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


- (IBAction)button0Click:(id)sender;
- (IBAction)button1Click:(id)sender;
- (IBAction)button2Click:(id)sender;
- (IBAction)button3Click:(id)sender;
- (IBAction)button4Click:(id)sender;
- (IBAction)button5Click:(id)sender;
- (IBAction)button6Click:(id)sender;
- (IBAction)submit:(id)sender;

@end
