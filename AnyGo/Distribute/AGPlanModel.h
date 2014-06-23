//
//  AGPlanModel.h
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGPlanModel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *strDate;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *planDescription;

@end

@interface AGAllPlanModel : NSObject

@property (nonatomic, copy) NSString *beginDate;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, strong) NSArray *plans;


@end
