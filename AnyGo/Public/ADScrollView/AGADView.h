//
//  AGADView.h
//  AnyGo
//
//  Created by WingleWong on 14-2-12.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWADScrollView.h"

@protocol AGADViewDelegate <NSObject>

@optional
-(void)selectedRecItemWithItem:(NSObject *)item;

@end

@interface AGADView : UIView <WWADScrollViewDatasource, WWADScrollViewDelegate> {
    WWADScrollView *adScrollView;
    NSMutableArray *adPages;
}

@property (nonatomic, weak) id<AGADViewDelegate> delegate;


-(void)startRequestData;


@end
