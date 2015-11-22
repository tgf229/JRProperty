//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
// 滚动试图

#import <UIKit/UIKit.h>
#import "MyPageControl.h"

@protocol EScrollerViewDelegate <NSObject>
@optional
- (void)ScrollImagesView:(long)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	CGRect viewSize;//试图尺寸
    id<EScrollerViewDelegate> __weak delegate;//委托
    int currentPageIndex;//当前页
    NSTimer *timer;  //定时器
}
@property(nonatomic,weak)id<EScrollerViewDelegate> delegate;
@property (nonatomic, strong)UIImageView *defaultImageView;//默认图片
@property (nonatomic, strong)NSArray *imageArray;//图片数组
@property (nonatomic, strong)MyPageControl *pageControl;//自定义page
@property (nonatomic, strong)UIScrollView *scrollView;



@property (nonatomic,assign) BOOL        lineFlag;      //视图底部是否展示分割线
/**
 *  释放scrollview和page
 */
- (void)hidePageControlAndScrollview;
/**
 *  启动定时器
 */
- (void)startTimer;
/**
 *  停止定时器
 */
- (void)fireTimer;
/*
 *加入图片
 @param rect 位置
 @param imgArr 图片数组
 @param isPad 是否是ipad版本
 */
-(void)refreshHeadViewWithImgArray:(NSArray *)imgArr;
@end
