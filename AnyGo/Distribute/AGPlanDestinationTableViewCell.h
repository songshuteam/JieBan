//
//  AGPlanDestinationTableViewCell.h
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGPlanDestinationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UITextView *planTextView;
@property (weak, nonatomic) IBOutlet UIView *breakLine;

@end
