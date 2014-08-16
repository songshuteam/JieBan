//
//  AGAnnotationLabel.h
//  AnyGo
//
//  Created by tony on 8/10/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGAnnotationLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;

-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end
