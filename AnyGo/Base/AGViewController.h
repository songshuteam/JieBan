//
//  AGViewController.h
//  AnyGo
//
//  Created by WingleWong on 14-2-11.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MobClick.h"
#import "NSObject+NSJSONSerialization.h"

#import <ASIHTTPRequest/ASIFormDataRequest.h>

#import "Toast+UIView.h"
#import "AGUrlManager.h"

@interface AGViewController : UIViewController

@property (nonatomic, strong) UIColor *bgViewColor;

- (void)backBarButtonWithTitle:(NSString *)title;

@end
