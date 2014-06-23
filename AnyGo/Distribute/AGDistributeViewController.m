//
//  AGDistributeViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/9/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGDistributeViewController.h"
#import "AGPlaViewController.h"
#import "AGNavigationController.h"

@interface AGDistributeViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) TSLocateType locateType;

@end

@implementation AGDistributeViewController

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
    self.navigationItem.title = @"发布";
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"国内", @"国际"]];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(0, 0, 130.f, 29.f);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.locateType = 0;
    [self.segmentedControl addTarget:self
                         action:@selector(actionChanged:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(distributePlan:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)planButtonClicked:(id)sender {
    AGPlaViewController *planVc = [[AGPlaViewController alloc] initWithNibName:@"AGPlaViewController" bundle:nil];
    planVc.hidesBottomBarWhenPushed = YES;
    planVc.distributeViewController = self;
    planVc.locateType = self.locateType;
    [self.navigationController pushViewController:planVc animated:YES];
}

#pragma mark - Uitility methods
- (void)distributePlan:(id)sender {
    
}

- (void)actionChanged:(id)sender {
    self.locateType = self.segmentedControl.selectedSegmentIndex;
}

#pragma mark - textfileld delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - touch event 
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.femaleNumTextField isFirstResponder]) {
        [self.femaleNumTextField resignFirstResponder];
    }
    
    if ([self.maleNumTextField isFirstResponder]) {
        [self.maleNumTextField resignFirstResponder];
    }
    
    [self.maleNumTextField resignFirstResponder];
}
@end
