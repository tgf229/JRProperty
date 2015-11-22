//
//  WelcomeViewController.m
//  JRProperty
//
//  Created by liugt on 14/12/9.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "WelcomeViewController.h"
#import "JRDefine.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray   *guideImageNameArray;       // 屏幕引导图片名称
@property (nonatomic,weak)   IBOutlet  UIImageView         *backgroundImgView;
@property (nonatomic,weak)   IBOutlet  NSLayoutConstraint  *backgroundTopConstraint;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (UIScreenWidth == 160)
    {
        [self.backgroundImgView setImage:[UIImage imageNamed:@"Default"]];
        self.guideImageNameArray = [NSArray arrayWithObjects:@"yindao1-640x960",@"yindao2-640x960",@"yindao3-640x960", nil];
    }
    else if (UIScreenWidth == 320)
    {
        if(UIScreenHeight == 480)
        {
            [self.backgroundImgView setImage:[UIImage imageNamed:@"Default"]];
            self.guideImageNameArray = [NSArray arrayWithObjects:@"yindao1-640x960",@"yindao2-640x960",@"yindao3-640x960", nil];
        }
        else
        {
            [self.backgroundImgView setImage:[UIImage imageNamed:@"Default-568h"]];
            self.guideImageNameArray = [NSArray arrayWithObjects:@"yindao1",@"yindao2",@"yindao3", nil];
        }
    }
    else if (UIScreenWidth == 375)
    {
        [self.backgroundImgView setImage:[UIImage imageNamed:@"Default-667h"]];
        self.guideImageNameArray = [NSArray arrayWithObjects:@"yindao1",@"yindao2",@"yindao3", nil];
    }
    else if (UIScreenWidth == 414)
    {
        [self.backgroundImgView setImage:[UIImage imageNamed:@"Default-736h"]];
        self.guideImageNameArray = [NSArray arrayWithObjects:@"yindao1",@"yindao2",@"yindao3", nil];
    }
    
    
    // 如果是6.0系统
    if (CURRENT_VERSION < 7.0) {
        // 背景图向上偏移 -20
        self.backgroundTopConstraint.constant = -20;
        [self.view layoutIfNeeded];
    }
}


/**
 *  创建并展示引导页
 */
- (void)createGuidePageView
{
    self.backgroundImgView.hidden = YES;
    
    //引导页
    UIScrollView *guideScroll = [[UIScrollView alloc] init];
    guideScroll.frame = CGRectMake(0, 0, UIScreenWidth, self.view.frame.size.height);
    guideScroll.delegate = self;
    guideScroll.pagingEnabled = YES;
    guideScroll.showsHorizontalScrollIndicator = NO;
    guideScroll.contentSize = CGSizeMake(UIScreenWidth*[self.guideImageNameArray count], self.view.frame.size.height);
    
    for (int i = 0; i < [self.guideImageNameArray count]; i++) {
        UIImageView *guideView = [[UIImageView alloc] init];
        guideView.userInteractionEnabled = YES;
        guideView.frame = CGRectMake(UIScreenWidth*i, 0, UIScreenWidth, self.view.frame.size.height);
        
        NSString *path = [[NSBundle mainBundle] resourcePath];
        path = [NSString stringWithFormat:@"%@/%@.png",path,[self.guideImageNameArray objectAtIndex:i]];
        guideView.image = [UIImage imageWithContentsOfFile:path];
        
        if (i + 1 == [self.guideImageNameArray count]) {
            //添加立刻体验按钮
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            enterButton.backgroundColor = [UIColor clearColor];
            enterButton.frame = CGRectMake((UIScreenWidth - 162)/2, UIScreenHeight - 90, 162, 80);
            [enterButton addTarget:self action:@selector(enterButtonPress) forControlEvents:UIControlEventTouchUpInside];
            [guideView addSubview:enterButton];
        }
        
        [guideScroll addSubview:guideView];
    }
    
    [self.view addSubview:guideScroll];
}


/**
 *  点击立刻体验按钮
 */
- (void)enterButtonPress
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterButtonPressed)]) {
        //[self buildBackgroundImage];
        [_delegate enterButtonPressed];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    if (CURRENT_VERSION < 7.0) {
        self.backgroundImgView.image = nil;
        scrollView.contentSize = CGSizeMake(UIScreenWidth*[self.guideImageNameArray count], self.view.frame.size.height);
    }
    else{
        if (offset.x < 0 || offset.x > UIScreenWidth*([self.guideImageNameArray count] -1)) {
            //左右最边缘禁止滑动
            scrollView.scrollEnabled = NO;
        }
        else
        {
            scrollView.scrollEnabled = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
