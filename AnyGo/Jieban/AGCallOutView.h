//
//  AGCallOutView.h
//  AnyGo
//
//  Created by tony on 8/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGPlanModel.h"

@class AGCallOutView;

@protocol AGCallOutViewDelegate <NSObject>

- (void)callOutView:(AGCallOutView *)callView showUserInfoWithUserId:(long long)userId;

@end

@interface AGCallOutView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AGJiebanPlanModel *jiebanModel;
@property (nonatomic, assign) id<AGCallOutViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArr;;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bgImg;

- (void)contentViewInitWithPlanInfo:(AGJiebanPlanModel *)planModel;
@end
