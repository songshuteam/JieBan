//
//  AGLoginViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGLoginViewController.h"

#import "AGLSModel.h"
#import "Toast+UIView.h"
#import "AGBorderHelper.h"
#import "PBFlatBarButtonItems.h"

#import "AGPhoneCodeSelectViewController.h"
#import "AGResetPwdPhoneViewController.h"
#import "AGResetpwdEmailViewController.h"
#import "AGRequestManager.h"
#import "AGShoujiViewController.h"

@interface AGLoginViewController () <UITextFieldDelegate, UIActionSheetDelegate,AGPhoneCodeSelectDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPwdBtn;

@property (nonatomic, strong) AGLSAreaCodeModel *areaCode;

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
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *backItem = [PBFlatBarButtonItems backBarButtonItemWithTarget:self selector:@selector(beBack:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.areaCode = [[AGLSAreaCodeModel alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender {
//    检查手机号是否合法
    NSString *phoneNum = self.usernameTextField.text;
    NSString *passwordInfo = self.passwordTextField.text;
    
    if ([phoneNum isEqualToString:@""] || phoneNum == nil) {
        [self.view makeToast:@"用户名不能为空"];
        
        return;
    }
    
    if ([passwordInfo isEqualToString:@""] || passwordInfo == nil) {
        [self.view makeToast:@"密码不能为空"];
        
        return;
    }

    if ([self.areaCode.countryCode isEqualToString:@"+86"]) {
        if ([AGBorderHelper isValidateMobile:phoneNum]) {
            [self.view makeToast:@"用户名不合法，请重新输入"];
            
            self.usernameTextField.text = nil;
            self.passwordTextField.text = nil;
            [self.usernameTextField becomeFirstResponder];
            
            return;
        }
    }
    
    NSString *accountInfo = [NSString stringWithFormat:@"%@-%@",self.areaCode.countryCode,phoneNum];
    ASIHTTPRequest *request = [AGRequestManager requestlogintWithAccount:accountInfo password:passwordInfo];
    request.delegate = self;
    
    [request startAsynchronous];
}

- (IBAction)registerButtonClicked:(id)sender {
    AGShoujiViewController *registerContrller = [[AGShoujiViewController alloc] init];
    [self.navigationController pushViewController:registerContrller animated:YES];
}

- (IBAction)phoneCodeBtnClick:(id)sender {
    AGPhoneCodeSelectViewController *viewController = [[AGPhoneCodeSelectViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)findPwdClick:(id)sender {
    UIActionSheet *sheect = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机找回密码",@"邮箱找回密码", nil];
    
    [sheect showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { //phone
        AGResetPwdPhoneViewController *viewController = [[AGResetPwdPhoneViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (buttonIndex == 1){ //email
        AGResetpwdEmailViewController *viewController = [[AGResetpwdEmailViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}

- (void)alertViewWithmessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - ASIHTTPRequest 
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseStr = [request responseString];
    NSDictionary *valueDic = [responseStr JSONValue];
    
    if ([[valueDic objectForKey:@"status"] integerValue] == 200) {
        long long userId = [[valueDic objectForKey:@"userId"] longLongValue];
        NSString *token = [valueDic objectForKey:@"token"];
        NSString *tempToken = [valueDic objectForKey:@"tempToken"];
        
//        login success deal
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:userId] forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKENINFO];
        [[NSUserDefaults  standardUserDefaults] setObject:tempToken forKey:TEMPTOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

#pragma mark - AGPhoneCodeSelectDelegate
- (void)selectWithAreaCode:(AGLSAreaCodeModel *)model{
    self.areaCode = model;
    [self.phoneCodeBtn setTitle:self.areaCode.countryCode forState:UIControlStateNormal];
}
@end