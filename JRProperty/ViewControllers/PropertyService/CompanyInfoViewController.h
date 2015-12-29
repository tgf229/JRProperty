//
//  CompanyInfoViewController.h
//  JRProperty
//
//  Created by 涂高峰 on 15/12/21.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface CompanyInfoViewController : JRViewControllerWithBackButton

@property (weak,nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak,nonatomic) IBOutlet UIView *mainView;

@property (weak,nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UITextView *contentTextView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *addressLabel;
@property (weak,nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewHeightConstraint;

@end
