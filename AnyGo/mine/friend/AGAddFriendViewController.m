//
//  AGAddFriendViewController.m
//  AnyGo
//
//  Created by tony on 9/13/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGAddFriendViewController.h"
#import "AGSearchFriendListViewController.h"

@interface AGAddFriendViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *searchKey;
@end

@implementation AGAddFriendViewController

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
    [AGBorderHelper borderWithView:self.contentView borderWidth:.5f borderColor:[UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:1]];
    self.title = @"添加结友";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.searchKey becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *text = textField.text;
    AGSearchFriendListViewController *viewController = [[AGSearchFriendListViewController alloc] init];
    viewController.keyWord = text;
    [self.navigationController pushViewController:viewController animated:YES];
    
    return YES;
}

@end
