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
#import "TSLocateView.h"

@interface AGFilterJiebanViewController ()<UITextFieldDelegate>


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
        self.filterModel = [[AGFilterModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self borderinit];
    
    [self citySelectInit];
    
    [self.contentScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick:)];
    
    [self viewInitWithFilterInfo:self.filterModel];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.view addGestureRecognizer:singleTapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)citySelectInit{
    TSLocateView *countryView = [[TSLocateView alloc] initWithTitle:@"选择城市" andLocationType:TSLocateCN delegate:self];
    countryView.tag = 2014082501;
    self.countryCityTextField.inputView = countryView;
    self.countryCityTextField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    
    TSLocateView *outView = [[TSLocateView alloc] initWithTitle:@"选择城市" andLocationType:TSLocateGlobal delegate:self];
    outView.tag = 2014082502;
    self.worldCitytextField.inputView = outView;
    self.worldCitytextField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - view init
- (void)viewInitWithFilterInfo:(AGFilterModel *)model{
    if (!model) {
        self.filterModel = [[AGFilterModel alloc] init];
        model = self.filterModel;
    }
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
    self.filterModel.countryCity = self.countryCityTextField.text;
    self.filterModel.outboundCity = self.worldCitytextField.text;
    
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL isCountry = (textField == self.countryCityTextField && self.worldCitytextField.text.length > 0);
    BOOL isWorld = (textField == self.worldCitytextField && self.countryCityTextField.text.length > 0);
    if (isCountry || isWorld) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"境内地址与境外地址不能同时填充" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet_ clickedButtonAtIndex:(NSInteger)buttonIndex {
    TSLocateView *locateView_ = (TSLocateView *)actionSheet_;
    TSLocation *location = locateView_.locate;
    LOG(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    
    [self.view endEditing:YES];
    
    if(buttonIndex == 0) {
        LOG(@"Cancel");
    }else {
        LOG(@"Select");
        if (locateView_.tag == 2014082501) {
            self.countryCityTextField.text = location.city;
        }else if (locateView_.tag == 2014082502){
            self.worldCitytextField.text = location.city;
        }
    }
    [self citySelectInit];
}

@end
