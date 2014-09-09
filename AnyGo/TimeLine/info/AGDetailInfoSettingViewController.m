//
//  AGDetailInfoSettingViewController.m
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGDetailInfoSettingViewController.h"

#import "AGComplainViewController.h"

@interface AGDetailInfoSettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) BOOL isBlackOn;
@end

@implementation AGDetailInfoSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBlackOn = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"资料设置";
    [self contentDataInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentDataInit{
    self.dataArr = [NSMutableArray arrayWithArray:@[@[@1],@[@2],@[@3]]];
}

#pragma  mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArr objectAtIndex:section] count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }else if (section == 1){
        return 8.0f;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:1];
    switch (type.integerValue) {
        case 1:
            {
                cell.textLabel.text = @"加入黑名单";
                UISwitch *blackSwitch = [[UISwitch alloc] init];
                blackSwitch.onTintColor = [UIColor colorWithRed:132.f/255 green:190.f/255 blue:60.f/255 alpha:1.f];
                [blackSwitch setOn:self.isBlackOn animated:YES];
                [blackSwitch addTarget:self action:@selector(blackValueChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = blackSwitch;
            }
            break;
        case 2:
            {
                cell.textLabel.text = @"投诉";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 3:
            {
                UIView *view = [cell viewWithTag:2014090705];
                if (view) {
                    [view removeFromSuperview];
                }
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 2014090705;
                btn.frame = CGRectMake(10, 0, 300, 44);
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
                [btn setTitle:@"取消关注" forState:UIControlStateNormal];
                [cell addSubview:btn];
            }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (type.integerValue == 2) {
//        投诉
        AGComplainViewController *viewController = [[AGComplainViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (IBAction)blackValueChange:(id)sender{
    UISwitch *blacklist = (UISwitch *)sender;
    BOOL isOn = blacklist.isOn;
    if (isOn) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"加入黑名单，你将不再受到对方的消息，并且你们相互看不到对方结友圈的更新" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
    }else{
//        移除黑名单
    }
}

#pragma mark --
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
//        移动到黑名单
        
    }else if (buttonIndex == 2){
//        取消
        [self.tableView reloadData];
    }
}
@end
