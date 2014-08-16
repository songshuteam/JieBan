//
//  AGRequestManager.h
//  AnyGo
//
//  Created by tony on 7/29/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ASIFormDataRequest.h>

#import "AGJieyouModel.h"
#import "AGPlanModel.h"

@interface AGRequestManager : NSObject
/**
 *  login request deal
 *
 *  @param account user mobile num
 *  @param pwd  user password
 *
 *  @return login ASIHTTPRequest
 */
+ (ASIHTTPRequest *)requestlogintWithAccount:(NSString *)account password:(NSString *)pwd;

/**
 *  get resgister Request
 *
 *  @param registerInfo resgitser Info
 *
 *  @return register ASIHTTPRequest
 */
+ (ASIFormDataRequest *)requestWithRegisterInfo:(AGRegisterModel *)registerInfo;

/**
 *  get reset password Request
 *
 *  @param account user mobile num info
 *  @param code    code verify
 *  @param pwd     password
 *
 *  @return reset password ASIHTTPRequest
 */
+ (ASIFormDataRequest *)requestResetWithAccount:(NSString *)account code:(NSString *)code password:(NSString *)pwd;
@end

@interface AGRequestManager(Disteribute)

+ (ASIFormDataRequest *)requestCreatePlanWithUserId:(NSString *)userId planModel:(AGJiebanPlanModel *)planModel;

+ (ASIHTTPRequest *)requestGetPlanWithUserId:(NSString *)userId planId:(NSString *)planId;

+ (ASIFormDataRequest *)requestEditPlanWithUserId:(NSString *)userId PlanModel:(AGJiebanPlanModel *)planModel;

+ (ASIHTTPRequest *)requestDeletePlanWithUserId:(NSString *)userId planId:(NSString *)planId;
@end
