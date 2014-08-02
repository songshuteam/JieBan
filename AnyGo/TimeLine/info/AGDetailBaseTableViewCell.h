//
//  AGDetailBaseTableViewCell.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/UIImageView+WebCache.h>

@interface AGDetailBaseTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *faceImgView;
@property (strong, nonatomic) UILabel *nikeName;
@property (strong, nonatomic) UIImageView *sexImg;

- (void)contentViewByUserInfo:(NSString *)userInfo;

+ (CGFloat)heightForCell;
@end
