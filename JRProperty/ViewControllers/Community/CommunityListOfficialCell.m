//
//  CommunityListOfficialCell.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/9.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "CommunityListOfficialCell.h"
#import "JRDefine.h"
#import "LoginManager.h"
#import "ReportViewController.h"

@implementation CommunityListOfficialCell

- (void)awakeFromNib {
    //按钮与文字的间距
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.commentButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    
    self.detailModel = [[ArticleDetailModel alloc]init];
    self.communityService =[[CommunityService alloc]init];
    self.shareService = [[ShareToSnsService alloc]init];

}

-(void)showCell:(ArticleDetailModel *)detailModel{
    _detailModel = detailModel;
    
    self.volLabel.text = [NSString stringWithFormat:@"VOL  %@",detailModel.vol];
    self.titleLabel.text = detailModel.title;
    self.subTitleLabel.text = detailModel.subTitle;
    
    [self setData:detailModel];
}

-(void)setData:(ArticleDetailModel *)detailModel{
    if ([@"1" isEqualToString:detailModel.flag]) {
        [self.praiseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateNormal];
        [self.praiseButton setImage:[UIImage imageNamed:@"community_list_official_like"] forState:UIControlStateHighlighted];
        [self.praiseButton removeTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseButton addTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.praiseButton setImage:[UIImage imageNamed:@"community_list_official_like"] forState:UIControlStateNormal];
        [self.praiseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateHighlighted];
        [self.praiseButton removeTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.praiseButton setTitle:detailModel.praiseNum forState:UIControlStateNormal];
    [self.commentButton setTitle:detailModel.commentNum forState:UIControlStateNormal];
}

- (void)praise {
    [UIView animateWithDuration:0.2 animations:^{
        _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _praiseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _praiseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    _detailModel.flag = @"1";
    int number = [_detailModel.praiseNum intValue]+1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    _detailModel.praiseNum =numberStr;
    [self setData:_detailModel];
    
    //调接口服务 赞
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus300802:CID_FOR_REQUEST aId:_detailModel.aId uId:uid     type:@"1" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)cancelPraise{
    [UIView animateWithDuration:0.2 animations:^{
        _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _praiseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _praiseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _praiseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    _detailModel.flag = @"0";
    int number = [_detailModel.praiseNum intValue]-1;
    NSString *numberStr = [NSString stringWithFormat:@"%d",number];
    _detailModel.praiseNum =numberStr;
    [self setData:_detailModel];
    
    //调接口服务 赞
    NSString *uid = [LoginManager shareInstance].loginAccountInfo.uId;
    [self.communityService Bus300802:CID_FOR_REQUEST aId:_detailModel.aId uId:uid     type:@"0" success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)moreClick:(id)sender
{
    BOOL is_super;
    if ([IS_SUPER_REQUEST intValue] == 2) {
        is_super = YES;
    }
    else {
        is_super = NO;
    }
    self.shareView = [[ShareView alloc]initViewIsAdmin:is_super isCreator:NO isTop:NO];
    self.shareView.delegate = self;
    [self.shareView show];
}

//举报 移动
- (void)didSelectOperationButton:(ArticleOperationType)operationType {
    [self.shareView dismissPage];
    //举报话题
    if (operationType == ArticleReport) {
        ReportViewController *controller = [[ReportViewController alloc]init];
        controller.articleId = _detailModel.aId;
        UIViewController *communityListController = [self getSuper];
        [communityListController.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didSelectSocialPlatform:(ZYSocialSnsType)platformType {
    [self.shareView dismissPage];
    
    self.shareService.actID = _detailModel.articleId;
    NSData *imageData = nil;
    NSData *bigImageData=nil;
    if (_detailModel.imageList.count>0) {
        ImageModel *image = [_detailModel.imageList objectAtIndex:0];
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlS]];
        bigImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.imageUrlL]];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_SHARED_ARTICLE_URL,_detailModel.aId];
    
    NSString *fullMessage = [NSString stringWithFormat:@"%@\n%@%@",_detailModel.name,_detailModel.content,urlStr];
    
    [self.shareService showSocialPlatformIn:self
                                 shareTitle:_detailModel.name
                                  shareText:_detailModel.content
                                   shareUrl:urlStr
                            shareSmallImage:imageData
                              shareBigImage:bigImageData
                           shareFullMessage:fullMessage
                             shareToSnsType:platformType];
}

-(UIViewController *)getSuper{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
