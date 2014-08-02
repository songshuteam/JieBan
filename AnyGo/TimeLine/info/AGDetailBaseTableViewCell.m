//
//  AGDetailBaseTableViewCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGDetailBaseTableViewCell.h"

@implementation AGDetailBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 65, 65)];
        self.nikeName = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 30, 21)];
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



- (void)contentViewByUserInfo:(NSString *)userInfo{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.faceImgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"messageText"]];
    NSString *content = @"djahdakhdkajdkak阿卡打卡机打卡机SD卡就是打算开大口";
    self.nikeName.adjustsFontSizeToFitWidth = YES;
    if (CGRectGetWidth(self.nikeName.frame) > 160) {
        CGRect rect = self.nikeName.frame;
        rect.size.width = 160;
        self.nikeName.frame = rect;
    }
    self.nikeName.text = content;
    
    CGFloat originX = CGRectGetMaxX(self.nikeName.frame) + CGRectGetWidth(self.nikeName.frame) + 5;
    self.sexImg.frame = CGRectMake(originX, 30, 13, 13);
    [self.sexImg setImage:[UIImage imageNamed:YES ? @"commentImage" : @"commentPraise"]];
}

+ (CGFloat)heightForCell{
    return 91;
}
@end
