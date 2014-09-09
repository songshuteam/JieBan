//
//  AGCompanyDemandCell.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGCompanyDemandCell.h"

#import "NSMutableAttributedString+Helper.h"

const CGFloat DestinationWith = 280;

@implementation AGCompanyDemandCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)contentInfoWithModel:(AGJiebanPlanModel *)model{
    self.startTime.text = model.startTime;
    AGPlanModel *startPlan = [model.plansArr objectAtIndex:0];
    self.startAddress.text = startPlan.location;
    
    CGFloat height = CGRectGetMinY(self.endAddressTitle.frame) + CGRectGetHeight(self.endAddressTitle.frame);
    CGFloat originY = height;
    
    NSArray *planArr = model.plansArr;
    for (int i = 1, sum = [planArr count]; i < sum; i++) {
        AGPlanModel *plan = [planArr objectAtIndex:i];
        NSString *destination =  [NSString stringWithFormat:@"%d. %@: %@", i, plan.location, plan.desc];
        CGSize size = [destination sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(DestinationWith, 2000)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, height, DestinationWith, size.height)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
        label.attributedText = [self addAttributeColorStr:plan.location  withAllStr:destination];
        [self addSubview:label];
        
        height += size.height;
    }
    
    CGRect rect = self.footerView.frame;
    rect.origin.y += height;
    self.footerView.frame = rect;
    
    CGRect cellRect = self.frame;
    cellRect.size.height += (height - originY);
    self.frame = cellRect;
    
    NSString *days = [NSString stringWithFormat:@"总计 %@ 天",model.days];
    self.daysLabel.attributedText = [self addAttributeColorStr:model.days withAllStr:days];
    self.isDriveLabel.text = model.isDriver ? @"是" : @"否";
    self.isDiscussLabel.text = model.isCanDiscuss ? @"是" : @"否";
    self.isReturnLabel.text = model.isGoHome ? @"是" : @"否";
   
    NSString *numStr = [NSString stringWithFormat:@"女 %d 人   男 %d 人",  model.femaleNum,model.maleNum];
    NSRange range1 = [numStr rangeOfString:[NSString stringWithFormat:@"%d",model.femaleNum]];
    NSRange range2 = [numStr rangeOfString:[NSString stringWithFormat:@"%d",model.maleNum]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:77.0f/255.0f green:166.0f/255.0f blue:1 alpha:1]} range:range1];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:77.0f/255.0f green:166.0f/255.0f blue:1 alpha:1]} range:range2];
    self.currentNumLabel.attributedText = attributeStr;
}

- (NSAttributedString *)addAttributeColorStr:(NSString *)subStr withAllStr:(NSString *)allStr{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSRange range = [allStr rangeOfString:subStr];
    
    [attributeStr addAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:77.0f/255.0f green:166.0f/255.0f blue:1 alpha:1]} range:range];
    
    return attributeStr;
}

+ (CGFloat)heightForCell:(AGJiebanPlanModel *)model{
    CGFloat height = 234.0f;
    NSArray *planArr = model.plansArr;
    for (int i = 1, sum = [planArr count]; i < sum; i++) {
        AGPlanModel *plan = [planArr objectAtIndex:i];
        NSString *destination =  [NSString stringWithFormat:@"%d. %@: %@", i, plan.location, plan.desc];
        CGSize size = [destination sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(DestinationWith, 2000)];
        height += size.height;
    }
    
    
    return height;
}

@end
