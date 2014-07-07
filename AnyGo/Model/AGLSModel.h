//
//  AGLSModel.h
//  AnyGo
//
//  Created by tony on 14-7-7.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGLSAreaCodeModel : NSObject <NSCopying,NSCoding>

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *phoneCode;

@end