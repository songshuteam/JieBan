//
//  AGShowImageControl.h
//  图片浏览器示例
//
//  Created by tony on 14-7-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
//
@class AGShowImageControl;

@protocol AGShowImageControlDelegate <NSObject>

@optional
- (void)ShowImageControlFinished:(AGShowImageControl *)control;

- (void)checkImageAction:(AGShowImageControl *)control;

@end

@interface AGShowImageControl : UIView{
    NSArray *_imageUrls;
}

@property (nonatomic, weak) id<AGShowImageControlDelegate> delegate;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSArray *imageUrls;

- (void)setImageWithUrls:(NSArray *)imgUrls;
+ (CGFloat)heightForImageViews:(NSArray *)images;

@end
