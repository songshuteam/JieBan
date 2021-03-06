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

@interface AGAddressViewController () <UIActionSheetDelegate, UITextViewDelegate>

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
    self.planTextView.delegate = self;
    
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
    if (self.addressLabel.text == nil || [self.addressLabel.text isEqualToString:@""]) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请选择目的地或者正确填写路线描述"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alterView show];
        return;
    }

    AGPlanModel *plan = [[AGPlanModel alloc] init];
    plan.type = 1;
    plan.location = self.addressLabel.text;
    plan.desc = self.planTextView.text;
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

#pragma mark - TextViewDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length > 32) {
        return NO;
    }
    return YES;
}

@end
