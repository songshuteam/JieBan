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
#import "ChineseToPinyin.h"
#import <UIImageView+WebCache.h>
#import "AGAddFriendViewController.h"

@interface AGFriendListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate,ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *jieyouArr;
@property (strong, nonatomic) NSMutableArray *filterArr;
@property (strong, nonatomic) NSMutableArray *collationArr;
@property (strong, nonatomic) ASIHTTPRequest *request;

@end

@implementation AGFriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.jieyouArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.filterArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.collationArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchDisplayController.searchBar.bounds));
    self.title = @"结友";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加结友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriend:)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self dataDealWithIndex];
    long long userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    self.request = [ASIHTTPRequest requestWithURL:[AGUrlManager urlGetFriendList:[NSString stringWithFormat:@"%lld",userId] pageIndex:0 pageSize:200]];
    self.request.delegate = self;
    [self.request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic = [request.responseString JSONValue];
    if ([[dic objectForKey:@"status"] intValue] == 200) {
        NSArray *arr = [dic objectForKey:@"list"];
        
        NSMutableArray *valueArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0, sum = [arr count]; i < sum; i++) {
            NSDictionary *valueDic = [arr objectAtIndex:i];
            AGJieyouModel *jieyou = [AGJieyouModel parseJsonInfo:valueDic];
            [valueArr addObject:jieyou];
        }
        
        self.jieyouArr = valueArr;
        [self dataDealWithIndex];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{

}

- (void)dataDealWithIndex{
    AGJieyouModel *model = [[AGJieyouModel alloc] init];
    model.nickname = @"hellp 黄金大环境阿三";
    model.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model.signature = @"啊大家哈记得哈快打开机打卡";
    
    AGJieyouModel *model1 = [[AGJieyouModel alloc] init];
    model1.nickname = @"h黄";
    model1.headUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    model1.signature = @"啊大adsda阿大声道";
    [self.jieyouArr addObject:model];
    [self.jieyouArr addObject:model1];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *sortSection = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    self.collationArr = [NSMutableArray arrayWithArray:[collation sectionIndexTitles]];
    
    for (NSInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [sortSection addObject:[NSMutableArray array]];
    }
    
    for (int i=0; i<[self.jieyouArr count]; i++) {
        AGJieyouModel *model = [self.jieyouArr objectAtIndex:i];
        
        NSString *chara = [ChineseToPinyin pinyinFromChineseString:model.nickname];
         NSInteger index = [collation sectionForObject:chara collationStringSelector:@selector(description)];
        
        [[sortSection objectAtIndex:index] addObject:model];
    }
    
    for (int i = 0; i < [sortSection count]; i++) {
        if ([[sortSection objectAtIndex:i] count]<= 0) {
            [sortSection removeObjectAtIndex:i];
            [self.collationArr removeObjectAtIndex:i];
            i--;
        }
    }
    
    self.dataArr = sortSection;
}

#pragma mark --
- (IBAction)addFriend:(id)sender{
    AGAddFriendViewController *viewcontroller = [[AGAddFriendViewController alloc] init];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma mark - delegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.collationArr];
    }else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if ([self.dataArr objectAtIndex:section] > 0) {
            return [self.collationArr objectAtIndex:section];
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
        return index - 1; // -1 because we add the search symbol
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
    viewController.userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    viewController.friendId = model.jieyouId;
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
