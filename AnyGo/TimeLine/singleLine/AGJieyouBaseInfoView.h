//
//  AGJieyouBaseInfoView.h
//  AnyGo
//
//  Created by tony on 8/4/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGJieyouModel.h"

@interface AGJieyouBaseInfoView : UIView

@property (strong, nonatomic) AGJieyouModel *userInfo;

- (void)contentInitWithJieyou:(AGJieyouModel *)jieyouModel;

@end
