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

#import "AGBorderHelper.h"
#import "FTCoreTextView.h"

@interface AGShoujiViewController ()<FTCoreTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *areaSelectView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UIImageView *nextStepBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet FTCoreTextView *dealInfoView;

- (IBAction)areaButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;
@end

@implementation AGShoujiViewController

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
    self.navigationController.navigationBarHidden = NO;
    
    [self borderWithBgView];
    [self initDealInfo];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.areaSelectView addGestureRecognizer:singleTapGesture];
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
    [AGBorderHelper borderWithView:self.areaSelectView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
    [AGBorderHelper borderWithView:self.phoneNumView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
    [AGBorderHelper borderWithView:self.nextStepBgImageView borderWidth:.5f borderColor:[UIColor lightGrayColor]];
    [AGBorderHelper borderWithView:self.codeLabel borderWidth:.5f borderColor:[UIColor blackColor]];
}

- (void) initDealInfo{
    NSString *placeStr = @"轻触上面的“下一步”按钮，即表示你同意<a>1234|《结伴行用户协议》</a>";
    self.dealInfoView.text = placeStr;
    
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.color = [UIColor lightGrayColor];
    defaultStyle.font = [UIFont systemFontOfSize:12];
    
    FTCoreTextStyle *styleA = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    styleA.name = @"a";
    styleA.color = [UIColor colorWithRed:14/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1];
    styleA.font = [UIFont systemFontOfSize:12];
    
    [self.dealInfoView changeDefaultTag:FTCoreTextTagLink toTag:@"a"];
    
    [self.dealInfoView addStyles:@[defaultStyle, styleA]];
    self.dealInfoView.delegate = self;
}

#pragma mark - UIView Interface
- (IBAction)areaButtonClicked:(id)sender {
}

- (IBAction)registerButtonClicked:(id)sender {
    AGVerifiedCodeViewController *viewController = [[AGVerifiedCodeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    AGPhoneCodeSelectViewController *viewController = [[AGPhoneCodeSelectViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
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
