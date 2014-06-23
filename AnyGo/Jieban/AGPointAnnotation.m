//
//  AGPointAnnotation.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPointAnnotation.h"

@implementation AGPointAnnotation

- (id)initWithStartAddress:(NSString *)sAddress endAddress:(NSString *)eAddress {
    self = [super init];
    if (self) {
        _startAddress = sAddress;
        _endAddress = eAddress;
    }
    return self;
}

@end
