//
//  AGJieyouModel.m
//  AnyGo
//
//  Created by tony on 7/22/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJieyouModel.h"

@implementation AGJieyouModel


@end


@implementation AGRegisterModel

- (NSString *)getAccountInfo{
    NSString *account = [NSString stringWithFormat:@"%@-%@",self.areaCode.phoneCode,self.account];
    NSString *info = [account stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    return info;
}

@end