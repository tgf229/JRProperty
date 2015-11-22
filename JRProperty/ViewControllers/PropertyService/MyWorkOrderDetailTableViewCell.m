//
//  MyWorkOrderDetailTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyWorkOrderDetailTableViewCell.h"
#import "JRDefine.h"
#import "UIImageView+WebCache.h"
#import "LoginManager.h"

#define IMAGEVIEWHEIGHT (UIScreenWidth - 80) / 3

@implementation MyWorkOrderDetailTableViewCell
- (void)setFrame:(CGRect)frame{
    if (CURRENT_VERSION < 7.0f) {
        frame.origin.x -= 15;
        frame.size.width += 30;
    }
    [super setFrame:frame];
}
- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundView:[[UIView alloc] init]];
    [_helpNameLabel setTextColor:UIColorFromRGB(0x007daf)];
    [_workNameLabel setTextColor:UIColorFromRGB(0x888888)];
    [_replyLabel setTextColor:UIColorFromRGB(0x333333)];
    [_replyTimeLabel setTextColor:UIColorFromRGB(0x666666)];
    _helpNameLabel.text = @"";
    _workNameLabel.text = @"";
    _replyLabel.text = @"";
    _replyTimeLabel.text = @"";
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15;
    
//    for (UIImageView *imageView in _helpImageViewArray) {
//        [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
//    }
}

- (IBAction)imageViewSelected:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(imageViewSelectedWithIndexPath:selectedIndex:)]) {
        [self.delegate imageViewSelectedWithIndexPath:self.indexPath selectedIndex:[sender tag]];
    }
}

- (void)reFrashDataWithPathModel:(WorkPathModel *)pathModel{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:pathModel.uImageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    _helpNameLabel.text = pathModel.uName;
//    if (![_uName isEqualToString:pathModel.uName]) {
//        _workNameLabel.text = @"客服";
//    }else{
       // _workNameLabel.hidden = YES;
    _workNameLabel.text = pathModel.depName;
//    }
    
    NSString * desc = [pathModel.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * content = [pathModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content&&![@"" isEqualToString:content]) {
        NSString * str = [NSString stringWithFormat:@"%@\n描述:%@",desc,content];
        _replyLabel.text = str;
    }else{
        _replyLabel.text = desc;
    }
    _replyTimeLabel.text = pathModel.time;
    
    if (_indexPath.row == 0) {
        _stepBgImageView.image = [UIImage imageNamed:@"service_steps_greenbg"];
    }else{
        _stepBgImageView.image = [UIImage imageNamed:@"service_steps_greybg"];
    }
//    _stepLabel.text = [NSString stringWithFormat:@"STEP%d",_indexPath.row];
    
    
    if (pathModel.imageList.count > 0) {
        if (pathModel.imageList.count > 3) {
            _helpImageViewHeightConstraint.constant = IMAGEVIEWHEIGHT * 2 + 4;
            _centerViewHeightConstraint.constant = IMAGEVIEWHEIGHT;
        }else{
            _helpImageViewHeightConstraint.constant = IMAGEVIEWHEIGHT;
            _centerViewHeightConstraint.constant = 0;
        }
    }else{
        _helpImageViewHeightConstraint.constant = 0;
        _centerViewHeightConstraint.constant = 0;
    }
    
    for (int j = pathModel.imageList.count; j<6; j++) {
        UIImageView *imageView = (UIImageView *)_helpImageViewArray[j];
        [imageView setImage:nil];
    }
    
    for (int i = 0; i < pathModel.imageList.count; i++) {
        UIImageView *imageView = (UIImageView *)_helpImageViewArray[i];
        WorkImageModel *imageModel = (WorkImageModel *)pathModel.imageList[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrlS] placeholderImage:[UIImage imageNamed:@"community_default"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
