//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "JRDefine.h"
#define SCROLLERVIEWHEIGHT  UIScreenWidth * 8 / 15



@implementation EScrollerView
@synthesize delegate;
@synthesize defaultImageView;

/**
 *  隐藏scrollview和page，显示默认图片
 */
- (void)hidePageControlAndScrollview
{
    self.scrollView.hidden=YES;
    self.pageControl.hidden=YES;
    self.defaultImageView.hidden=NO;
}
/**
 *  开启定时器
 */
- (void)startTimer
{
    if (timer ==nil) {
        timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
}

/**
 *  关闭定时器
 */
- (void)fireTimer
{
    if (timer!=nil) {
        [timer invalidate];
        timer =nil;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, SCROLLERVIEWHEIGHT)];
        self.defaultImageView.image=[UIImage imageNamed:@"home_banner"];
        self.defaultImageView.hidden=NO;
        [self addSubview:self.defaultImageView];
        
        UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, SCROLLERVIEWHEIGHT)];
        scrollview.pagingEnabled = YES;
        scrollview.contentSize = CGSizeMake(UIScreenWidth, SCROLLERVIEWHEIGHT);
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.scrollsToTop = NO;
        scrollview.delegate = self;
        self.scrollView=scrollview;
        [self addSubview:scrollview];
        
        self.pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(-6, SCROLLERVIEWHEIGHT - 20, 15, 20)];
        self.pageControl.hidesForSinglePage = YES;
        [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"coupon1_point_grey_10x10"]];//灰色圆点图片
        [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"coupon1_point_orange_10x10"]];//黑色圆点图片
        self.pageControl.enabled = NO;
//        [self addSubview:self.pageControl];
        
        self.imageArray =[[NSArray alloc]init];
    }
    return self;
}


- (void)layoutSubviews
{

    [super layoutSubviews];
    if (self.lineFlag)
    {
        UIImageView* line2 = [[UIImageView alloc]init];
        line2.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-0.5, UIScreenWidth, 0.5);
        line2.image = [UIImage imageNamed:@"line_grey_foot_40x1"];
        [self addSubview:line2];
    }
   
}
/**
 *  刷新headview
 *
 *  @param imgArr 图片数组
 */
-(void)refreshHeadViewWithImgArray:(NSArray *)imgArr
{
    self.scrollView.hidden=NO;
    self.pageControl.hidden=YES;
    self.defaultImageView.hidden=YES;
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
    [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
    [tempArray addObject:[imgArr objectAtIndex:0]];
    self.imageArray=[NSArray arrayWithArray:tempArray] ;
    self.userInteractionEnabled=YES;
    NSUInteger pageCount=[self.imageArray count];
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=(pageCount-2);
    
    self.scrollView.contentSize = CGSizeMake(UIScreenWidth * pageCount, SCROLLERVIEWHEIGHT);
    [self.scrollView setContentOffset:CGPointMake(UIScreenWidth, 0)];
    for (int i=0; i<pageCount; i++) {
        NSString *imgURL=[self.imageArray objectAtIndex:i];
        UIImageView *imgView=[[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor getColor:@"f1f1f1"];
        imgView.userInteractionEnabled=YES;
        imgView.contentMode=UIViewContentModeScaleToFill;
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"home_banner"] options:SDWebImageRetryFailed];
        [imgView setFrame:CGRectMake(UIScreenWidth*i, 0,UIScreenWidth, SCROLLERVIEWHEIGHT)];
        imgView.tag=i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgView:)];
        [imgView addGestureRecognizer:singleTap];
        [self.scrollView addSubview:imgView];
    }
    
    //使用NSTimer实现定时触发滚动控件滚动的动作。
    if ([imgArr count]>0) {
        [self startTimer];
    }
}

//定时滚动
-(void)scrollTimer{
    currentPageIndex++;
    if (currentPageIndex == ([self.imageArray count]-1)) {
        currentPageIndex=1;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(currentPageIndex * UIScreenWidth, 0.0, UIScreenWidth, SCROLLERVIEWHEIGHT) animated:YES];
}
#pragma scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    self.pageControl.currentPage=(page-1);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self fireTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (currentPageIndex==0) {
        
        [self.scrollView setContentOffset:CGPointMake(([self.imageArray count]-2)*UIScreenWidth, 0)];
    }
    if (currentPageIndex==([self.imageArray count]-1)) {
        
        [self.scrollView setContentOffset:CGPointMake(UIScreenWidth, 0)];
        
    }
    NSLog(@"sindex end=%d",currentPageIndex);
    [self startTimer];
}
/**
 *  点击图片
 *
 *  @param tags 索引
 */
- (void)clickImgView:(UIGestureRecognizer *)rec
{
    UIImageView *imgview=(UIImageView *)rec.view;
    if([self.delegate respondsToSelector:@selector(ScrollImagesView:)])
    {
        [self.delegate ScrollImagesView:imgview.tag];
    }
}

@end
