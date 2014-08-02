//
//  AGShareItem.h
//  timeLine
//
//  Created by tony on 14-7-9.
//  Copyright (c) 2014年 zjx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGShareItem : NSObject

@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *profileImgUrl;

@property (assign, nonatomic) long long shareMsgId;
@property (strong, nonatomic) NSString *shareContent;

@property (strong, nonatomic) NSArray *sharePhotos;
@property (strong, nonatomic) NSArray *shareComments;
@property (strong, nonatomic) NSArray *shareLikes;

@property (strong, nonatomic) NSData *timeStamp;

@end


