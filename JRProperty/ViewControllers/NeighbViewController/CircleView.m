//
//  CircleView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-23.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define  kWhiteSpace  16
#import "CircleView.h"
#import "SquareCircleSubview.h"
#import "JRDefine.h"
#import "SquareModel.h"

@implementation CircleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        //初始化
        [self initial];
    }
    
    return self;
}

-(void)initial{
    for (int i = 0; i < 4; i++) {
        SquareCircleSubview *circleView = [[[NSBundle mainBundle] loadNibNamed:@"SquareCircleSubview" owner:self options:nil]objectAtIndex:0];
        circleView.tag = i;
        [circleView initial];
        circleView.delegate = self;
        [self addSubview:circleView];
    }
}

#pragma mark 设置数据，返回高度
-(void) setData:(NSArray *)data{
    
    CGFloat height = [CircleView height];
    CGFloat width=height-35;
    for (int i = 0; i < self.subviews.count; i++) {
        
        SquareCircleSubview * item = self.subviews[i];
        if(i < data.count) {
            
            //设置显示
            item.hidden = NO;
            //设置frame
            item.frame = CGRectMake(8+i*width,0, width, height);
            //设置数据
            CircleInfoModel *model =[data objectAtIndex:i];
            [item setData:model];
            
        }
        else{
            item.hidden = YES;
        }
    }
}

- (void)imageClick:(SquareCircleSubview *)circleSubView withCircleId:(NSString *)circleId  circleName:(NSString *)circleName {
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:withCircleId:circleName:)]){
        [_delegate imageClick:self withCircleId:circleId circleName:circleName];
    }
}


#pragma mark 返回高度


+(CGFloat) height {
    CGFloat heigt;
    CGFloat buttonHeigt = (UIScreenWidth-5*kWhiteSpace)/4;
    heigt = 13+buttonHeigt+8+30;
    return heigt;
}


@end
