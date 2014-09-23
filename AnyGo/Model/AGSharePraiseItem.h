//
//  AGSharePraiseItem.h
//  AnyGo
//
//  Created by tony on 9/18/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGSharePraiseItem : NSObject

@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *profileUrl;

+ (AGSharePraiseItem *)parseJsonInfo:(NSDictionary *)valueDic;
@end
