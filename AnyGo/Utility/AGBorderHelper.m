//
//  AGBorderHelper.m
//  AnyGo
//
//  Created by tony on 14-7-1.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGBorderHelper.h"

@implementation AGBorderHelper


+ (void)borderWithView:(UIView *)view borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    [[self class] cornerWithView:view cornerRadius:.0f borderWidth:width borderColor:color];
}

+ (void)cornerWithView:(UIView *)view cornerRadius:(CGFloat)radius{
    [[self class] cornerWithView:view cornerRadius:radius borderWidth:.0f borderColor:[UIColor clearColor]];
}

+ (void)cornerWithView:(UIView *)view cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+ (void)shadowWithView:(UIView *)view shadowColor:(UIColor *)color shadowOpacity:(CGFloat)opacity shadowRadius:(CGFloat)radius offSet:(CGSize)size{
    
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOpacity = opacity;
    view.layer.shadowRadius = radius;
    view.layer.shadowOffset = size;
}

#pragma mark -
/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
