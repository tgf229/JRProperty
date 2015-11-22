//
//  ImageButtonView.m
//  JRProperty
//
//  Created by duwen on 14/11/28.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ImageButtonView.h"

@implementation ImageButtonView

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"default_portrait_140x140"]];
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints= NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        
        _imageButton = [[UIButton alloc] init];
        [self addSubview:_imageButton];
        _imageButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageButton addTarget:self action:@selector(showLargeImageView:) forControlEvents:UIControlEventTouchUpInside];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageButton)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageButton]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageButton)]];
        
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setImage:[UIImage imageNamed:@"service_icon_delete"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"service_icon_delete"] forState:UIControlStateHighlighted];
        [self addSubview:_deleteButton];
        _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_deleteButton addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_deleteButton]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_deleteButton)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_deleteButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_deleteButton)]];
    }
    return self;
}

- (void)showLargeImageView:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLargeImageViewWithTag:)]) {
        [self.delegate showLargeImageViewWithTag:self.tag];
    }
}

- (void)deleteImageView:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSelectedImageViewWithTag:)]) {
        [self.delegate deleteSelectedImageViewWithTag:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
