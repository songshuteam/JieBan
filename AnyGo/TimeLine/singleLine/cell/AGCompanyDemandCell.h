//
//  AGCompanyDemandCell.h
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCompanyNeedModel.h"

@interface AGCompanyDemandCell : UITableViewCell

@property (strong, nonatomic) AGCompanyNeedModel *companyNeedModel;

- (void)contentInfoWithModel:(AGCompanyNeedModel *)model;

+ (CGFloat)heightForCell:(AGCompanyNeedModel *)model;
@end
