//
//  AGPointAnnotation.h
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "EnumHeader.h"

@interface AGPointAnnotation : MKPointAnnotation

@property (nonatomic, assign) long long planId;
@property (nonatomic, assign) long long userId;
@property (nonatomic, assign) long long fId;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, copy) NSString *endAddress;

- (id)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

@end
