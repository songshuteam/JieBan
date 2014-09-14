//
//  AGPlaViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPlaViewController.h"
#import "AGPlanDestinationTableViewCell.h"
#import "AGAddressViewController.h"
#import "AGPlanModel.h"
#import "MMLocationManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AGDistributeViewController.h"

const NSInteger startAddressSelectTag = 2014080801;
const NSInteger endAddressSelectTag = 2014080802;

@interface AGPlaViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITextViewDelegate>{
    TSLocateView *locateView;
    UIActionSheet *actionSheet;
    NSDate *startDate;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *editImgBg1;
@property (weak, nonatomic) IBOutlet UIImageView *editImgBg2;

@end

@implementation AGPlaViewController

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
    
    locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" andLocationType:self.locateType delegate:self];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    [self tableViewInfoInit];
    [self contentInfoInit];
    
    [self navgationItemInit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self moreDestination];
    
    self.startTextView.delegate = self;
    self.endTextView.delegate = self;
    self.startTextView.placeholder = @"点击添加更多描述";
    self.endTextView.placeholder = @"点击添加跟多描述";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentInfoInit{
    if (self.planModel) {
        if (self.planModel.days.length > 0) {
            self.daysTextField.text = self.planModel.days;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [dateFormatter dateFromString:self.planModel.startTime];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateLabel.text = [dateFormatter stringFromDate:date];
        
        NSMutableArray *planArr = [NSMutableArray arrayWithArray:self.planModel.plansArr];
        if ([planArr count] == 1) {
            AGPlanModel *model1 = [planArr firstObject];
            self.startAddress.text = model1.location;
            self.startTextView.text = model1.desc;
        }
        if ([planArr count] >= 2) {
            AGPlanModel *model1 = [planArr firstObject];
            self.startAddress.text = model1.location;
            self.startTextView.text = model1.desc;
            [planArr removeObjectAtIndex:0];
            
            AGPlanModel *model2 = [planArr objectAtIndex:0];
            self.endAddress.text = model2.location;
            self.endTextView.text = model2.desc;
            [planArr removeObjectAtIndex:0];
            self.dataSource = planArr;
        }
        [self.tableView reloadData];
    }
    
}

#pragma mark- view init 
- (void)navgationItemInit{
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
//                                                                 style:UIBarButtonItemStylePlain
//                                                                target:self
//                                                                action:@selector(beBack:)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(planIsOk:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)tableViewInfoInit{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect topViewFrame = self.topView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewFrame.size.height, bounds.size.width, bounds.size.height - self.topView.frame.size.height - 20.f -44.f) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.dataSource = [NSMutableArray new];
}

- (void)moreDestination{
    if ([self.dataSource count] == 0) {
        self.showLineView.hidden = YES;
        self.tableView.hidden = YES;
    }else {
        self.showLineView.hidden = NO;
        self.tableView.hidden = NO;
    }
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = locateView.frame;
        rect.origin.y = CGRectGetWidth(self.view.frame);
        [locateView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [locateView removeFromSuperview];
    }];
}

#pragma mark - the start Time select
- (IBAction)dateButtonClicked:(id)sender {
    [self.view endEditing:YES];
    //点击显示时间
   actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
    UISegmentedControl *confirmButton =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    // Add the picker
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    startDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self
                action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:datePicker];
    
    CGRect pickerRect;
    pickerRect = datePicker.bounds;
    pickerRect.origin.y = -44;
    datePicker.bounds = pickerRect;
    cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 65.0f, 32.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    [cancelButton addTarget:self action:@selector(datePickerCancelClick:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:cancelButton];
    
    confirmButton.momentary = YES;
    confirmButton.frame = CGRectMake(245.0f, 7.0f, 65.0f, 32.0f);
    confirmButton.segmentedControlStyle = UISegmentedControlStyleBar;
    [confirmButton addTarget:self action:@selector(datePickerDoneClick:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:confirmButton];
    
   
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0, 320, 500)];
}

- (IBAction)datePickerDoneClick:(id)sender{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:startDate];
}

- (IBAction)datePickerCancelClick:(id)sender{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction) dateChanged:(id)sender{
    startDate = ((UIDatePicker *)sender).date;
}

#pragma mark - Get Address from GPS
- (IBAction)getAddressButtonClicked:(id)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"获取中...";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    __block __weak typeof(self) wself = self;
    [[MMLocationManager shareLocation] getAddress:^(NSString *addressString) {
        wself.startAddress.text = addressString;
        [hud hide:YES];
    }];
}

- (IBAction)startAddressBtnClick:(id)sender {
    [self.view endEditing:YES];
    
    locateView.tag = startAddressSelectTag;
    if (![locateView isShow]) {
        [locateView showInView:self.view];
    }
}

- (IBAction)endAddressButtonClicked:(id)sender {
    [self.view endEditing:YES];
  
    locateView.tag = endAddressSelectTag;
    if (![locateView isShow]) {
        [locateView showInView:self.view];
    }
}

#pragma mark - Utility Methods
- (IBAction)addAddress:(id)sender {
    if (self.endAddress.text == nil || [self.endAddress.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请先填写第一个目的地"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    AGAddressViewController *addVc = [[AGAddressViewController alloc] initWithNibName:@"AGAddressViewController" bundle:nil];
    addVc.planViewController = self;
    [self presentViewController:addVc animated:YES completion:nil];
}

- (void)planIsOk:(id)sender {
    BOOL canExite = YES;
    NSString *msg = nil;
    if (self.dateLabel.text == nil || [self.dateLabel.text isEqualToString:@""]) {
        msg = @"出发日期";
        canExite = NO;
    }
    if (self.startAddress.text == nil || [self.startAddress.text isEqualToString:@""]) {
        msg = @"出发地点";
        canExite = NO;
    }
    if (self.daysTextField.text == nil || [self.daysTextField.text isEqualToString:@""]) {
        msg = @"总计天数";
        canExite = NO;
    }
    if (self.endAddress.text == nil || [self.endAddress.text isEqualToString:@""]) {
        msg = @"目的地";
        canExite = NO;
    }
    if (!canExite) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"%@还没填写，将无法发布，你确定要离开吗？",msg]
                                                       delegate:self
                                              cancelButtonTitle:@"离开"
                                              otherButtonTitles:@"继续填写", nil];
        [alert show];
        return;
    }
    
    AGJiebanPlanModel *jiebanPlan = [[AGJiebanPlanModel alloc] init];
    jiebanPlan.days = self.daysTextField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    jiebanPlan.startTime = [dateFormatter stringFromDate:startDate];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    AGPlanModel *startModel = [[AGPlanModel alloc] init];
    startModel.type = 0;
    startModel.location = self.startAddress.text;
    startModel.desc = self.startTextView.text;
    [tmpArray addObject:startModel];
    
    AGPlanModel *endModel = [[AGPlanModel alloc] init];
    endModel.type = 1;
    endModel.location = self.endAddress.text;
    endModel.desc = self.endTextView.text;
    [tmpArray addObject:endModel];
    
    if ([self.dataSource count] > 0) {
        [tmpArray addObjectsFromArray:self.dataSource];
    }
    jiebanPlan.plansArr = tmpArray;
    self.distributeViewController.jiebanModel = jiebanPlan;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAddressToPlan:(AGPlanModel *)plan {
    [self.dataSource addObject:plan];
    [self.tableView reloadData];
}

#pragma mark - Tableview delegate / datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AboutCellIdentifier = @"AboutCell";
    AGPlanDestinationTableViewCell *cell = (AGPlanDestinationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AGPlanDestinationTableViewCell" owner:self options:nil];
        for (NSObject *obj in nib) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = (AGPlanDestinationTableViewCell *) obj;
            }
        }
    }
    NSInteger row = [indexPath row];
    AGPlanModel *plan = self.dataSource[row];
    cell.addressLable.text = plan.location;
    cell.planTextView.text = plan.desc;
    if (row == [self.dataSource count] - 1) {
        cell.breakLine.hidden = YES;
    }else {
        cell.breakLine.hidden = NO;
    }
    cell.deletePlanDestBtn.tag = row;
    [cell.deletePlanDestBtn addTarget:self action:@selector(deletePlanDestribute:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (IBAction)deletePlanDestribute:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)btn.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self moreDestination];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet_ clickedButtonAtIndex:(NSInteger)buttonIndex {
    TSLocateView *locateView_ = (TSLocateView *)actionSheet_;
    TSLocation *location = locateView_.locate;
    LOG(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    if(buttonIndex == 0) {
        LOG(@"Cancel");
    }else {
        LOG(@"Select");
        if (locateView.tag == startAddressSelectTag) {
            self.startAddress.text = location.city;
        }else if (locateView.tag == endAddressSelectTag){
            self.endAddress.text = location.city;
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark - TextViewDelegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length > 32) {
        return NO;
    }
    return YES;
}

@end



@interface UIPlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation UIPlaceHolderTextView

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
