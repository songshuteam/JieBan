//
//  AGFriendTableViewCell.h
//  AnyGo
//
//  Created by tony on 9/23/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJieyouModel.h"

@interface AGFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *faceImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

- (void)contentWithJieyou:(AGJieyouModel *)model;
@end
