//
//  AGPlanModel.m
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPlanModel.h"
#import "AGBorderHelper.h"
#import "NSObject+NSJSONSerialization.h"

@implementation AGPlanModel

- (NSDictionary *)getModelDictionry{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (self.planId != 0) {
        [dic setObject:[NSNumber numberWithLongLong:self.planId] forKey:@"pId"];
    }
    if (self.days != 0) {
        [dic setObject:[NSNumber numberWithInteger:self.days] forKey:@"days"];
    }
    
    if (self.startTime && ![self.startTime isEqualToString:@""]) {
        [dic setObject:self.startTime forKey:@"startTime"];
    }
    
    if (self.endTime && ![self.endTime isEqualToString:@""]) {
        [dic setObject:self.endTime forKey:@"endTime"];
    }
    if (self.location && ![self.location isEqualToString:@""]) {
        [dic setObject:self.location forKey:@"location"];
    }
    if (self.description && ![self.description isEqualToString:@""]) {
        [dic setObject:self.desc forKey:@"desc"];
    }
//    [dic setObject:[NSNumber numberWithInt:self.type] forKey:@""];
//    [dic setObject:self.strDate forKey:@""];
//    [dic setObject:self.location forKey:@""];
//    [dic setObject:self.description forKey:@""];
    
    return dic;
}

+ (AGPlanModel *)planInfoFromJsonValue:(NSDictionary *)valueDic{
    AGPlanModel *model = [[AGPlanModel alloc] init];
    model.planId = [[valueDic objectForKey:@"pId"] longLongValue];
    model.days = [[valueDic objectForKey:@"days"] intValue];
    model.startTime = [valueDic objectForKey:@"startTime"];
    model.endTime = [valueDic objectForKey:@"endTime"];
    model.location = [valueDic objectForKey:@"location"];
    model.desc = [valueDic objectForKey:@"desc"];
    
    return model;
}
@end


@implementation AGAllPlanModel

- (NSString *)plansAddressInfo{
    NSString *retStr = nil;
    
    if (self.plans) {
        int count = [self.plans count];
        retStr = @"";
        for (int i= 0; i< count; i++) {
            AGPlanModel *model = [self.plans objectAtIndex:i];
            retStr = [retStr stringByAppendingString:model.location];
            if (i != count - 1) {
                retStr = [retStr stringByAppendingString:@", "];
            }
        }
    }
    
    return retStr;
}

@end

@implementation AGJiebanPlanModel

- (id)init{
    if (self = [super init]) {
        _femaleNum = 0;
        _maleNum = 0;
        _isDriver = NO;
        _isCanDiscuss = YES;
        _isGoHome = NO;
    }
    
    return self;
}

- (NSString *)plansLocationInfo{
    NSString *retStr = nil;
    
    if (self.plansArr) {
        int count = [self.plansArr count];
        retStr = @"";
        for (int i= 0; i< count; i++) {
            AGPlanModel *model = [self.plansArr objectAtIndex:i];
            retStr = [retStr stringByAppendingString:model.location];
            if (i != count - 1) {
                retStr = [retStr stringByAppendingString:@"-"];
            }
        }
    }
    
    return retStr;
}

- (NSString *)jiebanInfoJson{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInteger:self.femaleNum] forKey:@"joinedFemale"];
    [dic setObject:[NSNumber numberWithInteger:self.maleNum] forKey:@"joinedMale"];
    [dic setObject:[NSNumber numberWithInteger:self.isCanDiscuss] forKey:@"canDis"];
    [dic setObject:[NSNumber numberWithInteger:self.isGoHome ? 100 : 0] forKey:@"category"];
    [dic setObject:[NSNumber numberWithInteger:self.isDriver ? 100 : 0] forKey:@"tool"];
    [dic setObject:(self.startTime ? self.startTime : @"") forKey:@"startTime"];
    [dic setObject:(self.endTime ? self.endTime : @"") forKey:@"endTime"];
    [dic setObject:[NSNumber numberWithInt:[self.days intValue]] forKey:@"days"];
    [dic setObject:self.plansLocationInfo ? self.plansLocationInfo : @"" forKey:@"pointList"];
    [dic setObject:(self.title == nil ? self.plansLocationInfo : self.title) forKey:@"title"];
    [dic setObject:(self.desc ? self.desc : @"") forKey:@"desc"];
    
    NSMutableArray *palnsArr = [[NSMutableArray alloc] initWithArray:0];
    for (int i = 0, sum = [self.plansArr count]; i < sum; i++) {
        AGPlanModel *plan = [self.plansArr objectAtIndex:i];
        [palnsArr addObject:[plan getModelDictionry]];
    }
    
    [dic setObject:palnsArr forKey:@"fragments"];
    
    return [dic JSONRepresentation];
}


+ (AGJiebanPlanModel *)jiebanInfoFromJsonValue:(NSDictionary *)valueDic{
    AGJiebanPlanModel *jiebanModel = [[AGJiebanPlanModel alloc] init];
    jiebanModel.jiebanId = [[valueDic objectForKey:@"planId"] longLongValue];
    jiebanModel.userId = [[valueDic objectForKey:@"userId"] longLongValue];
    jiebanModel.femaleNum = [[valueDic objectForKey:@"joinedFemale"] intValue];
    jiebanModel.maleNum = [[valueDic objectForKey:@"joinedMale"] intValue];
    
//    NONE(0),//未知  DRIVE(100),//自驾   AIRPLANE(200),//飞机 TRAIN(300),//火车
//    WALK(400),//步行x  BUS(500);//汽车  BIKE(600)//自行车
    int tools = [[valueDic objectForKey:@"tool"] intValue];
    jiebanModel.isDriver = (tools == 100);
    
//    NONE(0),//未知  BACK_HOME(100);//返乡返校
    int category = [[valueDic objectForKey:@"category"] intValue];
    jiebanModel.isGoHome = (category == 100);
    jiebanModel.isCanDiscuss = [[valueDic objectForKey:@"canDis"] boolValue];
    
    NSString *startTime = [NSString stringWithFormat:@"%d",[[valueDic objectForKey:@"startTime"] intValue]];
    jiebanModel.startTime = [AGBorderHelper convertStr:startTime startFormt:@"yyyyMMdd" endFormate:@"yyyy-MM-dd"];
    
    NSString *endTime = [NSString stringWithFormat:@"%d",[[valueDic objectForKey:@"endTime"] intValue]];
    jiebanModel.endTime = [AGBorderHelper convertStr:endTime startFormt:@"yyyyMMdd" endFormate:@"yyyy-MM-dd"];
    
    jiebanModel.days = [valueDic objectForKey:@"days"];
    jiebanModel.desc = [valueDic objectForKey:@"desc"];
    
    NSArray *fragments = [valueDic objectForKey:@"fragments"];
    NSMutableArray *plans = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0, sum = [fragments count]; i< sum; i++) {
        NSDictionary *fragDic = [fragments objectAtIndex:i];
        AGPlanModel *model = [AGPlanModel planInfoFromJsonValue:fragDic];
        [plans addObject:model];
    }
    
    jiebanModel.plansArr = plans;
    
    return jiebanModel;
}

- (NSString *)getJiebanModelJson{
    NSString *jsonStr = @"{\"joinedMale\": 1,\"joinedFemale\": 1,\"needMale\": 2,\"needFemale\": 2,\"canDis\": 0,\"tool\": 100,\"category\": 100,\"startTime\": 20140705,\"endTime\": 20140705,\"desc\": \"线路的描述\",\"fragments\": [{\"days\": 12,\"startTime\": 20140705,\"endTime\": 20140705,\"location\": \"上海\",\"desc\": \"\"},{\"pId\": 12312,\"days\": 12321,\"startTime\": 20140705,\"endTime\": 20140705,\"location\": \"上海\",\"desc\":\"\"}]}";
    
    return jsonStr;
}
@end