//
//  AGShareItem.m
//  timeLine
//
//  Created by tony on 14-7-9.
//  Copyright (c) 2014年 zjx. All rights reserved.
//

#import "AGShareItem.h"

#import "AGShareCommentItem.h"
#import "AGSharePraiseItem.h"

@implementation AGShareItem

+ (AGShareItem *)parseJsonInfo:(NSDictionary *)valueDic{
    AGShareItem *item = [[AGShareItem alloc] init];
    
    item.shareMsgId = [[valueDic objectForKey:@"feedId"] longLongValue];
    item.userId = [[valueDic objectForKey:@"userId"] longLongValue];
    item.userName = [valueDic objectForKey:@"userName"];
    item.profileImgUrl = [valueDic objectForKey:@"avatarUrl"];
    item.shareContent = [valueDic objectForKey:@"content"];
    
    NSArray *imageArr = [valueDic objectForKey:@"images"];
    if (imageArr != nil && [imageArr count] > 0) {
        NSMutableArray *imgUrlArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in imageArr) {
            NSString *turl = [dic objectForKey:@"tUrl"];
            NSString *url = [dic objectForKey:@"url"];
            [imgUrlArr addObject:@{ThumbnailImg: turl, OriginalImg : url}];
        }
        item.sharePhotoUrls = imgUrlArr;
    }
    
    NSArray *likeArr = [valueDic objectForKey:@"likeList"];
    if (likeArr != nil  && [likeArr count] > 0) {
        NSMutableArray *praiseArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in likeArr) {
            AGSharePraiseItem *item = [AGSharePraiseItem parseJsonInfo:dic];
            [praiseArr addObject:item];
        }
        item.shareLikes = praiseArr;
    }
    
    NSArray *commentArr = [valueDic objectForKey:@"commentList"];
    if (commentArr != nil && [commentArr count] > 0) {
        NSMutableArray *commentList = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in commentArr) {
            AGShareCommentItem *item = [AGShareCommentItem parseJsonInfo:dic];
            [commentList addObject:item];
        }
        item.shareComments = commentList;
    }
    
    item.timeStamp = [NSDate dateWithTimeIntervalSince1970:[[valueDic objectForKey:@"insertTime"] floatValue]];
    return item;
}
@end
