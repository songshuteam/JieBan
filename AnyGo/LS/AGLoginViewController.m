//
//  AGLoginViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGLoginViewController.h"
#import "PBFlatBarButtonItems.h"
#import "AGShoujiViewController.h"

#import <CoreText/CoreText.h>

@interface AGLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *registerButton;

@end

@implementation AGLoginViewController

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
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *backItem = [PBFlatBarButtonItems backBarButtonItemWithTarget:self selector:@selector(beBack:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    NSMutableAttributedString *placeName = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [placeName addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSRangeFromString(@"请输入手机号")];
    self.usernameTextField.attributedPlaceholder = placeName;
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender {
    
}

- (IBAction)registerButtonClicked:(id)sender {
    AGShoujiViewController *registerContrller = [[AGShoujiViewController alloc] init];
    [self.navigationController pushViewController:registerContrller animated:YES];
}

@end
