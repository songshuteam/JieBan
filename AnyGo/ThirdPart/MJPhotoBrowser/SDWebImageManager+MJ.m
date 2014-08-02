//
//  SDWebImageManager+MJ.m
//  AnyGo
//
//  Created by tony on 7/26/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "SDWebImageManager+MJ.h"

@implementation SDWebImageManager (MJ)

+ (void)downloadWithURL:(NSURL *)url
{
    // cmp不能为空
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
    }];
//    [[self sharedManager] downloadWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        
//    }];
}

@end
