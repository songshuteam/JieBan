//
//  AGShareTableViewCell.h
//  timeLine
//
//  Created by tony on 14-7-9.
//  Copyright (c) 2014年 zjx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AGShareItem.h"
#import "AGShareCommentItem.h"

#import "AGShowImageControl.h"
#import "AGShareViewController.h"

@class AGShareTableViewCell;

@protocol AGShareTableViewCellDelegate <NSObject>

- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell commentInfo:(AGShareCommentItem *)commentItem;
- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell userId:(long long)userId;
- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell commentShareInfoId:(long long)uid;

@end

@interface AGShareTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (strong, nonatomic) AGShareItem *shareItem;
@property (assign, nonatomic) id<AGShareTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *faceImagView;
@property (strong, nonatomic) IBOutlet UIButton *userName;
@property (strong, nonatomic) IBOutlet UILabel *contentInfo;
@property (strong, nonatomic) IBOutlet AGShowImageControl *imageContent;

@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIImageView *commentBgView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;


@property (strong, nonatomic) AGShareViewController *shareViewController;

- (void)setCellContent:(AGShareItem *)item;

+ (NSArray *)getCoreTextStyle;
+ (CGFloat)getHeightByShareItem:(AGShareItem *)shareItem;
+ (CGFloat)getHeightForComments:(NSArray *)comments;
+ (CGFloat)getHeightForComment:(AGShareCommentItem *)commentItem;
@end
