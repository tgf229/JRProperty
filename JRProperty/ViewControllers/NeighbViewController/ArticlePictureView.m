//
//  ArticlePictureView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define  kWhiteSpace  3
#import "ArticlePictureView.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation ArticlePictureView


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


#pragma mark 初始化

-(void)initial{
    self.imageSArray = [[NSMutableArray alloc]init];
    self.imageLArray = [[NSMutableArray alloc]init];

    for (int i = 0; i < 6; i++) {
        
        //创建
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //添加tag
        button.tag = i;
        //自适应图片尺寸比例
        button.imageView.contentMode = UIViewContentModeCenter;
        //添加点击事件
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加
        [self addSubview:button];
        
    }
}
#pragma mark 点击事件

-(void) click:(UIButton*) sender{
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:atIndex:withInfo:)]){
        [_delegate imageClick:self atIndex:sender.tag withInfo:self.imageLArray];
    }
}

#pragma mark 设置数据，返回高度
-(void) setData:(NSArray *)data{
    [self.imageLArray removeAllObjects];
    [self.imageSArray removeAllObjects];
    for (int i = 0; i< data.count; i++) {
        ImageModel *model = [data objectAtIndex:i];
        [self.imageSArray addObject:model.imageUrlS];
        [self.imageLArray addObject:model.imageUrlL];
    }
    CGFloat buttonHeight =(UIScreenWidth-30-2*kWhiteSpace)/3;
    CGFloat width = buttonHeight;
    CGFloat height= buttonHeight;
    
    for (int i = 0; i < self.subviews.count; i++) {
        
        UIButton * item = self.subviews[i];
        if(i < data.count) {
            
            //设置显示
            item.hidden = NO;
            
            //设置frame
            int h=0;
            if (i >=3) {
                h=1;
            }
            int v = i%3;
            item.frame = CGRectMake(v*width+15+v*kWhiteSpace,(i/3)*height+h*kWhiteSpace, width, height);
            item.contentEdgeInsets = UIEdgeInsetsMake(0, 0, kWhiteSpace, kWhiteSpace);
            //设置数据
            NSString  *string = [self.imageSArray objectAtIndex:i];
            //NSString *string =  @"http://10.167.3.24:81//images/ff/9d/7f/ff9d7fad-9150-4065-be70-4fad104d0735.jpg_200x200.jpg";
//            [item sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"community_default"]];
            [item sd_setBackgroundImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"community_default"]];
        }
        else{
            item.hidden = YES;
        }
        
    }
    
}

#pragma mark 返回高度

+(CGFloat) height:(NSInteger)imageCount {
    CGFloat viewHeight =0;
    CGFloat buttonHeight =(UIScreenWidth-30-2*kWhiteSpace)/3;
    if (imageCount<=3 &&imageCount>=1 ) {
        
        viewHeight = buttonHeight;
    }
    else if (imageCount>3) {
        viewHeight =2*buttonHeight+kWhiteSpace;
    }
    return viewHeight;
}

@end
