//
//  AGPointAnnotation.h
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface AGPointAnnotation : MKPointAnnotation

@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *endAddress;

- (id)initWithStartAddress:(NSString *)sAddress endAddress:(NSString *)eAddress;

@end
