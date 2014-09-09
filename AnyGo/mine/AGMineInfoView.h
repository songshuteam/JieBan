//
//  AGMineInfoView.h
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGJieyouModel.h"

@class AGMineInfoView;

typedef NS_ENUM(NSInteger, MineInfoType) {
    MineInfoTypeAddFriend,
    MineInfoTypePersonInfo,
    MineInfoTypePostMsg
};

@protocol  AGMineInfoDelegate <NSObject>

- (void)mineInfoView:(AGMineInfoView *)infoView mineInfoType:(MineInfoType)type;

@end

@interface AGMineInfoView : UIView
@property (assign, nonatomic) id<AGMineInfoDelegate> delegate;

@property (strong, nonatomic) AGJieyouModel *userInfo;

- (void)contentInitWithJieyou:(AGJieyouModel *)jieyouModel;
- (void)updateFaceImage:(UIImage *)faceImg;
@end
