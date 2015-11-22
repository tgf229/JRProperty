//
//  RefreshPageView.h
//  JRProperty
//
//  Created by tingting zuo on 14-12-5.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  圈子模块使用  错误提示页面  点击屏幕可重新加载

#import <UIKit/UIKit.h>

@interface RefreshPageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)refreshButtonClick:(id)sender;
@property (nonatomic, copy)   dispatch_block_t callBackBlock;
-(void)initial;
@end
