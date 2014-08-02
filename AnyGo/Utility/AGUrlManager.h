//
//  AGUrlManager.h
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGUrlManager : NSObject

/**
 *  get the login url
 *
 *  @param account account Info
 *  @param pwd     password
 *
 *  @return login Url
 */
+ (NSURL *)urlLoginWithAccount:(NSString *)account password:(NSString *)pwd;

/**
 *  get the register Url
 *
 *  @return register  url
 */
+ (NSURL *)urlRegister;

/**
 *  get reset password url
 *
 *  @return reset password url
 */
+ (NSURL *)urlResetPwd;

/**
 *  the sms
 *
 *  @param mobile mobile info
 *  @param type   the type to get sms, 1 is register 2 is find password
 *
 *  @return sms url
 */
+ (NSURL *)urlSMSWithMobileNum:(NSString *)mobile withType:(NSInteger)type;
@end
