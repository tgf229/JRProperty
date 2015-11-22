//
//  PhotosViewController.h
//  CenterMarket
//
//  Created by 周光 on 14-7-4.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import "JRViewController.h"

@protocol PhotosViewDelegate <NSObject>

@optional


/**
 *  图片管理器返回时所触发的函数
 *
 *  @param index 所返回时所在的图片位置
 */
- (void)photosViewBackAtIndex:(NSInteger)index;

@end

@protocol PhotosViewDatasource <NSObject>


@optional
/**
 *  根据下标取得图片   (这两个接口实现任何其中之一即可)
 *
 *  @param index 图片的下标
 *
 *  @return 返回每张图片
 */
- (UIImage *)photosViewImageAtIndex:(NSInteger)index;


/**
 *  每张图片的URL   (这两个接口实现任何其中之一即可)
 *
 *  @param index 图片的下标
 *
 *  @return 返回每张图片的URL
 */
- (NSString *)photosViewUrlAtIndex:(NSInteger)index;

@required

/**
 *  图片管理器的数量
 *
 *  @return 返回总个数
 */
- (NSInteger)photosViewNumberOfCount;


@end






@interface PhotosViewController : JRViewControllerWithBackButton

//代理 (非必须)
@property (nonatomic,weak) id <PhotosViewDelegate>   delegate;

//图片数据源（必须）
@property (nonatomic,weak) id <PhotosViewDatasource>  datasource;

//当前页 （非必须）
@property (nonatomic,assign)  int currentPage;



@end
