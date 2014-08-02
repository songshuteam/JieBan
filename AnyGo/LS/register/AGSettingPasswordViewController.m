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
    
//    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    hud.labelText = @"完成中...";
//    [self.view addSubview:hud];
//    [hud showAnimated:YES whileExecutingBlock:^(void) {
//        buttonItem.enabled = NO;
//        sleep(2);
//    } completionBlock:^(void) {
//        buttonItem.enabled = YES;
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }];
    
    
    if ([self passwordIsEqual]) {
        AGBaseInfoViewController *viewController = [[AGBaseInfoViewController alloc] init];
        self.registerModel.nikeName = self.nameTextField.text;
        self.registerModel.password = self.passwordField.text;
        viewController.registerModel = self.registerModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }

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
        NSLog(@"%@",[url absoluteString]);
    }
}

@end