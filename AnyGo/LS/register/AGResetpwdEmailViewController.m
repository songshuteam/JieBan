//
//  AGResetpwdEmailViewController.m
//  AnyGo
//
//  Created by tony on 7/27/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGResetpwdEmailViewController.h"

@interface AGResetpwdEmailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailInfo;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *findPwdBtn;
@end

@implementation AGResetpwdEmailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findPwdBtnClick:(id)sender {
}
@end
