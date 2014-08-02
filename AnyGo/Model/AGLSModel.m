//
//  AGLSModel.m
//  AnyGo
//
//  Created by tony on 14-7-7.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGLSModel.h"

@implementation AGLSAreaCodeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.country = @"china";
        self.countryCode = @"CN";
        self.phoneCode = @"+86";
    }
    return self;
}

- (id)initWithCountry:(NSString *)cStr countryCode:(NSString *)cCode phoneCode:(NSString *)pCode{
    self = [super init];
    if (self) {
        self.country = cStr;
        self.countryCode = cCode;
        self.phoneCode = pCode;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    AGLSAreaCodeModel *model = [[AGLSAreaCodeModel alloc] init];
    
    model.country = [self.country copy];
    model.countryCode = [self.countryCode copy];
    model.phoneCode = [self.phoneCode copy];
    
    return model;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.countryCode = [aDecoder decodeObjectForKey:@"country_code"];
        self.phoneCode = [aDecoder decodeObjectForKey:@"phone_code"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.countryCode forKey:@"country_code"];
    [aCoder encodeObject:self.phoneCode forKey:@"phone_code"];
}

@end