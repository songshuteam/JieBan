//
//  AGPersonInfoViewController.h
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

@class AGUserInfoModel;

typedef NS_ENUM(NSInteger, PersonInfoType) {
    PersonInfoTypeFace = 1,
    PersonInfoTypeNickName,
    PersonInfoTypeSex,
    PersonInfoTypearea,
    PersonInfoTypeEmail,
    PersonInfoTypeJiebanPWD,
    PersonInfoTypeSignature
};

@interface AGPersonInfoViewController : AGViewController

@property (assign, nonatomic) long long userId;
@property (strong, nonatomic) AGUserInfoModel *userInfo;
@end
