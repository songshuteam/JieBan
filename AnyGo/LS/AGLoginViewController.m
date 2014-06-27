//
//  AGLoginViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGLoginViewController.h"
#import "PBFlatBarButtonItems.h"
#import "PBFlatButton.h"
#import "PBFlatTextfield.h"
#import "AGRegisterViewController.h"
#import <CoreText/CoreText.h>

@interface AGLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet PBFlatTextfield *usernameTextField;
@property (nonatomic, strong) IBOutlet PBFlatTextfield *passwordTextField;

@property (nonatomic, strong) IBOutlet PBFlatButton *loginButton;
@property (nonatomic, strong) IBOutlet PBFlatButton *registerButton;

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
    self.title = @"登录";
    
    UIBarButtonItem *backItem = [PBFlatBarButtonItems backBarButtonItemWithTarget:self selector:@selector(beBack:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    ;
    NSMutableAttributedString *placeName = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号"];
    [placeName addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSRangeFromString(@"请输入手机号")];
    self.usernameTextField.attributedPlaceholder = placeName;
    
    
  [self buildViews];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender {
    
}

- (IBAction)registerButtonClicked:(id)sender {
    AGRegisterViewController *registerContrller = [[AGRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerContrller animated:YES];
}

- (void)buildViews {
    CGFloat originX = 20.f;
    CGFloat originY = 30.f;
    CGFloat labelWidth = 90.f;
    CGFloat verticalInterval = 20.f;
    CGFloat textFieldWidth = self.view.bounds.size.width - originX*2 - labelWidth;
    CGFloat height = 40.f;
    CGFloat buttonHeight = 40.f;
    CGFloat buttonWidth = 120.f;
    
    CGFloat yOffset = 0;
    
    if (self.usernameTextField == nil) {
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, height)];
        usernameLabel.text = @"手机号码";
        [self.view addSubview:usernameLabel];
        self.usernameTextField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX + labelWidth, originY, textFieldWidth, height)];
        self.usernameTextField.keyboardType = UIKeyboardTypePhonePad;
        self.usernameTextField.delegate = self;
        [self.view addSubview:self.usernameTextField];
    }
    yOffset = yOffset + originY + height + verticalInterval;
    
    if (self.passwordTextField == nil) {
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, yOffset, labelWidth, height)];
        usernameLabel.text = @"密码";
        [self.view addSubview:usernameLabel];
        self.passwordTextField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX + labelWidth, yOffset, textFieldWidth, height)];
        self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.passwordTextField.delegate = self;
        [self.view addSubview:self.passwordTextField];
    }
    yOffset = yOffset + height + verticalInterval;
    
    if (self.loginButton == nil) {
        self.loginButton = [[PBFlatButton alloc] initWithFrame:CGRectMake(originX, yOffset, buttonWidth, buttonHeight)];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
    }
    
    if (self.registerButton == nil) {
        self.registerButton = [[PBFlatButton alloc] initWithFrame:CGRectMake(320.f - originX - buttonWidth, yOffset, buttonWidth, buttonHeight)];
        [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.registerButton];
    }
}

@end
