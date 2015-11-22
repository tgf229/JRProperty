//
//  ArticleOperationView.m
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "ArticleOperationView.h"
#import "UIColor+extend.h"

@implementation ArticleOperationView

- (IBAction)moveClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:ArticleMove];
    }
}

- (IBAction)reportClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:ArticleReport];
    }
}

- (IBAction)deleteClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:ArticleDelete];
    }
}

- (void)initialIsAdmin:(BOOL)isAdmin isCreator:(BOOL)isCreator isTop:(BOOL)isTop{
    self.backgroundColor = [UIColor getColor:@"f8f8f8"];
    self.jubaoLabel.textColor = [UIColor getColor:@"444444"];
    self.shanchuLabel.textColor = [UIColor getColor:@"444444"];
    self.zhidingLabel.textColor = [UIColor getColor:@"444444"];
    self.yidongLabel.textColor = [UIColor getColor:@"444444"];
    //不是管理员  是圈主
   if (!isAdmin && isCreator){
       [self.yidongView setHidden:YES];
       [self.shanchuView setHidden:NO];
       [self.zhidingView setHidden:NO];
        self.zhidingLeading.constant = 16;
        self.jubaoLeading.constant = 87;
        self.shanchuLeading.constant = 158;
       if (isTop) {
           [self.zhidingButton setImage:[UIImage imageNamed:@"pop_icon_quxiaozhiding.png"] forState:UIControlStateNormal];
           self.zhidingLabel.text = @"取消置顶";
           [self.zhidingButton removeTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
           [self.zhidingButton addTarget:self action:@selector(cancelTopClick) forControlEvents:UIControlEventTouchUpInside];
       }
       else {
           [self.zhidingButton setImage:[UIImage imageNamed:@"pop_icon_zhiding.png"] forState:UIControlStateNormal];
           self.zhidingLabel.text = @"置顶";
           [self.zhidingButton removeTarget:self action:@selector(cancelTopClick) forControlEvents:UIControlEventTouchUpInside];
           [self.zhidingButton addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
       }
    }
    //是管理员 不是圈主
    else if ( isAdmin && !isCreator){
        [self.yidongView setHidden:NO];
        [self.shanchuView setHidden:YES];
        [self.zhidingView setHidden:YES];
        self.jubaoLeading.constant = 87;
    }
    //是管理员  是圈主
    else if ( isAdmin && isCreator){
        [self.yidongView setHidden:NO];
        [self.shanchuView setHidden:NO];
        [self.zhidingView setHidden:NO];
        if (isTop) {
            [self.zhidingButton setImage:[UIImage imageNamed:@"pop_icon_quxiaozhiding.png"] forState:UIControlStateNormal];
            self.zhidingLabel.text = @"取消置顶";
            [self.zhidingButton removeTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
            [self.zhidingButton addTarget:self action:@selector(cancelTopClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [self.zhidingButton setImage:[UIImage imageNamed:@"pop_icon_zhiding.png"] forState:UIControlStateNormal];
            self.zhidingLabel.text = @"置顶";
            [self.zhidingButton removeTarget:self action:@selector(cancelTopClick) forControlEvents:UIControlEventTouchUpInside];
            [self.zhidingButton addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //不是管理员  不是圈主
    else {
        [self.yidongView setHidden:YES];
        [self.shanchuView setHidden:YES];
        [self.zhidingView setHidden:YES];
        self.jubaoLeading.constant = 16;
    }
    
}

- (void)cancelTopClick {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:ArticleCancelTop];
    }
}

- (void)topClick {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOperationButton:)]) {
        [_delegate didSelectOperationButton:ArticleTop];
    }
}
@end
