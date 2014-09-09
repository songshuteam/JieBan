//
//  AGBlacklistTableViewController.m
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGBlacklistTableViewController.h"

#import "AGJieyouModel.h"
#import "AGBlacklistTableViewCell.h"

@interface AGBlacklistTableViewController ()

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *removeBlackListArr;
@property (strong, nonatomic) UIBarButtonItem *managerBtn;
@property (strong, nonatomic) UIBarButtonItem *removerBtn;

@end

@implementation AGBlacklistTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.removeBlackListArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.managerBtn = [[UIBarButtonItem alloc] initWithTitle:@"解除" style:UIBarButtonItemStyleDone target:self action:@selector(managerBlackList:)];
    self.removerBtn = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(removeBlackList:)];
    self.navigationItem.rightBarButtonItem = self.managerBtn;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    AGJieyouModel *model = [[AGJieyouModel alloc] init];
    model.nickname = @"hellp 黄金大环境阿三";
    model.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model.signature = @"啊大家哈记得哈快打开机打卡";
    
    AGJieyouModel *model1 = [[AGJieyouModel alloc] init];
    model1.nickname = @"hellp 黄";
    model1.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model1.signature = @"啊大adsda阿大声道";
    
    [self.dataArr addObject:model];
    [self.dataArr addObject:model1];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)managerBlackList:(id)sender{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.removerBtn;
}

- (IBAction)removeBlackList:(id)sender{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.managerBtn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    AGBlacklistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AGBlacklistTableViewCell" owner:self options:nil];
        for (NSObject *obj in nib) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = (AGBlacklistTableViewCell *) obj;
            }
        }
        cell.tintColor = [UIColor colorWithRed:132.f/255 green:190.f/255 blue:60.f/255 alpha:1.f];
    }
    
    AGJieyouModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    [cell contentInitWithJieyou:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
        [self.removeBlackListArr addObject:[self.dataArr objectAtIndex:indexPath.row]];
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == YES) {
        [self.removeBlackListArr removeObject:[self.dataArr objectAtIndex:indexPath.row]];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
