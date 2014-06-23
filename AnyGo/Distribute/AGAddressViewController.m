//
//  AGAddressViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/13/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGAddressViewController.h"
#import "AGPlaViewController.h"
#import "AGPlanModel.h"

@interface AGAddressViewController () <UIActionSheetDelegate>

@end

@implementation AGAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addressButtonClicked:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" andLocationType:self.planViewController.locateType delegate:self];
    [locateView showInView:self.view];
}

- (IBAction)okButtonClicked:(id)sender {
    BOOL canOK = YES;
    if (self.addressLabel.text == nil || [self.addressLabel.text isEqualToString:@""]) {
        canOK = NO;
    }

    AGPlanModel *plan = [[AGPlanModel alloc] init];
    plan.type = 1;
    plan.address = self.addressLabel.text;
    plan.planDescription = self.planTextView.text;
    [self.planViewController addAddressToPlan:plan];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    LOG(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    if(buttonIndex == 0) {
        LOG(@"Cancel");
    }else {
        LOG(@"Select");
        self.addressLabel.text = location.city;
    }
}
@end
