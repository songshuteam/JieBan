//
//  AGResetPwdViewController.m
//  AnyGo
//
//  Created by tony on 8/3/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGResetPwdViewController.h"

#import "NSString+Encryption.h"
#import "AGBorderHelper.h"
#import "AGLSModel.h"

#define PHONE_VERIFY_COOLDOWN_SECOND 60

@interface AGResetPwdViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate>{
    int         nCountDownRemain;
}

@property (strong, nonatomic) AGLSAreaCodeModel *areaCodeModel;
@property (strong, nonatomic) NSTimer *downTimer;

@property (weak, nonatomic) IBOutlet UILabel *mobileNumInfo;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UITextField *resetPwdField;
@property (weak, nonatomic) IBOutlet UIButton *retrySendMsgBtn;

@end

@implementation AGResetPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nCountDownRemain = PHONE_VERIFY_COOLDOWN_SECOND;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手机号码验证";
    self.areaCodeModel = [[AGLSAreaCodeModel alloc] init];
    
    self.retrySendMsgBtn.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(modifyAccountPwd:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
    self.mobileNumInfo.text = [NSString stringWithFormat:@"%@  %@",self.areaCodeModel.phoneCode, self.phoneNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifyAccountPwd:(id)sender{
    [self.view endEditing:YES];
    
    NSString *code = self.verifyCodeField.text;
    
    if (![[code md5Encrypt] isEqualToString:self.codeMd5]) {
        [self.view makeToast:@"验证码输入错误，请重新输入"];
        self.verifyCodeField.text = nil;
        self.resetPwdField.text = nil;
        
        return;
    }
    
    if (![AGBorderHelper isValidatePassword:self.resetPwdField.text]) {
        [self.view makeToast:@"密码输入错误，密码有字母和数字组成"];
        
        return ;
    }
    
    NSURL *resetUrl = [AGUrlManager urlResetPwd];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:resetUrl];
    NSString *mobileNum = [[NSString stringWithFormat:@"%@-%@",self.areaCodeModel.phoneCode,self.phoneNum] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    [request setPostValue:mobileNum forKey:@"account"];
    [request setPostValue:code forKey:@"code"];
    request.delegate = self;
    [request setPostValue:self.resetPwdField.text forKey:@"newPassword"];
    request.didFinishSelector = @selector(requestResetPwdFinished:);
    [request startAsynchronous];

}

- (IBAction)retrySenMsgBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    //   调用从新获取验证码
    NSURL *smsUrl = [AGUrlManager urlSMSWithMobileNum:[NSString stringWithFormat:@"%@-%@",self.areaCodeModel.phoneCode,self.phoneNum] withType:2];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:smsUrl];
    request.delegate = self;
    [request startAsynchronous];
    
    [self startTimer];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestResetPwdFinished:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
    NSString *responseStr = [request responseString];
    NSDictionary *valueDic = [responseStr JSONValue];
    
    if ([[valueDic objectForKey:@"status"] integerValue] == 200) {
        long long userId = [[valueDic objectForKey:@"userId"] longLongValue];
        NSString *token = [valueDic objectForKey:@"token"];
        NSString *tempToken = [valueDic objectForKey:@"tempToken"];
        
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[NSString stringWithFormat:@"%lld",userId] password:[self.resetPwdField.text md5Encrypt] completion:^(NSDictionary *loginInfo, EMError *error) {
            if (error) {
                NSLog(@"聊天登陆失败");
            }else{
                NSLog(@"聊天登陆成功");
            }
        } onQueue:nil];
        //        login success deal
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:userId] forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:self.resetPwdField.text forKey:USERPASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKENINFO];
        [[NSUserDefaults  standardUserDefaults] setObject:tempToken forKey:TEMPTOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGINFINISH object:nil];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSString *code = [valueDic objectForKey:@"code"];
        //           send verificode to phone number
        self.codeMd5 = code;
    }else{
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.resetPwdField]) {
        [self modifyAccountPwd:nil];
    }
    
    return YES;
}

#pragma mark - NSTimer start and loop
- (void)startTimer{
    [self.downTimer invalidate];
    self.downTimer = nil;
    
    self.downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(coolDownCountDown:) userInfo:nil repeats:YES];
    
    NSString *title = [NSString stringWithFormat:@"重新发送短信(%d)", nCountDownRemain];
	[self.retrySendMsgBtn setTitle:title forState:UIControlStateNormal];
    
    nCountDownRemain--;
    nCountDownRemain = nCountDownRemain >= 0 ? nCountDownRemain : 0;
    
    self.retrySendMsgBtn.enabled = false;
}

- (void)coolDownCountDown:(NSTimer*)aTimer{
	if (nCountDownRemain == 0) {
		[self.downTimer invalidate];
		self.retrySendMsgBtn.enabled	= YES;
        [self.retrySendMsgBtn setTitle:[NSString stringWithFormat:@"重新发送短信"] forState:UIControlStateNormal];
		nCountDownRemain = PHONE_VERIFY_COOLDOWN_SECOND;
        
		return;
	}
    
    NSString *title = [NSString stringWithFormat:@"重新发送短信(%d)", nCountDownRemain];
    [self.retrySendMsgBtn setTitle:title forState:UIControlStateNormal|UIControlStateDisabled];
    
    nCountDownRemain--;
    nCountDownRemain = nCountDownRemain >= 0 ? nCountDownRemain:0;
    
    return;
}

@end
