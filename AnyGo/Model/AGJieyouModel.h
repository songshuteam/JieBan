//
//  AGJieyouModel.h
//  AnyGo
//
//  Created by tony on 7/22/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGLSModel.h"
#import "EnumHeader.h"

@interface AGJieyouModel : NSObject<NSCoding>

@property (assign, nonatomic) long long jieyouId;
@property (strong, nonatomic) NSString *account;        //账户
@property (strong, nonatomic) NSString *nickname;       //用户名
@property (strong, nonatomic) AGLSAreaCodeModel *areaCode;
@property (strong, nonatomic) NSString *headUrl;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *signature;
@property (assign, nonatomic) Gender gender;
@property (assign, nonatomic) RelationType relation;        //备注
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSDate *insertDate;

+ (AGJieyouModel *)parseJsonInfo:(NSDictionary *)valueDic;

@end


@interface AGRegisterModel : AGJieyouModel<NSCoding>

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *codeMd5;
@property (strong, nonatomic) UIImage *faceImg;

- (NSString *)getAccountInfo;

@end

@interface AGUserInfoModel : AGJieyouModel<NSCoding>

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *jieyouPwd;      //有疑问？？？
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSString *imageInfo;
@property (nonatomic, assign) NSInteger fansNum;
@property (nonatomic, assign) NSInteger followerNum;
@property (nonatomic, assign) NSInteger followingNum;
@property (nonatomic, assign) NSInteger postNum;
@property (nonatomic, assign) NSInteger praisedNum;
@property (nonatomic, assign) NSInteger pullStatus;

@property (nonatomic, strong) NSString *avatar;             //头像位置，大头像
@property (nonatomic, strong) NSString *thumbnailAvatar;    //小头像


+ (AGUserInfoModel *)parseJsonInfo:(NSDictionary *)valueDic;
@end