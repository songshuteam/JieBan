//
//  AGResetPwdPhoneViewController.m
//  AnyGo
//
//  Created by tony on 7/27/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGResetPwdPhoneViewController.h"

#import "AGLSModel.h"
#import "AGBorderHelper.h"
#import "Toast+UIView.h"

#import "AGResetPwdViewController.h"

@interface AGResetPwdPhoneViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate>
@property (strong, nonatomic) AGLSAreaCodeModel *areaCode;
@property (weak, nonatomic) IBOutlet UIImageView *areaBgView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@end

@implementation AGResetPwdPhoneViewController

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
    self.areaBgView.image = [[UIImage imageNamed:@"border_code"] stretchableImageWithLeftCapWidth:80 topCapHeight:25];
    self.areaCode = [[AGLSAreaCodeModel alloc] init];
    
    self.title = @"重置密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStep:(id)sender{
    [self.view endEditing:YES];
    
    if ([AGBorderHelper isValidateMobile:self.phoneNum.text]) {
        NSString *accountInfo = [[NSString stringWithFormat:@"%@-%@", self.areaCode.phoneCode, self.phoneNum.text] stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        NSURL *smsUrl = [AGUrlManager urlSMSWithMobileNum:accountInfo withType:2];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:smsUrl];
        request.delegate = self;
        [request startAsynchronous];
    }else{
        [self.view makeToast:@"输入电话号码有误，请重新输入"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSString *code = [valueDic objectForKey:@"code"];
        //           send verificode to phone number
        AGResetPwdViewController *viewController = [[AGResetPwdViewController alloc] init];
        viewController.codeMd5 = code;
        viewController.phoneNum = self.phoneNum.text;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.phoneNum]) {
        [self nextStep:nil];
    }
    
    return YES;
}

@end
