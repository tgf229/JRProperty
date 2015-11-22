//
//  VersionUpdateView.m
//  CenterMarket
//
//  Created by dw on 14-7-14.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "VersionUpdateView.h"
#import "UIColor+extend.h"
#import "JRDefine.h"

#define kAlertWidth    280.0f   //提示框宽度
#define kAlertHeight   162.0f   //提示框高度

@implementation VersionUpdateView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithDocArray:(NSArray *)docArr isMust:(BOOL)_isMust{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray arrayWithArray:docArr];
        if ([@"" isEqualToString:[self.dataArray lastObject]]) {
            [self.dataArray removeLastObject];
        }
        
        // 阴影
        shadeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,UIScreenWidth, UIScreenHeight)];
        shadeView.backgroundColor = [UIColor blackColor];
        shadeView.alpha = 0.6;
        
        UIWindow * shareWindow = [UIApplication sharedApplication].keyWindow;
        [shareWindow addSubview:shadeView];
        self.center = shareWindow.center;
        [shareWindow addSubview:self];
        
//        UIImageView * topIv =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_pop_titbg_4x72"]];
//        topIv.frame = CGRectMake(0, 0, kAlertWidth, 36);
//        [self addSubview:topIv];
//        
//        UIImageView * tipIv =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_pop_icon_40x40"]];
//        tipIv.frame = CGRectMake(14, 8, 20, 20);
//        [self addSubview:tipIv];
        
        UILabel * tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"软件更新";
        tipLabel.font = [UIFont systemFontOfSize:16.0f];
        tipLabel.backgroundColor = [UIColor whiteColor];
        tipLabel.frame = CGRectMake(0, 0, kAlertWidth, 36);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor blackColor];
        [self addSubview:tipLabel];
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, kAlertWidth, 172) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.tableView];
        
        self.frame = CGRectMake(0, 0, kAlertWidth, 252);
        self.backgroundColor = [UIColor clearColor];
        [self setCenter:shareWindow.center];
        
        // 取消按钮
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_red_cancle"] forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_red_cancle_press"] forState:UIControlStateHighlighted];
        cancelBtn.frame = CGRectMake(0, 208, 140, 44);
        [cancelBtn addTarget:self action:@selector(makeCancel) forControlEvents:UIControlEventTouchUpInside];
        if (_isMust) {
            [cancelBtn setTitle:@"退出" forState:UIControlStateNormal];
        }else{
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        
        // 操作按钮
        sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_red_sure"] forState:UIControlStateNormal];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_red_sure_press"] forState:UIControlStateHighlighted];
        sureBtn.frame = CGRectMake(140, 208, 140, 44);
        [sureBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitle:@"更新" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:sureBtn];
        

    }
    return self;
}

- (void)makeSure{
//    [shadeView removeFromSuperview];
    if (self.leftBlock)
    {
        self.leftBlock();
    }
//    [self removeFromSuperview];
}

- (void)makeCancel{
//    [shadeView removeFromSuperview];
    if (self.rightBlock) {
        self.rightBlock();
    }
//    [self removeFromSuperview];
}

- (void)removeViewFromSelf{
    [shadeView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat maxWidth = kAlertWidth - 18 * 2;
    CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return textSize.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"CELLINDENTIFER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor getColor:@"cccccc"]];
        [view setTag:100];
        [cell addSubview:view];
    }
    
    NSString *str = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat maxWidth = kAlertWidth - 18 * 2;
    CGSize textSize = [str sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    [cell.textLabel setText:str];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cell.textLabel setFrame:CGRectMake(18, 0, maxWidth, textSize.height + 20)];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    [imageView setFrame:CGRectMake(15, textSize.height + 19, 240, 0.5)];
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
