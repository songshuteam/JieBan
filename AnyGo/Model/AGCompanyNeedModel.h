//
//  AGCompanyNeedModel.h
//  AnyGo
//
//  Created by tony on 7/22/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AGDestinationModel : NSObject
@property (strong, nonatomic) NSString *destinationCity;
@property (strong, nonatomic) NSString *destinationDesc;

@end


@interface AGCompanyNeedModel : NSObject

@property (assign, nonatomic) long long needId;
@property (strong, nonatomic) NSString *startingTime;
@property (strong, nonatomic) NSString *startingCity;
@property (strong, nonatomic) NSArray *destinations;
@property (strong, nonatomic) NSString *daysTrip;
@property (assign, nonatomic) BOOL isSelfDriving;
@property (assign, nonatomic) BOOL isCanDiscuss;
@property (assign, nonatomic) NSInteger males;
@property (assign, nonatomic) NSInteger females;
@property (assign, nonatomic) BOOL isBackSchool;

@end
