//
//  AGFilterModel.m
//  AnyGo
//
//  Created by tony on 8/12/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGFilterModel.h"

@implementation AGFilterModel

- (id)init{
    if (self = [super init]) {
        _isDriver = YES;
        _isReturn = NO;
        _gender = GenderFemale;
        _addressType = AddressTypeStart;
        _days = 0;
        _countryCity = @"";
        _outboundCity = @"";
    }
    
    return self;
}

@end
