//
//  AGFriendTableViewCell.m
//  AnyGo
//
//  Created by tony on 9/23/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGFriendTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation AGFriendTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)contentWithJieyou:(AGJieyouModel *)model{
    [self.faceImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
    self.nickName.text = model.nickname;
}

@end
