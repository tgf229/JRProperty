//
//  ArticlePictureView.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListModel.h"


@class ArticlePictureView;
@protocol ArticlePictureDelegate <NSObject>
/**
 *  点击小图进入大图浏览
 *
 *  @param pictureView xiao图区域
 *  @param index    图片下标
 *  @param info     图片数组
 */
-(void) imageClick:(ArticlePictureView*)pictureView atIndex:(NSUInteger)index withInfo:(NSArray *) info;

@end

@interface ArticlePictureView : UIView

@property (strong,nonatomic)NSMutableArray *imageSArray;
@property (strong,nonatomic)NSMutableArray *imageLArray;

@property (weak, nonatomic) id<ArticlePictureDelegate> delegate; //代理
-(void) setData:(NSArray *)data;

+(CGFloat) height:(NSInteger)imageCount;


@end
