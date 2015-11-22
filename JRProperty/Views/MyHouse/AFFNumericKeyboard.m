//
//  CustomKeyboard.m
//  keyboard
//
//  Created by liugt on 14-12-03.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "AFFNumericKeyboard.h"

#define UIScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define UIScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kLineWidth 1
#define kButtonWidth    (UIScreenWidth-2)/3
#define kNumFont  [UIFont systemFontOfSize:27]

@implementation AFFNumericKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, UIScreenWidth, 216);
        // 创建按键
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        // 竖分割线1
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kButtonWidth, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        [self addSubview:line1];
        
        // 竖分割线2
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(kButtonWidth*2+kLineWidth, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        // 横分割线1
        for (int i=0; i<3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*(i+1), UIScreenWidth, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
        
    }
    return self;
}

/**
 *  创建0-9,X和回退按钮
 *
 *  @param x 横坐标
 *  @param y 纵坐标
 *
 *  @return 按键
 */
-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = kButtonWidth;
            break;
        case 1:
            frameX = kButtonWidth+1;
            frameW = kButtonWidth;
            break;
        case 2:
            frameX = kButtonWidth*2+2;
            frameW = kButtonWidth;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    //
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
    
    //
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    if (num == 10 || num == 12)
    {
        // X和回退键
        UIColor *colorTemp = colorNormal;
        colorNormal = colorHightlighted;
        colorHightlighted = colorTemp;
    }
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];

    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        labelNum.text = [NSString stringWithFormat:@"%d",num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"X";
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake((frameW - 22)/2, 19, 22, 17)];
        arrow.image = [UIImage imageNamed:@"arrowInKeyboard"];
        [button addSubview:arrow];
    }
    
    return button;
}


/**
 *  点击键盘
 *
 *  @param sender 
 */
-(void)clickButton:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        [self.delegate xButtonPressed];
        return;
    }
    else if(sender.tag == 12)
    {
        [self.delegate numberKeyboardBackspace];
    }
    else
    {
        NSInteger num = sender.tag;
        if (sender.tag == 11)
        {
            num = 0;
        }
        [self.delegate numberKeyboardInput:num];
    }
}


@end
