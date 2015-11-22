//
//  AccountManageDetailTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "AccountManageDetailTableViewCell.h"
#import "JRDefine.h"
@implementation AccountManageDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImage *image = [UIImage imageNamed:@"mybill_check_list_contentbg"];
//    [_bgImageView setImage:[image stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
    
    _payTableView = [[UITableView alloc] init];
    [_payTableView setDelegate:self];
    [_payTableView setDataSource:self];
    [_payTableView setBackgroundColor:[UIColor clearColor]];
    _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_payTableView setScrollEnabled:NO];
    [_historyPaymentView addSubview:_payTableView];
    _payTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_historyPaymentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_payTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_payTableView)]];
    [_historyPaymentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_payTableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_payTableView)]];
    
    _noPayLabel.text = @"";
    _havePayLabel.text = @"";
}

- (void)refrashAccountManageDetailDataWithFeeModel:(FeeModel *)feeModel{
    _nameLabel.text = feeModel.name;
    _noPayLabel.text = [NSString stringWithFormat:@"¥%@",feeModel.totalMoney];
    _havePayLabel.text = [NSString stringWithFormat:@"¥%@",feeModel.money];
    if ([_havePayLabel.text isEqualToString:_noPayLabel.text]) {
        _havePayLabel.textColor = UIColorFromRGB(0x63a809);
//        _goPayButton.hidden = YES;
//        _goPayButtonTitleLabel.hidden = YES;
    }else{
        _havePayLabel.textColor = UIColorFromRGB(0xbb474d);
//        _goPayButton.hidden = NO;
//        _goPayButton.enabled = NO;
//        _goPayButtonTitleLabel.hidden = NO;
    }
    _goPayButton.hidden = YES;
    _goPayButtonTitleLabel.hidden = YES;
    
    _historyPaymentConstraint.constant = 44 * feeModel.moneyList.count;
    self.dataSourceArray = feeModel.moneyList;
    [_payTableView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"CELLINDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.textLabel setTextColor:UIColorFromRGB(0x666666)];
        
        UILabel *moneyLab = [[UILabel alloc] init];
        moneyLab.tag = 99;
        [moneyLab setBackgroundColor:[UIColor clearColor]];
        [moneyLab setTextColor:UIColorFromRGB(0xbb474d)];
        [moneyLab setFont:[UIFont systemFontOfSize:14.0f]];
        [moneyLab setTextAlignment:NSTextAlignmentRight];
        [cell.contentView addSubview:moneyLab];
        [moneyLab setText:@"-1800"];
        [moneyLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moneyLab]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(moneyLab)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[moneyLab]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(moneyLab)]];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mybill_check_list_line_dash"]];
        lineImageView.tag = 100;
        [cell.contentView addSubview:lineImageView];
        lineImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineImageView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineImageView)]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lineImageView]" options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(lineImageView)]];
    }
//    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
//    if ([_dataSourceArray count] == indexPath.row + 1) {
//        imageView.hidden = YES;
//    }else{
//        imageView.hidden = NO;
//    }
    UILabel * lab = (UILabel *)[cell.contentView viewWithTag:99];
    MoneyModel *moneyModel = (MoneyModel *)_dataSourceArray[indexPath.row];
    
    if ([@"" isEqualToString:moneyModel.time]||moneyModel.time==nil) {
        cell.textLabel.text = @"";
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormatter dateFromString:moneyModel.time];
        [dateFormatter setDateFormat:@"yy年MM月dd日"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        cell.textLabel.text = strDate;
    }
    
    
    if ([@"0" isEqualToString:moneyModel.money] || moneyModel.money==nil) {
        lab.text = @"0";
    }else{
        lab.text = [NSString stringWithFormat:@"- %@",moneyModel.money];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

@end
