//
//  AGFriendListViewController.m
//  AnyGo
//
//  Created by tony on 9/8/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGFriendListViewController.h"

#import "AGDetailInfoViewController.h"
#import "AGJieyouModel.h"
#import <UIImageView+WebCache.h>

@interface AGFriendListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, copy) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *filterArr;

@end

@implementation AGFriendListViewController

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
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.filterArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchDisplayController.searchBar.bounds));
    self.title = @"街友";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加结友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriend:)];
    
    AGJieyouModel *model = [[AGJieyouModel alloc] init];
    model.nickname = @"hellp 黄金大环境阿三";
    model.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model.signature = @"啊大家哈记得哈快打开机打卡";
    
    AGJieyouModel *model1 = [[AGJieyouModel alloc] init];
    model1.nickname = @"hellp 黄";
    model1.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model1.signature = @"啊大adsda阿大声道";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataDealWithIndex{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *sortSection = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    
    for (NSInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [sortSection addObject:[NSMutableArray array]];
    }

}

#pragma mark --
- (IBAction)addFriend:(id)sender{
    
}

#pragma mark - delegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if ([self.dataArr objectAtIndex:section] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
        return NSNotFound;
    }else{
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return [self.dataArr count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return [[self.dataArr objectAtIndex:section] count];
    }else{
        return [self.filterArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    AGJieyouModel *model;
    if (tableView == self.tableView) {
        model = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        model = [self.filterArr objectAtIndex:indexPath.row];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
    cell.textLabel.text = model.nickname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AGJieyouModel *model;
    if (tableView == self.tableView) {
        model = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        model = [self.filterArr objectAtIndex:indexPath.row];
    }
    
    AGDetailInfoViewController *viewController = [[AGDetailInfoViewController alloc] init];
    viewController.relation = RelationFriend;
    viewController.userId = model.jieyouId;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.filterArr = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.filterArr = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    self.filterAreaCode = [self.filterAreaCode filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.country contains[cd] %@", searchString]];
    
    return YES;
}
@end
