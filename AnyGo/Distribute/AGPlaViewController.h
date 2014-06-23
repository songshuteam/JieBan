//
//  AGPlaViewController.h
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"
#import "TSLocateView.h"

@class UIPlaceHolderTextView;
@class AGPlanModel;
@class AGDistributeViewController;

@interface AGPlaViewController : AGViewController

@property (weak, nonatomic) AGDistributeViewController *distributeViewController;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UIView *showLineView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *startTextView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *endTextView;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;
@property (nonatomic, assign) TSLocateType locateType;


- (IBAction)dateButtonClicked:(id)sender;
- (IBAction)getAddressButtonClicked:(id)sender;
- (IBAction)endAddressButtonClicked:(id)sender;

- (void)addAddressToPlan:(AGPlanModel *)plan;


@end


#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
