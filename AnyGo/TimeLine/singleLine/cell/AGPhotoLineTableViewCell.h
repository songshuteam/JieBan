//
//  AGPhotoLineTableViewCell.h
//  AnyGo
//
//  Created by tony on 8/3/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGShareItem.h"

@interface AGPhotoLineTableViewCell : UITableViewCell

@property (strong, nonatomic) AGShareItem *shareItem;

- (void)contentInfoWithModel:(AGShareItem *)item;

+ (CGFloat)heightForCell:(AGShareItem *)item;

@end
