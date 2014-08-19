//
//  AGPlanModel.h
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGPlanModel : NSObject

@property (nonatomic, assign) long long planId;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *strDate;

- (NSDictionary *)getModelDictionry;
+ (AGPlanModel *)planInfoFromJsonValue:(NSDictionary *)valueDic;
@end



@interface AGAllPlanModel : NSObject

@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, strong) NSArray *plans;

- (NSString *)plansAddressInfo;

@end


@interface AGJiebanPlanModel : NSObject

@property (nonatomic, assign) long long jiebanId;
@property (nonatomic, assign) long long userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger femaleNum;
@property (nonatomic, assign) NSInteger maleNum;
@property (nonatomic, assign) BOOL isDriver;
@property (nonatomic, assign) BOOL isCanDiscuss;
@property (nonatomic, assign) BOOL isGoHome;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSArray *plansArr;

- (NSString *)plansLocationInfo;

//- (NSString *)getJiebanModelJson;

- (NSString *)jiebanInfoJson;

+ (AGJiebanPlanModel *)jiebanInfoFromJsonValue:(NSDictionary *)valueDic;

@end