//
//  WWADScrollView.h
//  AnyGo
//
//  Created by WingleWong on 14-2-12.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWADScrollViewDelegate;
@protocol WWADScrollViewDatasource;

@interface WWADScrollView : UIView <UIScrollViewDelegate> {
    NSInteger _totalPages;
    NSInteger _currentPage;
    NSMutableArray *_curViews;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, weak, setter = setDataource:) id<WWADScrollViewDatasource> datasource;
@property (nonatomic, weak, setter = setDelegate:) id<WWADScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol WWADScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(WWADScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol WWADScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end