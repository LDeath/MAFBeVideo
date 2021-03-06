//
//  UIView+ConstraintHelper.h
//  BEVideo
//
//  Created by FM on 16/1/6.
//  Copyright © 2016年 BlueEye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintHelper)


// Constraint Management (Recipe 5-1)
- (BOOL)constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2;
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraints:(NSArray *)anArray;

// Superview bounds limits (Recipe 5-2)
- (NSArray *)constraintsLimitingViewToSuperviewBounds;
- (void)constrainWithinSuperviewBounds;
- (void)addSubviewAndConstrainToBounds:(UIView *)view;

// Size & Position (Recipe 5-2)
- (NSArray *)sizeConstraints:(CGSize)aSize;
- (NSArray *)positionConstraints: (CGPoint)aPoint;
- (void)constrainSize:(CGSize)aSize;
- (void)constrainPosition: (CGPoint)aPoint; // w/in superview bounds

// Centering (Recipe 5-3)
- (NSLayoutConstraint *)horizontalCenteringConstraint;
- (NSLayoutConstraint *)verticalCenteringConstraint;
- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerInSuperview;

// Aspect Ratios (Recipe 5-4)
- (NSLayoutConstraint *)aspectConstraint:(CGFloat)aspectRatio;
- (void)constrainAspectRatio:(CGFloat)aspectRatio;

// Debugging & Logging (Recipe 5-6)
- (NSString *)constraintRepresentation:(NSLayoutConstraint *)aConstraint;
- (void)showConstraints;
@end
