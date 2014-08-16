//
//  AGPlanDestinationTableViewCell.m
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPlanDestinationTableViewCell.h"

@implementation AGPlanDestinationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.planTextView.placeholder = @"点击添加更多描述";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
