//
//  AGJiebanAnnotationView.h
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "AGPointAnnotation.h"

@interface AGJiebanAnnotationView : MKAnnotationView

@property (nonatomic, strong) AGPointAnnotation *pointAnnotation;

@end
