//
//  AGResetPwdPhoneViewController.m
//  AnyGo
//
//  Created by tony on 7/27/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGResetPwdPhoneViewController.h"
#import "AGLSModel.h"

@interface AGResetPwdPhoneViewController ()<UITextFieldDelegate>
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStep:(id)sender{
    
}
@end
