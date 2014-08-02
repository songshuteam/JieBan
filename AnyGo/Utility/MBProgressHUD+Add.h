//
//  MBProgressHUD+Add.h
//  AnyGo
//
//  Created by tony on 7/26/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
@end
