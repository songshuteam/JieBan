//
//  AGPhotoAblumTableViewCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGPhotoAblumTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define PHOTOABLUMWIDTH     55
#define PHTOABLUMSPACE      5

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
    self.textLabel.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1];
    
    NSArray *imgArr = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg"];
    
    int sum = [imgArr count];
    if (sum > 0) {
        for (int i= 0; i<sum; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100 + i*(PHOTOABLUMWIDTH + PHTOABLUMSPACE), 18, PHOTOABLUMWIDTH, PHOTOABLUMWIDTH)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]]];
            [self addSubview:imageView];
        }
    }

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(285, 20, 45, 30)];
//    arrow.image = [UIImage imageNamed:@"icon_photolib"];
//    [self addSubview:arrow];
}

+ (CGFloat)heightForCell{
    return 90;
}
@end
