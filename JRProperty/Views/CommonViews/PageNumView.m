//
//  PageNumView.m
//  CenterMarket
//
//  Created by 周光 on 14-7-9.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "PageNumView.h"
#import "UIView+Additions.h"

@interface PageNumView()
{

    UILabel   *_numLabel;
    
    UIImageView  *_backGroundView;
}


- (void)setup;
@end

@implementation PageNumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}



- (void)setup
{
    
    
    _backGroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backGroundView.backgroundColor  = [UIColor clearColor];
    [self addSubview:_backGroundView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    _numLabel.center = _backGroundView.center;
    _numLabel.font = [UIFont systemFontOfSize:14.0f];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.adjustsFontSizeToFitWidth = YES;
    [_backGroundView addSubview:_numLabel];

}

- (void)setCountNum:(int)countNum
{
    _countNum = countNum;
    
}




- (void)setBlackGroundFlag:(BOOL)blackGroundFlag
{

    if (blackGroundFlag)
    {
        [_backGroundView setImage:[UIImage imageNamed:@"ios-picture_number_blackbg_56x56"]];
        _numLabel.textColor = [UIColor whiteColor];
        
    }else
    {
         [_backGroundView setImage:[UIImage imageNamed:@"ios-detail_number_blackbg_56x56"]];
        _numLabel.textColor = [UIColor whiteColor];
    }
    
}


-(void)setCurrentPage:(int)currentPage
{

    _currentPage = currentPage;
    _numLabel.text = [NSString stringWithFormat:@"%d/%d",_currentPage+1,_countNum];
}





@end
