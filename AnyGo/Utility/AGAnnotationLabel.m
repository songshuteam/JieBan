//
//  AGAnnotationLabel.m
//  AnyGo
//
//  Created by tony on 8/10/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGAnnotationLabel.h"

#define Arror_height  5

@implementation AGAnnotationLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets{
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    
    return self;
}

-(id) initWithInsets: (UIEdgeInsets) insets{
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    [super drawRect:rect];
    
}

-(void)drawInContext:(CGContextRef)context
{
	
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:174.0f/255.0 green:174.0f/255.0 blue:174.0f/255.0 alpha:1].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    [self getDrawPath:context];
//    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 4.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

@end
