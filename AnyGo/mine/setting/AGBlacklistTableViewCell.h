//
//  AGBlacklistTableViewCell.h
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJieyouModel.h"

@interface AGBlacklistTableViewCell : UITableViewCell
@property (strong, nonatomic) AGJieyouModel *jieyouModel;

@property (weak, nonatomic) IBOutlet UIImageView *faceImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *signature;

- (void)contentInitWithJieyou:(AGJieyouModel *)model;

//- (void) setChecked:(BOOL)checked;
@end
