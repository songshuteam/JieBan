//
//  AGSharePraiseItem.m
//  AnyGo
//
//  Created by tony on 9/18/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGSharePraiseItem.h"

@implementation AGSharePraiseItem

+ (AGSharePraiseItem *)parseJsonInfo:(NSDictionary *)valueDic{
    AGSharePraiseItem *item = [[AGSharePraiseItem alloc] init];
    item.userId = [[valueDic objectForKey:@"userId"] longLongValue];
    item.userName = [valueDic objectForKey:@"userName"];
    item.profileUrl = [valueDic objectForKey:@"avatar"];
    
    return item;
}

@end
