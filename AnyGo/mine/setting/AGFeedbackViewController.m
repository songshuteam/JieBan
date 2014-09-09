//
//  AGFeedbackViewController.m
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGFeedbackViewController.h"
#import "SAMTextView.h"

@interface AGFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet SAMTextView *feedbackTextView;

@property (weak, nonatomic) IBOutlet UIView *questionSelectview;
@property (weak, nonatomic) IBOutlet UIButton *suggestionBtn;
@property (weak, nonatomic) IBOutlet UIButton *complainBtn;
@property (weak, nonatomic) IBOutlet UIButton *consultBtn;
@end

@implementation AGFeedbackViewController

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
    self.title = @"帮助与反馈";
    self.feedbackTextView.placeholder = @"请输入你需要反馈的问题";
    UIColor *color = [UIColor colorWithRed:170.f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    
    [AGBorderHelper borderWithView:self.feedbackView borderWidth:.5f borderColor:color];
    [AGBorderHelper borderWithView:self.questionSelectview borderWidth:.5f borderColor:color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)questionSelectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}
@end
