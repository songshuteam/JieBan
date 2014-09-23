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

+ (NSURL *)urlGetUserInfo:(NSString *)userId  ownId:(NSString *)ownId;

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

/**
 *  用户好友关系改变
 *
 *  @param userId   请求者的id
 *  @param friendId 被请求者的id
 *  @param type     关系变更类型          NONE(1, "没有任何关系", "none", 1),
                                        FOLLOWING(2, "关注", "follow", 2),
                                        BE_FOLLOW(3, "被关注", "be_follow", 3),
                                        BOTH_WAY_FOLLOW(4, "互相关注", "bothway_follow", 4),
                                        BLOCK(5, "拉黑", "block", 5),
                                        BE_BLOCK(6, "被来黑", "be_block", 6);
 *
 *  @return 关系变更url
 */
+ (NSURL *)urlChangeRelation:(NSString *)userId friendId:(NSString *)friendId relationType:(int)type;

+ (NSURL *)urlGetFriendList:(NSString *)userId pageIndex:(int)pageIndex pageSize:(int)pageSize;
@end

@interface AGUrlManager (feedInfo)

+ (NSURL *)urlDistributeFeed:(NSString *)userId;

+ (NSURL *)urlDeleteFeed:(NSString *)userId feedId:(NSString *)feedId;

+ (NSURL *)urlGetFeed:(NSString *)userId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId;

+ (NSURL *)urlGetFeed:(NSString *)userId watchUserId:(NSString *)watchId pageSize:(NSInteger)pageSize lastId:(NSString *)lastId;
@end

@interface AGUrlManager(UserInfoManager)
+ (NSURL *)urlSearchUserInfo:(NSString *)userId keyWord:(NSString *)key pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;
@end
