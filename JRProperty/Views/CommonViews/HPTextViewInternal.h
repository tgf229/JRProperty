//
//  HPTextViewInternal.h
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//  圈子评论页面 输入框view （高度自适应）

#import <UIKit/UIKit.h>

@interface HPTextViewInternal : UITextView

@property (nonatomic, strong) NSString *placeholder; // placeholder文本
@property (nonatomic, strong) UIColor *placeholderColor; // placeholder颜色
@property (nonatomic) BOOL displayPlaceHolder; // placeholder是否展示

@end
