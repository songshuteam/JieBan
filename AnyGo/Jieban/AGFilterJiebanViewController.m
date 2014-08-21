//
//  AGFilterJiebanViewController.m
//  AnyGo
//
//  Created by tony on 8/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGFilterJiebanViewController.h"

#import "AGBorderHelper.h"
#import "AGFilterModel.h"

@interface AGFilterJiebanViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *isDriveBgView;
@property (weak, nonatomic) IBOutlet UIView *isRetSchoolBgVIew;
@property (weak, nonatomic) IBOutlet UISwitch *isDriveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isRetSchoolSwitch;

@property (weak, nonatomic) IBOutlet UIButton *startAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *endAddressBtn;

@property (weak, nonatomic) IBOutlet UIButton *femaleFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *noGenderBtn;

@property (weak, nonatomic) IBOutlet UIView *distanceDaysBgView;
@property (weak, nonatomic) IBOutlet UITextField *daysTextField;

@property (weak, nonatomic) IBOutlet UIView *countryCityBgView;
@property (weak, nonatomic) IBOutlet UIView *worldCityBgView;
@property (weak, nonatomic) IBOutlet UITextField *countryCityTextField;
@property (weak, nonatomic) IBOutlet UITextField *worldCitytextField;
@end

@implementation AGFilterJiebanViewController

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
    [self borderinit];
    
    self.filterModel = [[AGFilterModel alloc] init];
    
    [self.contentScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick:)];
    
    [self viewInitWIthFilterInfo:self.filterModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init
- (void)viewInitWIthFilterInfo:(AGFilterModel *)model{
    [self.isDriveSwitch setOn:model.isDriver];
    [self.isRetSchoolSwitch setOn:model.isReturn];
    
    BOOL isStart = (model.addressType == AddressTypeStart);
    self.startAddressBtn.selected = isStart;
    self.endAddressBtn.selected = !isStart;
    [self genderSelectWithType:model.gender];
    
    if (![model.days isEqualToString:@""]) {
        self.daysTextField.text = model.days;
    }
    
    if (![model.countryCity isEqualToString:@""]) {
        self.countryCityTextField.text = model.countryCity;
    }
    
    if (![model.outboundCity isEqualToString:@""]) {
        self.worldCitytextField.text = model.outboundCity;
    }
}

- (void)borderinit{
    UIColor *color = [UIColor lightGrayColor];//[UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1];
    [AGBorderHelper borderWithView:self.isDriveBgView borderWidth:.5f borderColor:color];
    [AGBorderHelper borderWithView:self.isRetSchoolBgVIew borderWidth:.5f borderColor:color];
    [AGBorderHelper borderWithView:self.distanceDaysBgView borderWidth:.5f borderColor:color];
    [AGBorderHelper borderWithView:self.countryCityBgView borderWidth:.5f borderColor:color];
    [AGBorderHelper borderWithView:self.worldCityBgView borderWidth:.5f borderColor:color];
}

#pragma mark - btn Click
- (IBAction)confirmBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewController:filterCondition:)]) {
        [self.delegate filterViewController:self filterCondition:self.filterModel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)genderSelectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self genderSelectWithType:btn.tag];
    self.filterModel.gender = btn.tag;
}

- (void)genderSelectWithType:(Gender)gender{
    switch (gender) {
        case GenderFemale:
        {
            self.femaleFilterBtn.selected = YES;
            self.maleFilterBtn.selected = NO;
            self.noGenderBtn.selected = NO;
        }
            break;
        case GenderMale:
        {
            self.femaleFilterBtn.selected = NO;
            self.maleFilterBtn.selected = YES;
            self.noGenderBtn.selected = NO;
        }
            break;
        case GenderOther:
        {
            self.femaleFilterBtn.selected = NO;
            self.maleFilterBtn.selected = NO;
            self.noGenderBtn.selected = YES;
        }
            break;
        default:
            break;
    }

}

- (IBAction)valueChange:(id)sender {
    UISwitch *switchTem = (UISwitch *)sender;
    if (switchTem == self.isDriveSwitch) {
        self.filterModel.isDriver = self.isDriveSwitch.isOn;
    }else if (switchTem == self.isRetSchoolSwitch){
        self.filterModel.isReturn = self.isRetSchoolSwitch.isOn;
    }
}

- (IBAction)addressSelectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            self.startAddressBtn.selected = YES;
            self.endAddressBtn.selected = NO;
        }
            break;
        case 1:
        {
            self.startAddressBtn.selected = NO;
            self.endAddressBtn.selected = YES;
        }
            break;
     
        default:
            break;
    }
    self.filterModel.addressType = btn.tag;
}

@end
