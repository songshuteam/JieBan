//
//  AGDetailInfoViewController.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGDetailInfoViewController : UIViewController

@property (assign, nonatomic) long long userId;
@property (assign, nonatomic) long long friendId;
@property (assign, nonatomic) RelationType relation;
@end
