//
//  AGSettingPasswordViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGSettingPasswordViewController.h"
#import "PBFlatBarButtonItems.h"
#import "PBFlatButton.h"
#import "PBFlatTextfield.h"
#import "MBProgressHUD.h"

@interface AGSettingPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) PBFlatTextfield *nameTextField;
@property (nonatomic, strong) PBFlatTextfield *passwordField;

@end

@implementation AGSettingPasswordViewController

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
    self.title = @"完成";
    
    // LeftBarButtonItem
    if (SYM_VERSION < 7) {
        UIBarButtonItem *leftBarItem = [PBFlatBarButtonItems backBarButtonItemWithTarget:self selector:@selector(beBack:)];
        [self.navigationItem setLeftBarButtonItem:leftBarItem];
    }
    
    // RightBarButtonItem
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemButton.frame = CGRectMake(0, 0, 60.f, 36.f);
    [itemButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [itemButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [itemButton setTitleColor:[UIColor colorWithRed:0.35f green:0.51f blue:0.91f alpha:1.00f] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    [self.navigationItem setRightBarButtonItem:nextItem];
    
    [self buildViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)forward:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.labelText = @"完成中...";
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^(void) {
        buttonItem.enabled = NO;
        sleep(2);
    } completionBlock:^(void) {
        buttonItem.enabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)buildViews {
    CGFloat originX = 20.f;
    CGFloat originY = 20.f;
    CGFloat labelWidth = 200.f;
    CGFloat verticalInterval = 10.f;
    CGFloat textFieldWidth = 180.f;
    CGFloat height = 40.f;
    
    CGFloat yOffset = 0;
    
    if (self.nameTextField == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, height)];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.text = @"1.请输入您的姓名";
        [self.view addSubview:label];
        
        self.nameTextField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX, originY + height, textFieldWidth, height)];
        self.nameTextField.delegate = self;
        [self.view addSubview:self.nameTextField];
        
    }
    yOffset = yOffset + originY + height*2 + verticalInterval;
    
    if (self.passwordField == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, yOffset, labelWidth, height)];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.text = @"2.请设一个密码";
        [self.view addSubview:label];
        
        self.passwordField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX, yOffset + height, textFieldWidth, height)];
        self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        self.passwordField.delegate = self;
        [self.view addSubview:self.passwordField];
    }
}


@end
