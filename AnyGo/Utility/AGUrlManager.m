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

@end
