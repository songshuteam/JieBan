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

+ (ASIHTTPRequest *)requestlogintWithAccount:(NSString *)account password:(NSString *)pwd{
    NSURL *url = [AGUrlManager urlLoginWithAccount:account password:pwd];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    return request;
}


+ (ASIFormDataRequest *)requestWithRegisterInfo:(AGRegisterModel *)registerInfo{
    NSURL *url = [AGUrlManager urlRegister];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:registerInfo.account forKey:@"account"];
    [request setPostValue:registerInfo.password forKey:@"password"];
    [request setPostValue:[NSNumber numberWithInteger:registerInfo.gender] forKey:@"gender"];
    [request setPostValue:registerInfo.code forKey:@"code"];
    
    
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
