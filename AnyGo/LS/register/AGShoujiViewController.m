//
//  AGShoujiViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGShoujiViewController.h"

#import "AGVerifiedCodeViewController.h"
#import "AGPhoneCodeSelectViewController.h"
#import "AGSettingPasswordViewController.h"
#import "AGWebViewController.h"
#import "AGUrlManager.h"

#import "AGLSModel.h"
#import "AGBorderHelper.h"
#import "FTCoreTextView.h"

@interface AGShoujiViewController ()<ASIHTTPRequestDelegate, FTCoreTextViewDelegate, AGPhoneCodeSelectDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet FTCoreTextView *dealInfoView;
@property (strong, nonatomic) AGLSAreaCodeModel *areaCodeModel;
@property (weak, nonatomic) IBOutlet UIButton *phoneCodeBtn;

- (IBAction)areaButtonClicked:(id)sender;
@end

@implementation AGShoujiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.areaCodeModel = [[AGLSAreaCodeModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction:)];
    
    [self.phoneCodeBtn setTitle:self.areaCodeModel.phoneCode forState:UIControlStateNormal];
    
    [self initDealInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initDealInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -
- (void)borderWithBgView{
//    self.codeLabel.text = self.areaCodeModel.phoneCode;
//    
//    [AGBorderHelper borderWithView:self.areaSelectView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
//    [AGBorderHelper borderWithView:self.phoneNumView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
//    [AGBorderHelper borderWithView:self.nextStepBgImageView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
//    [AGBorderHelper borderWithView:self.codeLabel borderWidth:.5f borderColor:[UIColor blackColor]];
}

- (void) initDealInfo{
    NSString *placeStr = @"点击“下一步”表示你同意<a>1234|《结伴行软件许可及服务协议》</a>";
    self.dealInfoView.text = placeStr;
    self.dealInfoView.backgroundColor = [UIColor clearColor];
    
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.color = [UIColor lightGrayColor];
    defaultStyle.font = [UIFont systemFontOfSize:12];
    
    FTCoreTextStyle *styleA = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    styleA.name = @"a";
    styleA.color = [UIColor colorWithRed:3/255.0 green:124.0/255.0 blue:255.0/255.0 alpha:1];
    styleA.font = [UIFont systemFontOfSize:12];
    
    [self.dealInfoView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
    
    [self.dealInfoView addStyles:@[defaultStyle, styleA]];
    self.dealInfoView.delegate = self;
}

#pragma mark - UIView Interface
- (IBAction)areaButtonClicked:(id)sender {
    AGPhoneCodeSelectViewController *viewController = [[AGPhoneCodeSelectViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

//__attribute__((deprecated("register in other Class")))  设方法为废弃
- (IBAction)nextStepAction:(id)sender {
    [self.view endEditing:YES];
    
    if (self.phoneTextField.text == nil && self.phoneTextField.text.length <= 0) {
        [self showAlertMessageForPhone];
        return;
    }
    
    if ([self.areaCodeModel.phoneCode isEqualToString:@"+86"] && ![AGBorderHelper isValidateMobile:self.phoneTextField.text]) {
        [self showAlertMessageForPhone];
        return;
    }
    
    NSString *accountInfo = [[NSString stringWithFormat:@"%@-%@",self.areaCodeModel.phoneCode,self.phoneTextField.text] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[AGUrlManager urlIsRegisterAccount:accountInfo]];
    request.delegate = self;
    request.didFinishSelector = @selector(requestIsRegisterFinish:);
    [request startAsynchronous];
}

- (void)showAlertMessageForPhone{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"输入电话号码有误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
    self.phoneTextField.text = nil;
}

#pragma mark - 
- (void)requestIsRegisterFinish:(ASIHTTPRequest *)request{
    NSDictionary *value = [request.responseString JSONValue];
    
    int status = [[value objectForKey:@"status"] intValue];
    
    if (status == 200) {
        if ([self.areaCodeModel.phoneCode isEqualToString:@"+86"]) {
            if ([AGBorderHelper isValidateMobile:self.phoneTextField.text] ) {
                NSString *accountInfo = [[NSString stringWithFormat:@"%@-%@",self.areaCodeModel.phoneCode,self.phoneTextField.text] stringByReplacingOccurrencesOfString:@"+" withString:@""];
                
                NSURL *smsUrl = [AGUrlManager urlSMSWithMobileNum:accountInfo withType:1];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:smsUrl];
                //            request set
                request.defaultResponseEncoding = NSUTF8StringEncoding;
                request.timeOutSeconds = 60;
                request.delegate = self;
                [request startSynchronous];
            }else{
                [self showAlertMessageForPhone];
            }
        }else{
            if (self.phoneTextField.text != nil && self.phoneTextField.text.length > 0) {
                AGSettingPasswordViewController *viewController = [[AGSettingPasswordViewController alloc] init];
                AGRegisterModel *model = [[AGRegisterModel alloc] init];
                model.account = self.phoneTextField.text;
                model.areaCode = self.areaCodeModel;
                
                viewController.registerModel = model;
                [self.navigationController pushViewController:viewController animated:YES];
            }else{
                [self showAlertMessageForPhone];
            }
        }
    }else if (status == 451){
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"该账号已经被注册，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
        
        self.phoneTextField.text = nil;
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200 || true) {
        NSString *code = [valueDic objectForKey:@"code"];
        //           send verificode to phone number
        AGVerifiedCodeViewController *viewController = [[AGVerifiedCodeViewController alloc] init];
        AGRegisterModel *model = [[AGRegisterModel alloc] init];
        model.account = self.phoneTextField.text;
        model.areaCode = self.areaCodeModel;
        model.codeMd5 = code;
        viewController.registerModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
}

#pragma mark - AGPhoneCodeSelectDelegate
- (void)selectWithAreaCode:(AGLSAreaCodeModel *)model{
    if (model != nil) {
        self.areaCodeModel = model;
        [self.phoneCodeBtn setTitle:model.phoneCode forState:UIControlStateNormal];
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
