//
//  AGShareCommentItem.m
//  HBWeiboDemo
//
//  Created by tony on 7/9/14.
//  Copyright (c) 2014 hb. All rights reserved.
//

#import "AGShareCommentItem.h"

@implementation AGShareCommentItem

#pragma mark -
- (NSString *)getShowMessage{
    NSString *title = nil;
    if (self.commentToUserName) {
        
        title = [NSString stringWithFormat:@"<a>%@|%@</a>回复<a>%@|%@</a>:",self.commentUserId,self.commentName,self.commentToUserId,self.commentToUserName];
    }else{
        title = [NSString stringWithFormat:@"<a>%@|%@</a>",self.commentUserId,self.commentName];
    }
    
    title = [NSString stringWithFormat:@"%@ %@",title,self.commentContent];
    
    return title;
}

@end
