//
//  AGJieyouModel.h
//  AnyGo
//
//  Created by tony on 7/22/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGLSModel.h"

/**
 *  性别
 */
typedef NS_ENUM(NSInteger, Gender) {
    /**
     *  女性
     */
    GenderFemale = 0,
    /**
     *  男性
     */
    GenderMale,
    
    GenderOther
};

@interface AGJieyouModel : NSObject

@property (assign, nonatomic) long long jieyouId;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *nikeName;
@property (strong, nonatomic) AGLSAreaCodeModel *areaCode;
@property (strong, nonatomic) NSString *headUrl;
@property (strong, nonatomic) NSString *birthday;
@property (assign, nonatomic) Gender gender;
@end


@interface AGRegisterModel : AGJieyouModel

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *code;

@end