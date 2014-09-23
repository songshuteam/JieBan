//
//  AGSinglePhotoViewController.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGUserInfoModel;

@interface AGSinglePhotoViewController : UIViewController

@property (assign, nonatomic) long long watchId;
@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) AGUserInfoModel *userInfo;

@end
