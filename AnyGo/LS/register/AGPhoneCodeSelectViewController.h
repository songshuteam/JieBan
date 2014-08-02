//
//  AGPhoneCodeSelectViewController.h
//  AnyGo
//
//  Created by tony on 7/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

@class AGLSAreaCodeModel;

@protocol AGPhoneCodeSelectDelegate <NSObject>

- (void)selectWithAreaCode:(AGLSAreaCodeModel *)model;

@end

@interface AGPhoneCodeSelectViewController : AGViewController

@property (weak, nonatomic) id<AGPhoneCodeSelectDelegate> delegate;

@end
