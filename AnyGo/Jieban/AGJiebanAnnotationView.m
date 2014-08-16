//
//  AGJiebanAnnotationView.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJiebanAnnotationView.h"

#import "AGAnnotationLabel.h"

const CGFloat annotationHeight = 34;
const CGFloat annotationWidth = 70;
const CGFloat imageWidth = 11;
const CGFloat messageHeight = 18;

@interface AGJiebanAnnotationView ()

@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *endAddress;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation AGJiebanAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(annotationWidth, annotationHeight);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self addSubview:self.bgImageView];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, annotationWidth, messageHeight)];
        self.descriptionLabel.font = [UIFont systemFontOfSize:10];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    AGPointAnnotation *pointAnnotation = (AGPointAnnotation *)annotation;
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    if (!annotation) {
        return;
    }
    
    self.bgImageView.image = [UIImage imageNamed:pointAnnotation.gender == GenderFemale ? @"annotation_female" : @"annotaion_male"];
    NSString *text = [NSString stringWithFormat:@"目的地:%@",pointAnnotation.description];
    NSRange range = [text rangeOfString:pointAnnotation.description];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:range];
    self.descriptionLabel.attributedText = attributeStr;
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
//    AGPointAnnotation *jiebanItem = (AGPointAnnotation *)self.annotation;
//    if (jiebanItem != nil)
//    {
//        [[UIImage imageNamed:@"btn_bg_blue"] drawInRect:CGRectMake(28.0f, messageHeight, imageWidth, imageWidth)];
//        
//        [[UIColor whiteColor] setFill];
//        [self.startAddress drawInRect:CGRectMake(12.5, 2.5, 22.0, 20.0)
//                              withFont:[UIFont boldSystemFontOfSize:12.0]
//                         lineBreakMode:NSLineBreakByTruncatingTail
//                             alignment:NSTextAlignmentLeft];
//
//        [self.endAddress drawInRect:CGRectMake(10.5, -0.5, 22.0, 20.0)
//                                  withFont:[UIFont boldSystemFontOfSize:12.0]
//                             lineBreakMode:NSLineBreakByTruncatingTail
//                                 alignment:NSTextAlignmentLeft];
//    }
}

@end
