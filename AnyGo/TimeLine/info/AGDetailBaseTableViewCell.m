//
//  AGDetailBaseTableViewCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGDetailBaseTableViewCell.h"

const int nikeNameMaxWidth = 160;

@implementation AGDetailBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 62, 62)];
        self.nikeName = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 30, 24)];
        self.sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(120, 20, 13, 13)];
        
        [self addSubview:self.faceImgView];
        [self addSubview:self.nikeName];
        [self addSubview:self.sexImg];
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



- (void)contentViewByUserInfo:(AGJieyouModel *)userInfo{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.faceImgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
    NSString *content = @"djahdakhdkajdkak阿卡打卡机打卡机SD卡就是打算开大口";
    
    CGSize size = [content sizeWithFont:self.nikeName.font constrainedToSize:CGSizeMake(400, 21) lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect rect = self.nikeName.frame;
    if (size.width > nikeNameMaxWidth) {
        rect.size.width = nikeNameMaxWidth;
    }else{
        rect.size.width = size.width;
    }
    self.nikeName.frame = rect;
    
    self.nikeName.text = content;
    
    CGFloat originX = CGRectGetMinX(self.nikeName.frame) + CGRectGetWidth(self.nikeName.frame) + 5;
    self.sexImg.frame = CGRectMake(originX, 35, 13, 13);
    [self.sexImg setImage:[UIImage imageNamed:YES ? @"female_select" : @"male_select"]];
}

+ (CGFloat)heightForCell{
    return 91;
}
@end
