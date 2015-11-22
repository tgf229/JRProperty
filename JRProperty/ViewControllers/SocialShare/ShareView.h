//
//  ShareView.h
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//
#define SHARE_SUCCESSFUL   @"分享成功"
#define SHARE_CANCEL       @"取消分享"
#define SHARE_FAILED       @"分享失败"
#define AUTHORIZE_SUCCESSFUL   @"授权成功，请继续分享"
#define AUTHORIZE_CANCEL       @"取消授权"
#define AUTHORIZE_FAILED       @"授权失败"

#import <UIKit/UIKit.h>
#import "shareButtonView.h"
#import "ArticleOperationView.h"
@class shareButtonView;
@class ArticleOperationView;
@protocol SocialShareViewDelegate <NSObject>

/**
 *  点击社交平台
 *
 *  @param  SocialSnsType 社交平台类型
 */
- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType;
/**
 *  话题操作
 *
 *  @param  ArticleOperationType 话题操作类型
 */
- (void)didSelectOperationButton:(ArticleOperationType)operationType;
@end

@interface ShareView : UIView<ShareButtonViewDelegate,ArticleOperationViewDelegate>
@property (nonatomic, strong) UIView      * shadeView;          // 阴影背景
@property (nonatomic, strong) shareButtonView      * shareButtonView;
@property (nonatomic, strong) ArticleOperationView      * operationView;          
@property (weak, nonatomic) id<SocialShareViewDelegate> delegate; //代理

@property (nonatomic, copy)   dispatch_block_t updateBlock;     // 确定按钮回调事件
@property (nonatomic, strong) UIButton    *cancelButton;        // 取消按钮
/**
 *  UI页面
 *
 *  @return 页面
 */
- (id)initViewIsAdmin:(BOOL)isAdmin isCreator:(BOOL)isCreator isTop:(BOOL)isTop;
/**
 *  展示UI
 */
- (void)show;
/**
 *  去除页面
 */
- (void)dismissPage;
@end
