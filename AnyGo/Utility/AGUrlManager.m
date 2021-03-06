//
//  AGUrlManager.m
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGUrlManager.h"

@implementation AGUrlManager

+ (NSURL *)urlLoginWithAccount:(NSString *)account password:(NSString *)pwd;{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/login.do?appId=%@&account=%@&password=%@",serverUrl,appId,account,pwd];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlIsRegisterAccount:(NSString *)account{
    NSString *accountStr = [account stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@/trainon/userstatus.do?appId=%@&account=%@",serverUrl,appId,accountStr];
    
    return [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSURL *)urlRegister{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/user.do?appId=%@",serverUrl,appId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlResetPwd;{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/password.do?_method=PUT&appId=%@",serverUrl,appId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlGetUserInfo:(NSString *)userId  ownId:(NSString *)ownId{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/user/%@.do?appId=%@&userId=%@",serverUrl,ownId,appId,userId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlSMSWithMobileNum:(NSString *)mobile withType:(NSInteger)type{
    NSString *account = [mobile stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@/trainon/sms.do?appId=%@&mobile=%@&type=%d",serverUrl,appId,account,type];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlCreatePlanWithUserId:(NSString *)userId{
    NSString *createPlan = [NSString stringWithFormat:@"%@/trainon/plan.do?appId=%@&userId=%@",serverUrl,appId,userId];
    
    return [NSURL URLWithString:createPlan];
}

+ (NSURL *)urlGetPlanWithId:(NSString *)planId withUserId:(NSString *)userId{
    NSString *getPlan = [NSString stringWithFormat:@"%@/trainon/plan/%@.do?appId=%@&userId=%@",serverUrl,planId,appId,userId];
    
    return [NSURL URLWithString:getPlan];
}

+ (NSURL *)urlEditPlanWithId:(NSString *)planId withUserId:(NSString *)userId{
    NSString *editPlan = [NSString stringWithFormat:@"%@/trainon/plan/%@.do?appId=%@&userId=%@&_method=PUT",serverUrl,planId,appId,userId];
    
    return [NSURL URLWithString:editPlan];
}

+ (NSURL *)urlDeletePlanWIthId:(NSString *)planId withUserId:(NSString *)userId{
    NSString *deletePlan = [NSString stringWithFormat:@"%@/trainon/plan/%@.do?appId=%@&userId=%@&_method=DELETE",serverUrl,planId,appId,userId];
    
    return [NSURL URLWithString:deletePlan];
}

+ (NSURL *)urlSearchPlanWithUserId:(NSString *)userId filterInfo:(AGFilterModel *)model{
    NSString *searchURL = [NSString stringWithFormat:@"%@/trainon/search/plan.do?appId=%@&userId=%@&keyword=%@",serverUrl,appId,userId,model.countryCity];
    
    searchURL = [searchURL stringByAppendingString:[NSString stringWithFormat:(model.addressType == AddressTypeStart) ? @"&type=1" : @"&type=0"]];
    
    
    return [NSURL URLWithString:[searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSURL *)urlChangeRelation:(NSString *)userId friendId:(NSString *)friendId relationType:(int)type{
    NSString *changeUrl = [NSString stringWithFormat:@"%@/trainon/friend.do?userId=%@&appId=%@&friendId=%@&type=%d&_method=POST",serverUrl,userId,appId,friendId,type];
    
    return [NSURL URLWithString:[changeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSURL *)urlGetFriendList:(NSString *)userId pageIndex:(int)pageIndex pageSize:(int)pageSize{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/friend.do?userId=%@&appId=%@&pageIndex=%d&pageSize=%d&type=2",serverUrl,userId,appId,pageIndex,pageSize];
    
    return [NSURL URLWithString:url];
}
@end

@implementation AGUrlManager (feedInfo)

+ (NSURL *)urlDistributeFeed:(NSString *)userId{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/feed.do?userId=%@&appId=%@",serverUrl, userId, appId];
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlDeleteFeed:(NSString *)userId feedId:(NSString *)feedId{
    NSString *urlDelete = [NSString stringWithFormat:@"%@/trainon/feed/%@.do?userId=%@&appId=%@&_method=DELETE",serverUrl,feedId,userId,appId];
    
    return [NSURL URLWithString:urlDelete];
}

+ (NSURL *)urlGetFeed:(NSString *)userId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/feed.do?appId=%@&userId=%@&pageSize=%d&lastId=%@",serverUrl,appId,userId,pageSize,lastId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlGetFeed:(NSString *)userId watchUserId:(NSString *)watchId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/feed/%@.do?appId=%@&userId=%@&pageSize=%d&lastId=%@",serverUrl,watchId,appId,userId,pageSize,lastId];
    
    return [NSURL URLWithString:url];
}

@end

@implementation AGUrlManager(UserInfoManager)

+ (NSURL *)urlSearchUserInfo:(NSString *)userId keyWord:(NSString *)key pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex{
    NSString *url = [NSString stringWithFormat:@"%@/trainon/search/friend.do?userId=%@&appId=%@&key=%@&pageIndex=%d&pageSize=%d",serverUrl,userId,appId,key,pageIndex,pageSize];
    
    return [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
