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

@interface AGPlaViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;


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
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect topViewFrame = self.topView.frame;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewFrame.size.height, bounds.size.width, bounds.size.height - self.topView.frame.size.height - 20.f -44.f) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(beBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"+加目的地"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addAddress:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    self.dataSource = [NSMutableArray new];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.dataSource count] == 0) {
        self.showLineView.hidden = YES;
    }else {
        self.showLineView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateButtonClicked:(id)sender {
}

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

- (IBAction)endAddressButtonClicked:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" andLocationType:self.locateType delegate:self];
    [locateView showInView:self.view];
}

#pragma mark - Utility Methods

- (void)addAddress:(id)sender {
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

- (void)beBack:(id)sender {
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
    
    AGAllPlanModel *allPlan = [[AGAllPlanModel alloc] init];
    allPlan.days = self.daysTextField.text;
    allPlan.beginDate = self.dateLabel.text;
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    AGPlanModel *startModel = [[AGPlanModel alloc] init];
    startModel.type = 0;
    startModel.address = self.startAddress.text;
    startModel.planDescription = self.startTextView.text;
    [tmpArray addObject:startModel];
    
    AGPlanModel *endModel = [[AGPlanModel alloc] init];
    endModel.type = 1;
    endModel.address = self.endAddress.text;
    endModel.planDescription = self.endTextView.text;
    [tmpArray addObject:endModel];
    
    if ([self.dataSource count] > 0) {
        [tmpArray addObjectsFromArray:self.dataSource];
    }
    allPlan.plans = tmpArray;
    self.distributeViewController.allPlan = allPlan;
    
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
    cell.addressLable.text = plan.address;
    cell.planTextView.text = plan.planDescription;
    if (row == [self.dataSource count] - 1) {
        cell.breakLine.hidden = YES;
    }else {
        cell.breakLine.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    LOG(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    //You can uses location to your application.
    if(buttonIndex == 0) {
        LOG(@"Cancel");
    }else {
        LOG(@"Select");
        self.endAddress.text = location.city;
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
