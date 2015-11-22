//
//  ArticleOperationView.h
//  JRProperty
//
//  Created by tingting zuo on 15-4-2.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//
typedef enum {
    ArticleReport = 0,
    ArticleDelete = 1,
    ArticleTop = 2,
    ArticleCancelTop = 3,
    ArticleMove = 4,
} ArticleOperationType;
#import <UIKit/UIKit.h>
@protocol ArticleOperationViewDelegate <NSObject>

/**
 *  话题操作
 *
 *  @param  ArticleOperationType 话题操作类型
 */
- (void)didSelectOperationButton:(ArticleOperationType)operationType;
@end
@interface ArticleOperationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *yidongLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhidingLabel;
@property (weak, nonatomic) IBOutlet UILabel *jubaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *shanchuLabel;
@property (weak, nonatomic) IBOutlet UIView *yidongView;
@property (weak, nonatomic) IBOutlet UIView *zhidingView;
@property (weak, nonatomic) IBOutlet UIView *jubaoView;
@property (weak, nonatomic) IBOutlet UIView *shanchuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidingLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jubaoLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shanchuLeading;
@property (weak, nonatomic) IBOutlet UIButton *zhidingButton;
@property (weak, nonatomic) id<ArticleOperationViewDelegate> delegate; //代理

- (IBAction)moveClick:(id)sender;
- (IBAction)reportClick:(id)sender;
- (IBAction)deleteClick:(id)sender;
- (void)initialIsAdmin:(BOOL)isAdmin isCreator:(BOOL)isCreator isTop:(BOOL)isTop ;
@end
