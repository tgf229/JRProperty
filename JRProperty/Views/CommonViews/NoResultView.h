//
//  NoResultView.h
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  错误提示页面 哭脸

#import <UIKit/UIKit.h>

@interface NoResultView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
-(void)initialWithTipText:(NSString *)tipText;
@end
