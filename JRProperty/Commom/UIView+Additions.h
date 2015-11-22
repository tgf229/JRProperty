//
//  UIView+Additions.h
//  iCity
//
//  Created by zhoug on 2/28/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)


/*!
 @property      frameX
 @discussion    Shorthand for setting a frame's x value
 */
@property(assign) CGFloat frameX;

/*!
 @property      frameY
 @discussion    Shorthand for setting/getting a frame's y value
 */
@property(assign) CGFloat frameY;

/*!
 @property      frameWidth
 @discussion    Shorthand for setting/getting a frame's width value
 */
@property(assign) CGFloat frameWidth;

/*!
 @property      frameHeight
 @discussion    Shorthand for setting/getting a frame's height value
 */
@property(assign) CGFloat frameHeight;

/*!
 @property      frameSize
 @discussion    Shorthand for setting/getting a frame's width and height together
 
 @param         size        new width and height values.
 */
@property(assign) CGSize frameSize;

/*!
 @property      frameOrigin
 @discussion    Shorthand for setting/getting a frame's x and y together
 
 @param         origin        new x and y values.
 
 */
@property(assign) CGPoint frameOrigin;

/**
 *  获取UIView的控制器
 *
 *  @return 返回UIView的控制器
 */
- (UIViewController *)viewController;
@end



@interface UIView(Constraints)


/**
 *  获取在父视图上相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相对应的约束
 */
- (NSLayoutConstraint *)findConstraintForAttribute:(NSLayoutAttribute)attribute;


/**
 *  获取自身的相关属性的约束
 *
 *  @param attribute 约束属性
 *
 *  @return 相应的约束
 */
- (NSLayoutConstraint *)findOwnConstraintForAttribute:(NSLayoutAttribute)attribute;
@end



