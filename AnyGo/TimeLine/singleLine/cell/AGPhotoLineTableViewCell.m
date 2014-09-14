//
//  AGPhotoLineTableViewCell.m
//  AnyGo
//
//  Created by tony on 8/3/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPhotoLineTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

const int imageTag = 2014091401;
const int contentInfoOrigX = 84;
const int singleImgWidth = 75;
const int doubleImgWidth = 36;
const int doubleImgSpace = 3;

@interface AGPhotoLineTableViewCell ()

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *imagesView;

@end

@implementation AGPhotoLineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 11, contentInfoOrigX, 22)];
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentInfoOrigX, 11, 210, 100)];
        self.imagesView = [[UIView alloc] initWithFrame:CGRectMake(contentInfoOrigX, 111, 210, singleImgWidth)];
        self.imagesView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.timeLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.imagesView];
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

- (void)contentInfoWithModel:(AGShareItem *)item{
    CGFloat height = 11.0f;
    self.shareItem = item;

    self.timeLabel.font = [UIFont boldSystemFontOfSize:15];
    self.timeLabel.textColor = [UIColor colorWithRed:15.0/255.0 green:15.0/255.0 blue:15.0/255.0 alpha:1];
    self.timeLabel.attributedText = [self timeAttributeFromDate:item.timeStamp];
    
    self.contentLabel.numberOfLines = 0;
    CGSize size = [item.shareContent sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(210, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect rect = self.contentLabel.frame;
    rect.size.height = size.height;
    self.contentLabel.frame = rect;
    self.contentLabel.text = item.shareContent;
    height += size.height;
   
    for (UIView *view in [self.imagesView subviews]) {
        [view removeFromSuperview];
    }
    
    [self addImageViewWithArr:item.sharePhotos originY:height];
}

- (NSAttributedString *)timeAttributeFromDate:(NSDate *)date{
    NSCalendar *defaultCalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [defaultCalender components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger days = [components day];
    NSInteger month = [components month];
    
    
    NSString *dayStr = [NSString stringWithFormat:(days<10? @"0%d" : @"%d"),days];
    
    NSArray *monthArr = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    NSString *monthStr = [monthArr objectAtIndex:month-1];
    
    NSString *content = [NSString stringWithFormat:@"%@%@",dayStr,monthStr];
    NSRange range = [content rangeOfString:dayStr];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28]} range:range];
    
    return attStr;
}


- (void)addImageViewWithArr:(NSArray *)imgArr originY:(CGFloat)height{
    int sum = [imgArr count];
    if (sum == 1) {
        self.imagesView.frame = CGRectMake(0, height, 320, singleImgWidth);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX, 0, singleImgWidth, singleImgWidth)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imgArr lastObject]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        
        [self.imagesView addSubview:imageView];
    }else if (sum == 2){
        self.imagesView.frame = CGRectMake(0, height, 320, singleImgWidth);
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX, 0, doubleImgWidth, singleImgWidth)];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[imgArr firstObject]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        
        [self.imagesView addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX + doubleImgSpace + doubleImgWidth, 0, doubleImgWidth, singleImgWidth)];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[imgArr lastObject]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        [self.imagesView addSubview:imageView2];
        
    }else if (sum == 3){
        self.imagesView.frame = CGRectMake(0, height, 320, singleImgWidth);
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX, 0, doubleImgWidth, singleImgWidth)];
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:[imgArr firstObject]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        
        [self.imagesView addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX + doubleImgWidth + doubleImgSpace, 0, doubleImgWidth, doubleImgWidth)];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        [self.imagesView addSubview:imageView2];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX + doubleImgWidth + doubleImgSpace, doubleImgWidth + doubleImgSpace, doubleImgWidth, doubleImgWidth)];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:[imgArr lastObject]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
        [self.imagesView addSubview:imageView3];
        
    }else if (sum >= 4){
        self.imagesView.frame = CGRectMake(0, height, 320, singleImgWidth);
        for (int i=0; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentInfoOrigX + (doubleImgWidth + doubleImgSpace)*(i%2),(doubleImgWidth + doubleImgSpace)*(i/2), doubleImgWidth, doubleImgWidth)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imgArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
            [self.imagesView addSubview:imageView];
        }
    }
}

+ (CGFloat)heightForCell:(AGShareItem *)item{
    CGFloat height = 11.0f;
    
    CGSize size = [item.shareContent sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(210, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    height += size.height;
    
    if ([item.sharePhotos count] > 0) {
        height += 75;
    }
    
    height += 18;
    
    return height;
}

@end
