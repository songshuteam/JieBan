//
//  AGRequestManager.m
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGRequestManager.h"

#import "AGUrlManager.h"

@implementation AGRequestManager

#pragma mark - login and register request
+ (ASIHTTPRequest *)requestlogintWithAccount:(NSString *)account password:(NSString *)pwd{
    NSURL *url = [AGUrlManager urlLoginWithAccount:account password:pwd];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}


+ (ASIFormDataRequest *)requestWithRegisterInfo:(AGRegisterModel *)registerInfo{
    NSURL *url = [AGUrlManager urlRegister];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:[registerInfo getAccountInfo] forKey:@"account"];
    [request setPostValue:registerInfo.password forKey:@"password"];
    [request setPostValue:registerInfo.nickname forKey:@"nickname"];
    [request setPostValue:[NSNumber numberWithInteger:registerInfo.gender] forKey:@"gender"];
    [request setPostValue:registerInfo.code forKey:@"code"];
    
    // 获取Caches目录路径
    NSString *cachesPath = NSTemporaryDirectory(); //[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagName = [NSString stringWithFormat:@"%f.png",[[NSDate new] timeIntervalSince1970]];
    NSString *path = [cachesPath stringByAppendingPathComponent:imagName];
    [UIImagePNGRepresentation(registerInfo.faceImg) writeToFile:path atomically:YES];
    
    [request setFile:path forKey:@"image"];
    
    return request;
}


+ (ASIFormDataRequest *)requestResetWithAccount:(NSString *)account code:(NSString *)code password:(NSString *)pwd{
    NSURL *url = [AGUrlManager urlResetPwd];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:account forKey:@"account"];
    [request setPostValue:code forKey:@"code"];
    [request setPostValue:pwd forKey:@"newPassword"];
    
    return request;
}
@end

@implementation AGRequestManager (Disteribute)

#pragma mark - distribute plan request
+ (ASIFormDataRequest *)requestCreatePlanWithUserId:(NSString *)userId planModel:(AGJiebanPlanModel *)planModel{
    NSURL *url = [AGUrlManager urlCreatePlanWithUserId:userId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:planModel.jiebanInfoJson forKey:@"plan"];
    
    return request;
}

+ (ASIHTTPRequest *)requestGetPlanWithUserId:(NSString *)userId planId:(NSString *)planId{
    NSURL *url = [AGUrlManager urlGetPlanWithId:planId withUserId:userId];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

+ (ASIFormDataRequest *)requestEditPlanWithUserId:(NSString *)userId PlanModel:(AGJiebanPlanModel *)planModel{
    NSURL *url = [AGUrlManager urlEditPlanWithId:[NSString stringWithFormat:@"%lld",planModel.jiebanId] withUserId:userId];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setValue:planModel.jiebanInfoJson forKey:@"plan"];
    
    return request;
}

+ (ASIHTTPRequest *)requestDeletePlanWithUserId:(NSString *)userId planId:(NSString *)planId{
    NSURL *url = [AGUrlManager urlDeletePlanWIthId:planId withUserId:userId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}

@end
