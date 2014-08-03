//
//  AGCompanyDemandCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGCompanyDemandCell.h"

@implementation AGCompanyDemandCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)contentInfoWithModel:(AGCompanyNeedModel *)model{
    
}

+ (CGFloat)heightForCell:(AGCompanyNeedModel *)model{

    return 0;
}

@end
