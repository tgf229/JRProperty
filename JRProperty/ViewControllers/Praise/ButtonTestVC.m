//
//  ButtonTestVC.m
//  JRProperty
//
//  Created by YMDQ on 15/12/8.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "ButtonTestVC.h"
#import "JRDefine.h"
#import "ActionSheetDatePicker.h"

@interface ButtonTestVC ()

{
    UIButton * tButton;
    UIView * tView;
    UILabel * tLabel;
}

@property(copy,nonatomic) NSString * year; // 基准年份

@property(copy,nonatomic) NSString * cYear; // 当前年份
@property(copy,nonatomic) NSString * cMonth; // 当前月份

@property(copy,nonatomic) NSString * sdYear; // 选择年份

- (IBAction)anniu:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@end

@implementation ButtonTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cYear = @"2017";
    self.cMonth = @"8";
    self.year = @"2015";
    self.sdYear = self.cYear;
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    // Do any additional setup after loading the view.
    CGSize size = CGSizeMake(320,2000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [@"星雨华府" sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    tView = [[UIView alloc] initWithFrame:CGRectMake((UIScreenWidth - labelsize.width - 17) / 2, 0, labelsize.width + 17, 40)];
    [tView setBackgroundColor:[UIColor clearColor]];
    
    tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tView.frame.size.width - 17, 40)];
    [tLabel setBackgroundColor:[UIColor clearColor]];
    [tLabel setFont:[UIFont systemFontOfSize:20]];
    tLabel.text = @"按钮测试";
    [tView addSubview:tLabel];
    
    tButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tView.frame.size.width, tView.frame.size.height)];
    [tButton setImage:[UIImage imageNamed:@"home_icon_arrow_24x14"] forState:UIControlStateNormal];
    [tView addSubview:tButton];
    [tButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [tButton addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
//    tButton.hidden = YES;
    
    self.navigationItem.titleView = tView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)titleButtonSelected:(id)sender {
    NSLog(@"title按钮测试～～～～～～～～～～～～～～～～～～～～");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)anniu:(id)sender {
    
    NSLog(@"aaaaaaaaaaaaaaaaa");
//    NSDate *currentDate ;
//    if (/* DISABLES CODE */ (0)) {
//        //如果日期label没有内容 选择器默认日期为当天日期
//        currentDate = [NSDate date];
//    }
//    else {
//        //如果日期label有内容 选择器默认日期为label日期
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM"];
//        currentDate = [formatter dateFromString:@"2015-12"];
//    }
//    
//    [ActionSheetDatePicker showPickerWithTitle:@""
//                                datePickerMode:UIDatePickerModeDate
//                                  selectedDate:currentDate
//                                     doneBlock:^(ActionSheetDatePicker *picker,id selectedDate,id origin){
//                                         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//                                         [formatter setDateFormat:@"yyyy-MM-dd"];
////                                         self.birthdayLabel.text = [formatter stringFromDate:selectedDate];
////                                         self.userinfoModel.birth = [self.birthdayLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                                     }
//                                   cancelBlock:^(ActionSheetDatePicker *picker){
//                                       // 取消，不做其他操作
//                                       
//                                   }
//                                        origin:self.view];
    
//    UIActionSheet * uiActionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
//    uiActionSheet.userInteractionEnabled = YES;
//    uiActionSheet.backgroundColor = [UIColor clearColor];
//    
//    UIDatePicker * uiDatePicker = [[UIDatePicker alloc] init];
//    uiDatePicker.tag = 1000;
//    uiDatePicker.datePickerMode = UIDatePickerModeDate;
//    
//    [uiActionSheet addSubview:uiDatePicker];
//    [uiActionSheet showInView:self.view];
//    uiActionSheet.tag = 100;
    
    
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
//                                                              delegate:self
//                                                     cancelButtonTitle:@"取消"
//                                                destructiveButtonTitle:@"确定"
//                                                     otherButtonTitles:nil] ;
//    actionSheet.userInteractionEnabled = YES;
//    UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
//    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//    
//    [actionSheet addSubview:datePicker];
//    [actionSheet showInView:self.view];
    
    UIAlertController * alertVc = [[UIAlertController alloc] init];
    alertVc.title = @"\n\n\n\n\n\n\n\n\n\n";
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"取消");
    }];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
        NSInteger row0 = [self.myPickerView selectedRowInComponent:0];
        NSInteger row1 = [self.myPickerView selectedRowInComponent:1];
        
        NSInteger sdyearint = [self.year integerValue]+row0;
        NSString *chyear;
        chyear = [NSString stringWithFormat:@"%ld",sdyearint];
        
        NSString *chMonth;
        if ([chyear isEqualToString:@"2015"]) {
            chMonth = @"12";
        }else{
            chMonth = [NSString stringWithFormat:@"%ld",row1+1];
        }
        
        NSString * time = [self yearMonth2Time:chyear month:chMonth];
        if (![time isEqualToString:@"当前选中的年月"]) {
            //传参到下一个vc中
            if ([time isEqualToString:@"系统当前年月"]) {
                // 传参到praiselistvc中
            }else{
                // 传参到rankingvc中
            }
        }
        
        NSLog(@"确定");
    }];
//    UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
    
    int sdYearint = [self.sdYear intValue];
    int yearint = [self.year intValue];
    int yearrow = sdYearint-yearint;
    
    int monthrow;
    if ([self.sdYear isEqualToString:@"2015"]) {
        monthrow = 0;
    }else {
        monthrow =  [self.cMonth intValue]-1;
    }
    [self.myPickerView selectRow:yearrow inComponent:0 animated:NO];
    [self.myPickerView selectRow:monthrow inComponent:1 animated:NO];

    [self.myPickerView setFrame:CGRectMake(15.0, 0.0, self.myPickerView.frame.size.width, self.myPickerView.frame.size.height)];
    
    [alertVc.view addSubview:self.myPickerView];
    [alertVc addAction:cancelAction];
    [alertVc addAction:okAction];
    [self presentViewController:alertVc animated:true completion:nil];
    
}

-(NSString*)yearMonth2Time:(NSString*)vyear month:(NSString*)vmonth{
    if (vmonth.length<2) {
        vmonth = [@"0" stringByAppendingString:vmonth];
    }
    return [vyear stringByAppendingString:vmonth];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        int intYear = [self.year intValue];
        int intCyear = [self.cYear intValue];
        return intCyear-intYear+1;
    }else{
        if ([self.sdYear isEqualToString:@"2015"]) {
            return 1;
        }else if ([self.sdYear isEqualToString:self.cYear]){
            return [self.cMonth integerValue];
        }else{
            return 12;
        }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) { // year
        long syear = [self.year intValue]+row;
        return [NSString stringWithFormat:@"%ld",syear];
    }else{
        if ([self.sdYear isEqualToString:@"2015"]) {
            return @"12";
        }else{
            long m = row+1;
            return [NSString stringWithFormat:@"%ld",m];
        }
        
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        NSInteger row = [self.myPickerView selectedRowInComponent:0];
        long syear = [self.year intValue]+row;
        self.sdYear = [NSString stringWithFormat:@"%ld",syear];
        [self.myPickerView reloadComponent:1];
        
        if ([self.sdYear isEqualToString:self.cYear]) {
            int monthrow;
            monthrow =  [self.cMonth intValue]-1;
            [self.myPickerView selectRow:monthrow inComponent:1 animated:NO];
        }
        

    }
}


@end
