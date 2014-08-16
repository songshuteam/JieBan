//
//  AGCompanyDemandCell.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPlanModel.h"

@interface AGCompanyDemandCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;

@property (nonatomic, weak) IBOutlet UILabel *endAddressTitle;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, weak) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDiscussLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *isReturnLabel;

@property (strong, nonatomic) AGJiebanPlanModel *jiebanPlanModel;

- (void)contentInfoWithModel:(AGJiebanPlanModel *)model;

+ (CGFloat)heightForCell:(AGJiebanPlanModel *)model;
@end
