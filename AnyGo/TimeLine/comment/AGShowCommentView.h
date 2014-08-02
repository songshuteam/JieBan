//
//  AGShowCommentView.h
//  shareTime
//
//  Created by tony on 7/14/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGShareItem.h"

@interface AGShowCommentView : UIView{
}

@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) AGShareItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
