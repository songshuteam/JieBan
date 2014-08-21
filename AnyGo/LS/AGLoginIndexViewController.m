//
//  AGLoginIndexViewController.m
//  AnyGo
//
//  Created by tony on 7/26/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGLoginIndexViewController.h"

#import "AGLoginViewController.h"
#import "AGShoujiViewController.h"

@interface AGLoginIndexViewController ()

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation AGLoginIndexViewController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self backBarButtonWithTitle:@"返回"];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginBtnClick:(id)sender {
    AGLoginViewController *viewController = [[AGLoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)registerBtnClick:(id)sender {
    AGShoujiViewController *viewController = [[AGShoujiViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
