//
//  AGUserInfoModifyViewController.h
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

#import "AGPersonInfoViewController.h"

@interface AGUserInfoModifyViewController : AGViewController

@property (assign, nonatomic) PersonInfoType type;
@property (assign, nonatomic) AGPersonInfoViewController *personInfoViewController;

@end
