//
//  PropertyServiceViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
@interface PropertyServiceViewController : JRViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *propertyAddressLabel;         // 物业服务地址
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *bottomViewArray;  // 按钮背景视图
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bottomButtonArray;  // 按钮数组




@end
