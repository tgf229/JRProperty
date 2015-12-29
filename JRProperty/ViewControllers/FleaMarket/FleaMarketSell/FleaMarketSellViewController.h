//
//  FleaMarketSellViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/12/22.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"



@interface FleaMarketSellViewController : JRViewControllerWithBackButton

@property (weak, nonatomic) IBOutlet UITextView *prodInfoTextView;
@property (weak, nonatomic) IBOutlet UILabel *placelabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
- (IBAction)sliderAction:(id)sender;
- (IBAction)priceAction:(id)sender;
- (IBAction)noPriceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nowPrice;
@property (weak, nonatomic) IBOutlet UITextField *oldPrice;

- (IBAction)sliderDragAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *noPriceButton;

@property (weak, nonatomic) IBOutlet UIView *priceView2;

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UISwitch *isPhoneView;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UILabel *addImgtipsView;
@property (weak, nonatomic) IBOutlet UILabel *addImgtipsView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addImgtipsConstraint;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toPriceViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *userConPhone;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
- (IBAction)wantSaleAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *slideImgView;
- (IBAction)wantSellAction:(id)sender;


@end
