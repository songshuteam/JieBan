//
//  AGSettingPasswordViewController.m
//  AnyGo
//
//  Created by WingleWong on 14-2-17.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGSettingPasswordViewController.h"
#import "PBFlatBarButtonItems.h"

#import "MBProgressHUD.h"

#import "AGBaseInfoViewController.h"
#import "AGWebViewController.h"
#import "FTCoreTextView.h"
#import "AGBorderHelper.h"

@interface AGSettingPasswordViewController () <UITextFieldDelegate,FTCoreTextViewDelegate>{
    BOOL isAgree;
}

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;
@property (nonatomic, strong) IBOutlet UIButton *nextStepBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet FTCoreTextView *agreementInfo;

@end

@implementation AGSettingPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isAgree = true;
        
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
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepClick:)];
    [self agreementInfoInit];
    [AGBorderHelper borderWithView:self.contentView borderWidth:.5f borderColor:[UIColor lightTextColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) agreementInfoInit{
    self.agreementInfo.backgroundColor = [UIColor clearColor];
    NSString *placeStr = @"我已经阅读并接受<a>1234|《结伴行用户协议》</a>";
    self.agreementInfo.text = placeStr;
    
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.color = [UIColor lightGrayColor];
    defaultStyle.font = [UIFont systemFontOfSize:12];
    
    FTCoreTextStyle *styleA = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    styleA.name = @"a";
    styleA.color = [UIColor colorWithRed:3/255.0 green:124.0/255.0 blue:255.0/255.0 alpha:1];
    styleA.font = [UIFont systemFontOfSize:12];
    
    [self.agreementInfo changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
    
    [self.agreementInfo addStyles:@[defaultStyle, styleA]];
    self.agreementInfo.delegate = self;
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextStepClick:(id)sender {
    [self.view endEditing:YES];
    
    if ([self passwordIsEqual]) {
        if ([AGBorderHelper isValidatePassword:self.passwordField.text]) {
            AGBaseInfoViewController *viewController = [[AGBaseInfoViewController alloc] init];
            self.registerModel.nickname = self.nameTextField.text;
            self.registerModel.password = self.passwordField.text;
            viewController.registerModel = self.registerModel;
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self.view makeToast:@"密码输入不合规则，密码有字母或数字组成"];
            [self passwordInfoToEmpty];
        }
    }else{
        [self.view makeToast:@"两次密码输入不一致，请重新输入！"];
        [self passwordInfoToEmpty];
    }
}

- (void)passwordInfoToEmpty{
    self.passwordField.text = nil;
    self.passwordAgainField.text = nil;
    [self.passwordField becomeFirstResponder];
}

- (IBAction)agreementBtnClick:(id)sender {
    if (isAgree) {
        [self.agreementBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        isAgree = false;
    }else{
        [self.agreementBtn setImage:[UIImage imageNamed:@"icon_agree"] forState:UIControlStateNormal];
        isAgree = true;
    }
}

#pragma mark - 
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.passwordAgainField) {
        [self passwordIsEqual];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTextField) {
        [self.passwordField becomeFirstResponder];
    }else if (textField == self.passwordField){
        [self.passwordAgainField becomeFirstResponder];
    }else if(textField == self.passwordAgainField){
        [self nextStepClick:nil];
    }
    
    return YES;
}

- (BOOL)passwordIsEqual{
    if (self.passwordField.text != nil && [self.passwordField.text isEqualToString:self.passwordAgainField.text]) {
        
        return YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"两次输入密码不一致，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        self.passwordField.text = nil;
        self.passwordAgainField.text = nil;
        [self.passwordField becomeFirstResponder];
        
        return NO;
    }
}

#pragma mark - FTCoreTextViewDelegate
- (void)coreTextView:(FTCoreTextView *)acoreTextView receivedTouchOnData:(NSDictionary *)data
{
    NSURL *url = [data objectForKey:FTCoreTextDataURL];
    
    if ([[url absoluteString] isEqualToString:@"http://1234"]) {
        AGWebViewController *viewController = [[AGWebViewController alloc] init];
        NSString *htmlStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"]  encoding:NSUTF8StringEncoding error:nil];
        viewController.htmlStr = htmlStr;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
