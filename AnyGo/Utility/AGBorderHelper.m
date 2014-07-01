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

@end
