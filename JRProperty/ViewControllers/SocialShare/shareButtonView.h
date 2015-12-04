//
//  shareButtonView.h
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//
#import "UIShareItemButton.h"
//typedef enum {
//    SocialSnsTypeNone = 0,
//    SocialSnsTypeCircle = 10,
//    SocialSnsTypeWechat = 11,
//    SocialSnsTypeWechatCircle = 12,
//    SocialSnsTypeQQ = 14,
//    SocialSnsTypeQQZone = 15,
//    SocialSnsTypeSina = 18
//} SocialSnsType;
//#import <UIKit/UIKit.h>
typedef enum {
    ArticleReport = 0,
    ArticleDelete = 1,
    ArticleTop = 2,
    ArticleCancelTop = 3,
    ArticleMove = 4,
} ArticleOperationType;
@protocol ShareButtonViewDelegate <NSObject>

/**
 *  点击社交平台
 *
 *  @param  SocialSnsType 社交平台类型
 */
- (void)didSelectSocialButton:(ZYSocialSnsType)platformType;
- (void)didSelectOperationButton:(ArticleOperationType)operationType;
@end



@interface shareButtonView : UIView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *wenxinLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *kongjianLabel;
@property (nonatomic,assign)  ZYSocialSnsType type;       //分享类型
@property (weak, nonatomic) id<ShareButtonViewDelegate> delegate; //代理

- (IBAction)shareWeixinClick:(id)sender;
- (IBAction)shareFriendClick:(id)sender;
- (IBAction)shareSinaClick:(id)sender;
- (IBAction)shareQQClcik:(id)sender;
- (IBAction)shareKongjianClick:(id)sender;
-(IBAction)reportClick:(id)sender;

- (void)initial ;
@end
