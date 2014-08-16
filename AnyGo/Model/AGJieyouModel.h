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

@interface AGJieyouModel : NSObject

@property (assign, nonatomic) long long jieyouId;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) AGLSAreaCodeModel *areaCode;
@property (strong, nonatomic) NSString *headUrl;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *signature;
@property (assign, nonatomic) Gender gender;
@end


@interface AGRegisterModel : AGJieyouModel

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *codeMd5;
@property (strong, nonatomic) UIImage *faceImg;

- (NSString *)getAccountInfo;

@end