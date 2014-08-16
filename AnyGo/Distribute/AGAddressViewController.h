//
//  AGAddressViewController.h
//  AnyGo
//
//  Created by Wingle Wong on 6/13/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

@class AGPlaViewController;
@class AGPlanModel;


@interface AGAddressViewController : AGViewController
@property (weak, nonatomic) AGPlaViewController *planViewController;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *planTextView;


- (IBAction)addressButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
