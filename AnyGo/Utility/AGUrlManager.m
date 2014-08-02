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
    NSString *url = [NSString stringWithFormat:@"%@:travel/login.do?appId=%@&account=%@&password=%@",serverUrl,appId,account,pwd];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlRegister{
    NSString *url = [NSString stringWithFormat:@"%@:travel/user.do?appId=%@",serverUrl,appId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlResetPwd;{
    NSString *url = [NSString stringWithFormat:@"%@:travel/password.do?_method=PUT&appId=%@",serverUrl,appId];
    
    return [NSURL URLWithString:url];
}

+ (NSURL *)urlSMSWithMobileNum:(NSString *)mobile withType:(NSInteger)type{
    NSString *url = [NSString stringWithFormat:@"%@/sms.do?appId=%@&mobile=%@@&type=%d",serverUrl,appId,mobile,type];
    
    return [NSURL URLWithString:url];
}

@end
