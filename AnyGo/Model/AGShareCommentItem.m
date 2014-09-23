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
        
        title = [NSString stringWithFormat:@"<a>%lld|%@</a>回复<a>%lld|%@</a>:",self.commentUserId,self.commentName,self.commentToUserId,self.commentToUserName];
    }else{
        title = [NSString stringWithFormat:@"<a>%lld|%@</a>",self.commentUserId,self.commentName];
    }
    
    title = [NSString stringWithFormat:@"%@ %@",title,self.commentContent];
    
    return title;
}

+ (AGShareCommentItem *)parseJsonInfo:(NSDictionary *)valueDic{
    AGShareCommentItem *item = [[AGShareCommentItem alloc] init];
    item.commentId = [[valueDic objectForKey:@"commentId"] longLongValue];
    item.commentUserId = [[valueDic objectForKey:@"userId"] longLongValue];
    item.commentName = [valueDic objectForKey:@"userName"];
    item.commentToUserId = [[valueDic objectForKey:@"reUserId"] longLongValue];
    item.commentToUserName = [valueDic objectForKey:@"reUserName"];
    item.commentContent = [valueDic objectForKey:@"content"];
    item.profileImg = [valueDic objectForKey:@"avatarUrl"];
    item.commentCreatTime = [valueDic objectForKey:@"insertTime"];
    
    return item;
}
@end
