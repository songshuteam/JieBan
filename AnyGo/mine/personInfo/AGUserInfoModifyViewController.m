//
//  AGUserInfoModifyViewController.m
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGUserInfoModifyViewController.h"

#import "SAMTextView.h"
#import "AGJieyouModel.h"
#import "Toast+UIView.h"

@interface AGUserInfoModifyViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (assign, nonatomic) Gender gender;

@property (weak, nonatomic) IBOutlet UIView *singleLineView;
@property (weak, nonatomic) IBOutlet UITextField *singleInfo;

@property (weak, nonatomic) IBOutlet UIView *sexSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *maleSelectedImg;
@property (weak, nonatomic) IBOutlet UIImageView *femaleSelectedImg;

@property (weak, nonatomic) IBOutlet UIView *signatureView;
@property (weak, nonatomic) IBOutlet SAMTextView *signatureTextView;
@property (weak, nonatomic) IBOutlet UILabel *signatureNum;
@end

@implementation AGUserInfoModifyViewController

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
    if (self.type == PersonInfoTypeSex) {
        self.singleLineView.hidden = YES;
        self.sexSelectView.hidden = NO;
        self.signatureView.hidden = YES;
    }else if (self.type == PersonInfoTypeSignature){
        self.singleLineView.hidden = YES;
        self.sexSelectView.hidden = YES;
        self.signatureView.hidden = NO;
    }else{
        self.singleLineView.hidden = NO;
        self.sexSelectView.hidden = YES;
        self.signatureView.hidden = YES;
    }
    
    self.signatureTextView.placeholder = @"输入你的个性签名";
    self.femaleSelectedImg.hidden = YES;
    self.maleSelectedImg.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveInfoChange:)];
    NSString *title = [self navigationTitle:self.type];
    self.title = title;
    self.singleInfo.placeholder = title;
    self.singleInfo.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - -
- (IBAction)saveInfoChange:(id)sender{
    AGUserInfoModel *model = self.personInfoViewController.userInfo;
    switch (self.type) {
        case PersonInfoTypearea:
            model.area = self.singleInfo.text;
            break;
        case PersonInfoTypeEmail:
            {
                if ([AGBorderHelper isValidateEmail:self.singleInfo.text]) {
                    model.email = self.singleInfo.text;
                }else{
                    [self.view makeToast:@"输入邮箱格式不正确"];
                }
            }
            break;
            
        default:
            break;
    }
}
- (IBAction)sexSelectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        self.gender = GenderMale;
        self.maleSelectedImg.hidden = NO;
        self.femaleSelectedImg.hidden = YES;
    }else if (btn.tag == 2){
        self.gender = GenderFemale;
        self.femaleSelectedImg.hidden = NO;
        self.maleSelectedImg.hidden = YES;
    }
}

- (NSString *)navigationTitle:(PersonInfoType)type{
    switch (type) {
        case PersonInfoTypeNickName:
            return @"昵称";
            break;
        case PersonInfoTypeEmail:
            return @"电子邮箱";
            break;
        case PersonInfoTypearea:
            return @"地区";
            break;
        case PersonInfoTypeSex:
            return @"性别";
            break;
        case PersonInfoTypeJiebanPWD:
            return @"结伴密码";
            break;
        case PersonInfoTypeSignature:
            return @"个性签名";
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark -- delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.type == PersonInfoTypeEmail && [AGBorderHelper isValidateEmail:textField.text]) {
        [self.view makeToast:@"邮箱输入错误，请重新输入"];
        return FALSE;
    }
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        
        return NO;
    } else {
        if ([textView.text length] > 150){
            return NO;
        } else {
            if ((text==nil || [text length]==0) && range.location==0) {
                [self.signatureNum setText:[NSString stringWithFormat:@"%i", 150]];
            } else {
                [self.signatureNum setText:[NSString stringWithFormat:@"%i" , 150 - [text length]+[textView.text length]]];
            }
        }
    }
    return YES;
}


@end
