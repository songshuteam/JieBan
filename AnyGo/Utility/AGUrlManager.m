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
    NSString *url = [NSString stringWithFormat:@"%@/trainon/userstatus.doappId=%@&account=%@",serverUrl,appId,accountStr];
    
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
    NSString *searchURL = [NSString stringWithFormat:@"%@/trainon/search/plan.do?appId=%@&userId=%@&keyword=北京",serverUrl,appId,userId];
    
    searchURL = [searchURL stringByAppendingString:[NSString stringWithFormat:(model.addressType == AddressTypeStart) ? @"&type=1" : @"&type=0"]];
    
    
    return [NSURL URLWithString:[searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
@end
