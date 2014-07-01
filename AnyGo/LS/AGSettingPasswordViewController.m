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

@interface AGSettingPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *nikebgImageView;
@property (nonatomic, strong) IBOutlet UIButton *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBgImageView;
@property (nonatomic, strong) IBOutlet UIButton *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainField;
@property (weak, nonatomic) IBOutlet UIImageView *nextStepBgImageView;
@property (weak, nonatomic) IBOutlet UITextField *nextStepBtn;

@end

@implementation AGSettingPasswordViewController

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
    self.title = @"昵称和密码";
    
    // LeftBarButtonItem
    if (SYM_VERSION < 7) {
        UIBarButtonItem *leftBarItem = [PBFlatBarButtonItems backBarButtonItemWithTarget:self selector:@selector(beBack:)];
        [self.navigationItem setLeftBarButtonItem:leftBarItem];
    }
    
    // RightBarButtonItem

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (IBAction)beBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)forward:(id)sender {
//    [self.nameTextField resignFirstResponder];
//    [self.passwordField resignFirstResponder];
//    
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
    AGBaseInfoViewController *viewController = [[AGBaseInfoViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
