//
//  AGPhotoAblumTableViewCell.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJieyouModel.h"

@interface AGPhotoAblumTableViewCell : UITableViewCell

+ (CGFloat)heightForCell;
- (void)contentViewInit:(AGUserInfoModel *)userInfo;

@end
