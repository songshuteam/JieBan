//
//  AGBorderHelper.h
//  AnyGo
//
//  Created by tony on 14-7-1.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, AGRoundedCorner) {
    AGRoundedCornerNone         = 0,
    AGRoundedCornerTopRight     = 1 <<  0,
    AGRoundedCornerBottomRight  = 1 <<  1,
    AGRoundedCornerBottomLeft   = 1 <<  2,
    AGRoundedCornerTopLeft      = 1 <<  3,
};

typedef NS_OPTIONS(NSUInteger, AGDrawnBorderSides) {
    AGDrawnBorderSidesNone      = 0,
    AGDrawnBorderSidesRight     = 1 <<  0,
    AGDrawnBorderSidesLeft      = 1 <<  1,
    AGDrawnBorderSidesTop       = 1 <<  2,
    AGDrawnBorderSidesBottom    = 1 <<  3,
};

@interface AGBorderHelper : NSObject

/**
 *  set border for the View
 *
 *  @param view  the View need to be set border
 *  @param width border with
 *  @param color border color
 */
+ (void)borderWithView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color;

/**
 *  corner Radius for View
 *
 *  @param view  the View to be Radius
 *  @param raius radius size
 */
+ (void)cornerWithView:(UIView *)view cornerRadius:(CGFloat)radius;

/**
 *  set border and corner radius for view
 *
 *  @param view   the source view
 *  @param radius radius size
 *  @param width  border with size
 *  @param color  border color
 */
+ (void)cornerWithView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;

/**
 *  the mobile is validate or not
 *
 *  @param mobile  mobile num info
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  the email is validate or not
 *
 *  @param mobile  email info
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 * the password validate,the rule is 6~12位字母或数字
 */
+ (BOOL)isValidatePassword:(NSString *)pwd;

+ (NSString *)convertStr:(NSString *)timeStr startFormt:(NSString *)startFormate endFormate:(NSString *)endFormate;

+ (long long)userId;

@end
