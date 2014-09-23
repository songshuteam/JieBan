//
//  AGShareCommentItem.h
//  HBWeiboDemo
//
//  Created by tony on 7/9/14.
//  Copyright (c) 2014 hb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGShareCommentItem : NSObject

@property (assign, nonatomic) long long commentId;
@property (assign, nonatomic) long long commentUserId;
@property (assign, nonatomic) long long commentToUserId;
@property (strong, nonatomic) NSString *profileImg;
@property (strong, nonatomic) NSString *commentName;
@property (strong, nonatomic) NSString *commentToUserName;
@property (strong, nonatomic) NSString *commentContent;
@property (strong, nonatomic) NSString *commentCreatTime;

- (NSString *)getShowMessage;

+ (AGShareCommentItem *)parseJsonInfo:(NSDictionary *)valueDic;
@end