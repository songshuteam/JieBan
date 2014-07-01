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

@interface AGVerifiedCodeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNumAlertLabel;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self borderWithBgView];
    self.title = @"填写验证码";
    
    self.phoneNum = @"1436878798";
    NSString *reminder = [NSString stringWithFormat:@"我们将验证码短信发至%@",self.phoneNum];
    NSRange range = [reminder rangeOfString:self.phoneNum];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:reminder];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:range];
    self.phoneNumAlertLabel.attributedText = attributedStr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)borderWithBgView{
    [AGBorderHelper borderWithView:self.verifiedCodeBgImageView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
    [AGBorderHelper borderWithView:self.nextStepBgImageView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
    [AGBorderHelper cornerWithView:self.retryGetCodeBtn cornerRadius:2.0f borderWidth:.5f borderColor:[UIColor lightGrayColor]];
}

#pragma mark - interface
- (IBAction)retryGetCodeBtnClick:(id)sender {
}

- (IBAction)nextStepBtnClick:(id)sender {
    AGSettingPasswordViewController *viewController = [[AGSettingPasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
