//
//  AGADView.m
//  AnyGo
//
//  Created by WingleWong on 14-2-12.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGADView.h"
#import "NSObject+NSJSONSerialization.h"
#import "ASIHTTPRequest.h"

@implementation AGADView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        adScrollView = [[WWADScrollView alloc] initWithFrame:CGRectOffset(frame, 0, 0)];
        adScrollView.backgroundColor = [UIColor clearColor];
        adScrollView.delegate = self;
        adScrollView.datasource = self;
        [self addSubview:adScrollView];
        
        [self startRequestData];
    }
    return self;
}

#pragma mark - API

-(void)startRequestData {
    
}

#pragma mark - WWADScrollViewDatasource methods

-(NSInteger)numberOfPages
{
    if (adPages == nil) {
        return 10;
    }
    return [adPages count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    return nil;
}

#pragma mark - XLCycleScrollViewDelegate methods

- (void)didClickPage:(WWADScrollView *)csView atIndex:(NSInteger)index {
    
}

@end
