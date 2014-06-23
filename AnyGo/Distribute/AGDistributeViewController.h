//
//  AGDistributeViewController.h
//  AnyGo
//
//  Created by Wingle Wong on 6/9/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"
#import "AGPlanModel.h"

@interface AGDistributeViewController : AGViewController
@property (weak, nonatomic) IBOutlet UITextField *femaleNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *maleNumTextField;
@property (weak, nonatomic) IBOutlet UISwitch *driveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *discussEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gohomeSwitch;

@property (strong, nonatomic) AGAllPlanModel *allPlan;

- (IBAction)planButtonClicked:(id)sender;

@end
