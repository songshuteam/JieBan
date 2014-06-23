//
//  AGJiebanAnnotationView.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJiebanAnnotationView.h"

#define     ImageWidth      42.0
#define     ImageHeight     29.0
#define     ImageCenterOffset   -12.0

@interface AGJiebanAnnotationView ()

@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *endAddress;

@end

@implementation AGJiebanAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(ImageWidth, ImageHeight);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, ImageCenterOffset);
        
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    self.startAddress = ((AGPointAnnotation *) annotation).startAddress;
    self.endAddress = ((AGPointAnnotation *) annotation).endAddress;
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    AGPointAnnotation *jiebanItem = (AGPointAnnotation *)self.annotation;
    if (jiebanItem != nil)
    {
        [[UIImage imageNamed:@"jiebanBg"] drawInRect:CGRectMake(0.0, 0.0, ImageWidth, ImageHeight)];
        
        [[UIColor whiteColor] setFill];
        [self.startAddress drawInRect:CGRectMake(12.5, 2.5, 22.0, 20.0)
                              withFont:[UIFont boldSystemFontOfSize:12.0]
                         lineBreakMode:NSLineBreakByTruncatingTail
                             alignment:NSTextAlignmentLeft];
    
        [self.endAddress drawInRect:CGRectMake(10.5, -0.5, 22.0, 20.0)
                                  withFont:[UIFont boldSystemFontOfSize:12.0]
                             lineBreakMode:NSLineBreakByTruncatingTail
                                 alignment:NSTextAlignmentLeft];
    }
}

@end
