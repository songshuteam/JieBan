//
//  AGFilterModel.h
//  AnyGo
//
//  Created by tony on 8/12/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumHeader.h"

@interface AGFilterModel : NSObject

@property (nonatomic, assign) BOOL isDriver;
@property (nonatomic, assign) BOOL isReturn;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) AddressType addressType;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *countryCity;
@property (nonatomic, strong) NSString *outboundCity;

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@end
