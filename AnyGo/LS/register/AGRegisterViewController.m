//
//  AGRegisterViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGRegisterViewController.h"
#import "PBFlatBarButtonItems.h"
#import "PBFlatButton.h"
#import "PBFlatTextfield.h"
#import "MBProgressHUD.h"
#import "AGSettingPasswordViewController.h"
#import "UIImage+Additions.h"

static const NSInteger kRemainingTime = 120;

@interface AGRegisterViewController () <UITextFieldDelegate> {
    NSInteger remainTime;
}

@property (nonatomic, strong) PBFlatTextfield *usernameTextField;
@property (nonatomic, strong) PBFlatTextfield *codeTextField;
@property (nonatomic, strong) PBFlatButton *sendButton;
@property (nonatomic, strong) NSTimer *sendTimer;

@end

@implementation AGRegisterViewController

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
    self.title = @"注册";
    
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
    [itemButton setTitle:@"下一步" forState:UIControlStateNormal];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
    [self.navigationItem setRightBarButtonItem:nextItem];
    

    [self buildViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.sendTimer invalidate];
    self.sendTimer = nil;
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)forward:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.labelText = @"注册中...";
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^(void) {
        buttonItem.enabled = NO;
        sleep(3);
    } completionBlock:^(void) {
        buttonItem.enabled = YES;
        AGSettingPasswordViewController *settingPassWVC = [[AGSettingPasswordViewController alloc] init];
        [self.navigationController pushViewController:settingPassWVC animated:YES];
    }];
}

- (IBAction)sendButtonClicked:(id)sender {
    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.labelText = @"发送中...";
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^(void) {
        buttonItem.enabled = NO;
        sleep(2);
    } completionBlock:^(void) {
        [self startSendTimer];
    }];
}

- (void)startSendTimer {
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.sendTimer forMode:NSDefaultRunLoopMode];
    remainTime = kRemainingTime;
    [self.sendTimer fire];
}

- (void)handleTimer:(NSTimer *)timer {
    if (remainTime <= 0) {
        [self.sendTimer invalidate];
        self.sendTimer = nil;
        
        self.sendButton.enabled = YES;
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        return;
    }
    [self.sendButton setTitle:[NSString stringWithFormat:@"(%d)",remainTime] forState:UIControlStateNormal];
    remainTime --;
}

- (void)buildViews {
    CGFloat originX = 20.f;
    CGFloat originY = 20.f;
    CGFloat labelWidth = 200.f;
    CGFloat verticalInterval = 10.f;
    CGFloat textFieldWidth = 260.f;
    CGFloat height = 40.f;
    
    CGFloat yOffset = 0;
    
    if (self.usernameTextField == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, height)];
        label.numberOfLines = 2;
        [label setFont:[UIFont systemFontOfSize:12]];
        label.text = @"1.请输入手机号码，系统会向此号码发送验证码";
        [label sizeToFit];
        [self.view addSubview:label];
        
        self.usernameTextField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX, originY + height, textFieldWidth, height)];
        self.usernameTextField.keyboardType = UIKeyboardTypePhonePad;
        self.usernameTextField.delegate = self;
        [self.view addSubview:self.usernameTextField];
        
        if (self.sendButton == nil) {
            self.sendButton = [[PBFlatButton alloc] initWithFrame:CGRectMake(0, 0, 60.f, height)];
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.usernameTextField.rightView = self.sendButton;
        self.usernameTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    yOffset = yOffset + originY + height*2 + verticalInterval;
    
    if (self.codeTextField == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, yOffset, labelWidth, height)];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.text = @"2.请输入手机短信收到的验证码";
        [self.view addSubview:label];
        
        self.codeTextField = [[PBFlatTextfield alloc] initWithFrame:CGRectMake(originX, yOffset + height, textFieldWidth, height)];
        self.codeTextField.keyboardType = UIKeyboardTypePhonePad;
        self.codeTextField.delegate = self;
        [self.view addSubview:self.codeTextField];
    }
}


@end
