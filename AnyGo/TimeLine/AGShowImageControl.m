//
//  AGShowImageControl.m
//  图片浏览器示例
//
//  Created by tony on 14-7-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "AGShowImageControl.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define MAX_IMG_WIDTH       200.0
#define MAX_IMG_HEIGHT      120.0
#define NORMAL_IMG_SIZE     70
#define NORMAL_IMG_SPACE    5

@implementation AGShowImageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - frame ImageView size
- (void)setImageWithUrls:(NSArray *)imgUrls{
    _imageUrls = imgUrls;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self layOutImages];
}

- (void)layOutImages{
    int count = [_imageUrls count];
    
    if (count == 1) {
        [self drawSingleImag:[_imageUrls objectAtIndex:0]];
    }else if (count <= 3){
        [self drawLessThree];
    }else if (count == 4){
        [self drawFourImage];
    }else{
        [self drawMoreFour];
    }
}

- (void)drawSingleImag:(NSString *)imgUrl{
    if (imgUrl == nil && imgUrl.length <= 0)
        return;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NORMAL_IMG_SPACE, MAX_IMG_WIDTH, MAX_IMG_HEIGHT - 2*NORMAL_IMG_SPACE)];
    imageView.tag = 0;
    imageView.backgroundColor = [UIColor blueColor];
    [self addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
    
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)drawLessThree{
    int count = [_imageUrls count];
    
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((NORMAL_IMG_SPACE + NORMAL_IMG_SIZE)*i, NORMAL_IMG_SPACE, NORMAL_IMG_SIZE, NORMAL_IMG_SIZE)];
        imageView.tag = i;
        [self addSubview:imageView];
        [self drawImage:imageView imgUrl:[_imageUrls objectAtIndex:i]];
        
        if (i == (count - 1)) {
            [self loadImageViewFinish];
        }
    }
}

- (void)drawFourImage{
    int count = [_imageUrls count];
    
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((NORMAL_IMG_SPACE + NORMAL_IMG_SIZE)*(i%2), NORMAL_IMG_SIZE*(i/2) + NORMAL_IMG_SPACE*(i/2 + 1), NORMAL_IMG_SIZE, NORMAL_IMG_SIZE)];
        imageView.tag = i;
        [self addSubview:imageView];
        [self drawImage:imageView imgUrl:[_imageUrls objectAtIndex:i]];
        
        if (i == (count - 1)) {
            [self loadImageViewFinish];
        }
    }
}

-(void)drawMoreFour
{
    int count=[_imageUrls count];
    for(int i=0;i<count;i++)
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake((NORMAL_IMG_SIZE + NORMAL_IMG_SPACE)* (i%3),NORMAL_IMG_SIZE*(i/3) + NORMAL_IMG_SPACE*(i/3 + 1), NORMAL_IMG_SIZE, NORMAL_IMG_SIZE)];
        imageView.tag = i;
        [self addSubview:imageView];
        [self drawImage:imageView imgUrl:[_imageUrls objectAtIndex:i]];
        
        if(i == (count - 1))
            [self loadImageViewFinish];
    }
}

- (void)drawImage:(UIImageView *)imageView imgUrl:(NSString *)imageUrl{
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeImg"]];
    
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
    
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)imageTap:(UITapGestureRecognizer *)tap{
    int count = [_imageUrls count];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *url = [[_imageUrls objectAtIndex:i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag;
    browser.photos = photos;
    [browser show];
}

-(void)loadImageViewFinish
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(ShowImageControlFinished:)])
        [self.delegate ShowImageControlFinished:self];
}

#pragma mark - get View Height
+ (CGFloat)heightForImageViews:(NSArray *)images{
    int count = [images count];
    
    if (count == 1) {
        return MAX_IMG_HEIGHT;
    }else{
        return (count/4 + 1)*(NORMAL_IMG_SPACE + NORMAL_IMG_SIZE) + NORMAL_IMG_SPACE;
    }
    
    return 0;
}
@end
