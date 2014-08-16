//
//  AGFilterJiebanViewController.h
//  AnyGo
//
//  Created by tony on 8/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

@protocol FilterJiebanDelegate;

@interface AGFilterJiebanViewController : AGViewController

@property (nonatomic, assign) id<FilterJiebanDelegate> delegate;

@property (strong, nonatomic) AGFilterModel *filterModel;

@end

@protocol FilterJiebanDelegate <NSObject>

- (void)filterViewController:(AGFilterJiebanViewController *)viewController filterCondition:(AGFilterModel *)model;

@end