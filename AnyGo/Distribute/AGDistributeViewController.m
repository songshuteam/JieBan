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

#import "AGLoginViewController.h" 
#import "AGBorderHelper.h"
#import "AGRequestManager.h"
#import  <MBProgressHUD.h>

@interface AGDistributeViewController ()<ASIHTTPRequestDelegate,UITextFieldDelegate>{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) TSLocateType locateType;

@property (weak, nonatomic) IBOutlet UIView *genderNumView;
@property (weak, nonatomic) IBOutlet UIView *driverSelfView;
@property (weak, nonatomic) IBOutlet UIView *discussView;
@property (weak, nonatomic) IBOutlet UIView *gohomeView;
@property (weak, nonatomic) IBOutlet UIView *planView;
@end

@implementation AGDistributeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.locateType = TSLocateCN;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布";
//    [self backBarButtonWithTitle:@"返回"];
    
    self.jiebanModel = [[AGJiebanPlanModel alloc] init];
    
    [self menuForNavigationItemInit];
    [self borderForViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *plansAddress = [self.jiebanModel plansLocationInfo];
    if (plansAddress == nil || [plansAddress isEqualToString:@""]) {
        self.destinationsLabel.text = @"无";
    }else{
        self.destinationsLabel.text = plansAddress;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init
- (void)menuForNavigationItemInit{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"国内", @"国际"]];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.frame = CGRectMake(0, 0, 170.f, 23.f);
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

- (void)borderForViews{
    UIColor *borderColor = self.bgViewColor;
    [AGBorderHelper borderWithView:self.genderNumView borderWidth:.5f borderColor:borderColor];
    [AGBorderHelper borderWithView:self.driverSelfView borderWidth:.5f borderColor:borderColor];
    [AGBorderHelper borderWithView:self.discussView borderWidth:.5f borderColor:borderColor];
    [AGBorderHelper borderWithView:self.gohomeView borderWidth:.5f borderColor:borderColor];
    [AGBorderHelper borderWithView:self.planView borderWidth:.5f borderColor:borderColor];
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
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    
    ASIFormDataRequest *request = [AGRequestManager requestCreatePlanWithUserId:@"1234566" planModel:self.jiebanModel];
    request.delegate = self;
    request.tag = 1;
    [request startAsynchronous];
}

- (void)actionChanged:(id)sender {
    self.locateType = self.segmentedControl.selectedSegmentIndex;
}

- (IBAction)switchValueChange:(id)sender {
    UISwitch *switchTem = (UISwitch *)sender;
    BOOL flag = switchTem.isOn;
    if (switchTem == self.driveSwitch) {
        self.jiebanModel.isDriver = flag;
    }else if (switchTem == self.discussEnableSwitch){
        self.jiebanModel.isCanDiscuss = flag;
    }else if (switchTem == self.gohomeSwitch){
        self.jiebanModel.isGoHome = flag;
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    [hud hide:YES];
    NSLog(@"%d is %@",request.tag,request.responseString);
    NSDictionary *valueDic = [request.responseString JSONValue];
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        [self.view makeToast:@"发布成功"];
        long long planId = [[valueDic objectForKey:@"message"] longLongValue];
    }
    
    [self distributeViewInfoInit];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
     [hud hide:YES];
    NSLog(@"%d is %@",request.tag,request.responseString);
}

#pragma mark - textfileld delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  
    [textField resignFirstResponder];
}

- (void)distributeViewInfoInit{
    self.femaleNumTextField.text = nil;
    self.maleNumTextField.text = nil;
    [self.driveSwitch setOn:NO animated:YES];
    [self.discussEnableSwitch setOn:YES animated:YES];
    [self.gohomeSwitch setOn:NO animated:YES];
    self.destinationsLabel.text = @"无";
    self.jiebanModel = [[AGJiebanPlanModel alloc] init];
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
