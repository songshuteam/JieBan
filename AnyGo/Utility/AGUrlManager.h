//
//  AGUrlManager.h
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGFilterModel.h"

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

+ (NSURL *)urlIsRegisterAccount:(NSString *)account;

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

/**
 *  create plan to distribute for other
 *
 *  @param userId the creator id
 *
 *  @return create plan URL request by POST
 */
+ (NSURL *)urlCreatePlanWithUserId:(NSString *)userId;

/**
 *  get the distribute plan
 *
 *  @param planId the plan Id
 *  @param userId the want get plan user Id
 *
 *  @return get plan URL request by get
 */
+ (NSURL *)urlGetPlanWithId:(NSString *)planId withUserId:(NSString *)userId;

/**
 *  edit the created Plan
 *
 *  @param planId  the plan Id
 *  @param userId the want edit plan user Id
 *
 *  @return edit plan URL request by PUT(post)
 */
+ (NSURL *)urlEditPlanWithId:(NSString *)planId withUserId:(NSString *)userId;

/**
 *  delete the  distribute plan
 *
 *  @param planId  the plan Id
 *  @param userId the want to delete plan user Id
 *
 *  @return delete plan URL request by DELETE(post)
 */
+ (NSURL *)urlDeletePlanWIthId:(NSString *)planId withUserId:(NSString *)userId;

+ (NSURL *)urlSearchPlanWithUserId:(NSString *)userId filterInfo:(AGFilterModel *)model;
@end
