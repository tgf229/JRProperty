//
//  SquareCircleSubview.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "SquareCircleSubview.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"

@implementation SquareCircleSubview

-(void)initial{
    NSInteger cornerRadius;
    if(UIScreenWidth == 320) {
        cornerRadius = 29;
    }
    else if (UIScreenWidth == 375){
        cornerRadius = 37;
    }
    else {
        cornerRadius = 40;
        
    }
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = cornerRadius;
    
}

- (IBAction)gotoCircleDetail:(id)sender {
    
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(imageClick:withCircleId:circleName:)]){
        [_delegate imageClick:self withCircleId:_data.id circleName:_data.name];
    }
}

- (void)setData:(CircleInfoModel *)data {
    _data = data;
    self.nameLabel.text = data.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:data.icon] placeholderImage:[UIImage imageNamed:@"community_default"]];
}

@end
