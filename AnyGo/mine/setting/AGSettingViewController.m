//
//  AGSettingViewController.m
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGSettingViewController.h"

#import "AGFeedbackViewController.h"
#import "AGBlacklistTableViewController.h"

typedef NS_ENUM(NSInteger, settingItem) {
    settingItemAbout,
    settingItemMark,
    settingItemHelp,
    settingItemBlacklist,
    settingItemLogout
};

@interface AGSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation AGSettingViewController

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
    [self dataArrInit];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataArrInit{
    self.dataArr = [NSMutableArray arrayWithObjects:@[[NSNumber numberWithInteger:settingItemAbout]],@[[NSNumber numberWithInteger:settingItemMark]],@[[NSNumber numberWithInteger:settingItemHelp]],@[[NSNumber numberWithInteger:settingItemBlacklist]],@[[NSNumber numberWithInteger:settingItemLogout]], nil];
}

#pragma mark -- delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == [self.dataArr count] - 1) {
        return 20;
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (type.integerValue) {
        case settingItemAbout:
            cell.textLabel.text = @"关于结伴行";
            break;
        case settingItemMark:
            cell.textLabel.text = @"给结伴行评分";
            break;
        case settingItemHelp:
            cell.textLabel.text = @"帮助与反馈";
            break;
        case settingItemBlacklist:
            cell.textLabel.text = @"黑名单";
            break;
        case settingItemLogout:
            {
                static NSString *logoutIdentifier = @"logoutIdentifier";
                UITableViewCell *logoutCell = [tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
                
                if (!logoutCell) {
                    logoutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setFrame: CGRectMake(10, 0, 300, 44)];
                    button.tag = 2014090701;
                    
                    [logoutCell addSubview:button];
                }
                
                UIEdgeInsets inset = logoutCell.separatorInset;
                inset.left = 320;
                logoutCell.separatorInset = inset;
                
                UIButton *btn = (UIButton *)[logoutCell viewWithTag:2014090701];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"退出登录" forState:UIControlStateNormal];
                
                logoutCell.backgroundColor = [UIColor clearColor];
                
                
                return logoutCell;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    switch (type.integerValue) {
        case settingItemAbout:
            
            break;
        case settingItemMark:
            
            break;
        case settingItemHelp:
            {
                AGFeedbackViewController *viewController = [[AGFeedbackViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case settingItemBlacklist:
            {
                AGBlacklistTableViewController *viewController = [[AGBlacklistTableViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        default:
            break;
    }
}

- (IBAction)logout:(id)sender{
    
}
@end
