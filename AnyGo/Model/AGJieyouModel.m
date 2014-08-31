//
//  AGJieyouModel.m
//  AnyGo
//
//  Created by tony on 7/22/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJieyouModel.h"

#define     JieyouId      @"JieyouId"
#define     Account     @"jieyouAccount"
#define     AreaCode    @"areaCOde"
#define     HeadUrl     @"jieyouHeadUrl"
#define     BirthDay    @"birthDay"
#define     Signature   @"signature"
#define     Gender      @"gender"

#define     JieyouPWD   @"jieyouPassword"
#define     JieyouCode  @"jieyouCode"
#define     JieyouCodeMd5    @"jieyouCodeMd5"
#define     JieyouFaceImage  @"jieyouFaceImage"

#define     userInfoTag             @"UserInfoTag"
#define     userInfoFansNum         @"UserinfoFansnum"
#define     userInfoFollowNum       @"UserinfoFollowNum"
#define     userInfoFollowingNum     @"userinfoFollowingNum"
#define     userInfoPostNum         @"userinfoPostNum"
#define     userInfoPraiseNum       @"userinfoPraiseNum"
#define     userInfoPullStatus      @"userInfoPullStatus"
#define     userInfoInsertTime      @"userinfoInsertTime"
#define     userInfoRelation        @"userinfoRelation"
#define     userInfoAvatar          @"userinfoAvatar"
#define     userInfoThumAvatar      @"userinfothumbnailAvatar"

@implementation AGJieyouModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithLongLong:self.jieyouId] forKey:JieyouId];
    [aCoder encodeObject:self.account forKey:Account];
    [aCoder encodeObject:self.areaCode forKey:AreaCode];
    [aCoder encodeObject:self.headUrl forKey:HeadUrl];
    [aCoder encodeObject:self.birthday forKey:BirthDay];
    [aCoder encodeObject:self.signature forKey:Signature];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:Gender];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    AGJieyouModel *model = [[AGJieyouModel alloc] init];
    model.jieyouId = [[aDecoder decodeObjectForKey:JieyouId] longLongValue];
    model.account = [aDecoder decodeObjectForKey:Account];
    model.areaCode = [aDecoder decodeObjectForKey:AreaCode];
    model.headUrl = [aDecoder decodeObjectForKey:HeadUrl];
    model.birthday = [aDecoder decodeObjectForKey:BirthDay];
    model.signature = [aDecoder decodeObjectForKey:Signature];
    model.gender = [[aDecoder decodeObjectForKey:Gender] integerValue];
    
    return model;
}

@end


@implementation AGRegisterModel

- (NSString *)getAccountInfo{
    NSString *account = [NSString stringWithFormat:@"%@-%@",self.areaCode.phoneCode,self.account];
    NSString *info = [account stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    return info;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.password forKey:JieyouPWD];
    [aCoder encodeObject:self.code forKey:JieyouCode];
    [aCoder encodeObject:self.codeMd5 forKey:JieyouCodeMd5];
    [aCoder encodeObject:self.faceImg forKey:JieyouFaceImage];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    AGRegisterModel *model = [super initWithCoder:aDecoder];
    model.password = [aDecoder decodeObjectForKey:JieyouPWD];
    model.code = [aDecoder decodeObjectForKey:JieyouCode];
    model.codeMd5 = [aDecoder decodeObjectForKey:JieyouCodeMd5];
    model.faceImg = [aDecoder decodeObjectForKey:JieyouFaceImage];
    
    return model;
}

@end


@implementation AGUserInfoModel

- (id)initWithCoder:(NSCoder *)aDecoder{
    AGUserInfoModel *model = [super initWithCoder:aDecoder];
    model.tag = [[aDecoder decodeObjectForKey:userInfoTag] integerValue];
    model.fansNum = [[aDecoder decodeObjectForKey:userInfoFansNum] integerValue];
    model.followerNum = [[aDecoder decodeObjectForKey:userInfoFollowNum] integerValue];
    model.followingNum = [[aDecoder decodeObjectForKey:userInfoFollowingNum] integerValue];
    model.postNum = [[aDecoder decodeObjectForKey:userInfoPostNum] integerValue];
    model.praisedNum = [[aDecoder decodeObjectForKey:userInfoPraiseNum] integerValue];
    model.pullStatus = [[aDecoder decodeObjectForKey:userInfoPullStatus] integerValue];
    model.insertTime = [aDecoder decodeObjectForKey:userInfoInsertTime];
    model.relation = [aDecoder decodeObjectForKey:userInfoRelation];
    model.avatar = [aDecoder decodeObjectForKey:userInfoAvatar];
    model.thumbnailAvatar = [aDecoder decodeObjectForKey:userInfoThumAvatar];
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.tag] forKey:userInfoTag];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fansNum] forKey:userInfoFansNum];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.followerNum] forKey:userInfoFollowNum];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.followingNum] forKey:userInfoFollowingNum];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.postNum] forKey:userInfoPostNum];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.praisedNum] forKey:userInfoPraiseNum];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.pullStatus] forKey:userInfoPullStatus];
    [aCoder encodeObject:self.insertTime forKey:userInfoInsertTime];
    [aCoder encodeObject:self.relation forKey:userInfoRelation];
    [aCoder encodeObject:self.avatar forKey:userInfoAvatar];
    [aCoder encodeObject:self.thumbnailAvatar forKey:userInfoThumAvatar];
    
}

+ (AGUserInfoModel *)parseJsonInfo:(NSDictionary *)valueDic{
    AGUserInfoModel *model = [[AGUserInfoModel alloc] init];
    model.jieyouId = [[valueDic objectForKey:@"userId"] longLongValue];
    model.nickname = [valueDic objectForKey:@"nickName"];
    model.account = [valueDic objectForKey:@"account"];
    model.gender = [[valueDic objectForKey:@"gender"] integerValue];
    model.signature = [valueDic objectForKey:@"signature"];
    model.tag =[[valueDic objectForKey:@"tag"] integerValue];
    model.fansNum = [[valueDic objectForKey:@"fansNumber"] integerValue];
    model.followerNum = [[valueDic objectForKey:@"followerNumber"] integerValue];
    model.followingNum = [[valueDic objectForKey:@"followingNumber"] integerValue];
    model.postNum = [[valueDic objectForKey:@"postNumber"] integerValue];
    model.praisedNum = [[valueDic objectForKey:@"praisedNum"] integerValue];
    model.pullStatus = [[valueDic objectForKey:@"pullStatus"] integerValue];
    model.insertTime = [valueDic objectForKey:@"insertTime"];
    model.relation = [valueDic objectForKey:@"relation"];
    model.avatar = [valueDic objectForKey:@"avatar"];
    model.thumbnailAvatar = [valueDic objectForKey:@"thumbnailAvatar"];
    
    return model;
}


@end