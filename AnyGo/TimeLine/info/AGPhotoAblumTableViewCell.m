//
//  AGPhotoAblumTableViewCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGPhotoAblumTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define PHOTOABLUMWIDTH     60
#define PHTOABLUMSPACE      8

@implementation AGPhotoAblumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)contentViewInit:(NSString *)userInfo{
    self.textLabel.text = @"个人相册";
    NSArray *imgArr = @[@"",@"",@""];
    
    int sum = [imgArr count];
    if (sum > 0) {
        for (int i= 0; i<sum; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90 + i*(PHOTOABLUMWIDTH + PHTOABLUMSPACE), 20, PHOTOABLUMWIDTH, PHOTOABLUMWIDTH)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]]];
            [self addSubview:imageView];
        }
    }
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(285, 20, 30, 30)];
    arrow.image = [UIImage imageNamed:@"commentImage"];
    [self addSubview:arrow];
}

+ (CGFloat)heightForCell{
    return 90;
}
@end
