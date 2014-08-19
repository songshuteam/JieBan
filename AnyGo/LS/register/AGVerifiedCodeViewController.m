//
//  AGVerifiedCodeViewController.m
//  AnyGo
//
//  Created by tony on 14-6-30.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGVerifiedCodeViewController.h"

#import "AGSettingPasswordViewController.h"

#import "AGBorderHelper.h"
#import "NSString+Encryption.h"

#define PHONE_VERIFY_COOLDOWN_SECOND 60

@interface AGVerifiedCodeViewController ()<ASIHTTPRequestDelegate>{
     int         nCountDownRemain;
}

@property (strong, nonatomic) NSTimer *downTimer;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumAlertLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedCodeBgImageView;
@property (weak, nonatomic) IBOutlet UITextField *verifiedCodeText;
@property (weak, nonatomic) IBOutlet UIButton *retryGetCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIImageView *nextStepBgImageView;

@end

@implementation AGVerifiedCodeViewController

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
    
    [self borderWithBgView];
    self.title = @"注册";
    self.retryGetCodeBtn.enabled = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepBtnClick:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startTimer];
    
    NSString *phoneNum = [NSString stringWithFormat:@"%@  %@",self.registerModel.areaCode.phoneCode,self.registerModel.account];
    self.phoneNumberLabel.text = phoneNum;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init View Info
- (void)borderWithBgView{
    [AGBorderHelper borderWithView:self.nextStepBgImageView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
}

- (void)startTimer{
    [self.downTimer invalidate];
    self.downTimer = nil;
    
    self.downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(coolDownCountDown:) userInfo:nil repeats:YES];
    
    NSString *title = [NSString stringWithFormat:@"重新发送短信(%d)", nCountDownRemain];
	[self.retryGetCodeBtn setTitle:title forState:UIControlStateNormal];
    
    nCountDownRemain--;
    nCountDownRemain = nCountDownRemain >= 0 ? nCountDownRemain : 0;
    
    self.retryGetCodeBtn.enabled = false;
}

- (void)coolDownCountDown:(NSTimer*)aTimer{
	if (nCountDownRemain == 0) {
		[self.downTimer invalidate];
		self.retryGetCodeBtn.enabled	= YES;
        [self.retryGetCodeBtn setTitle:[NSString stringWithFormat:@"重新发送短信"] forState:UIControlStateNormal];
		nCountDownRemain = PHONE_VERIFY_COOLDOWN_SECOND;
        
		return;
	}
    
    NSString *title = [NSString stringWithFormat:@"重新发送短信(%d)", nCountDownRemain];
   [self.retryGetCodeBtn setTitle:title forState:UIControlStateNormal|UIControlStateDisabled];
    
    nCountDownRemain--;
    nCountDownRemain = nCountDownRemain >= 0 ? nCountDownRemain:0;
    
    return;
}


#pragma mark - interface
- (IBAction)retryGetCodeBtnClick:(id)sender {
//   调用从新获取验证码
    NSURL *smsUrl = [AGUrlManager urlSMSWithMobileNum:[NSString stringWithFormat:@"%@-%@",self.registerModel.areaCode.phoneCode,self.registerModel.account] withType:1];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:smsUrl];
    request.delegate = self;
    [request startAsynchronous];
   
    [self startTimer];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSString *code = [valueDic objectForKey:@"code"];
        //           send verificode to phone number
        self.registerModel.codeMd5 = code;
    }else{
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{

}

- (IBAction)nextStepBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    NSString *verifiedCode = self.verifiedCodeText.text;
    if ([[verifiedCode md5Encrypt] isEqualToString:self.registerModel.codeMd5] || true) {
        AGSettingPasswordViewController *viewController = [[AGSettingPasswordViewController alloc] init];
        self.registerModel.code = verifiedCode;
        viewController.registerModel = self.registerModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"验证码错误，请重新输入！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        self.verifiedCodeText.text = nil;
    }
}

@end
