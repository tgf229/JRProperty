//
//  CustomKeyboard.h
//  keyboard
//
//  Created by liugt on 14-12-03.
//  Copyright (c) 2014年 yurun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFFNumericKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSInteger) number;
- (void) numberKeyboardBackspace;
- (void) xButtonPressed;
@end

@interface AFFNumericKeyboard : UIView
{
}

@property (nonatomic,assign) id<AFFNumericKeyboardDelegate> delegate;

@end
