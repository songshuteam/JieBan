//
//  AGPhoneCodeSelectViewController.m
//  AnyGo
//
//  Created by tony on 7/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPhoneCodeSelectViewController.h"

#import "NSObject+NSJSONSerialization.h"

#import "AGLSModel.h"

@interface AGPhoneCodeSelectViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, copy) NSArray *areaCodes;
@property (nonatomic, copy) NSArray *filterAreaCode;
@property (nonatomic, copy) NSArray *sections;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *filterSearchDisplayController;

@end

@implementation AGPhoneCodeSelectViewController

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
    // Do any additional setup after loading the view.
    self.areaCodes = [[NSMutableArray alloc] initWithCapacity:0];
    self.filterAreaCode = [[NSMutableArray alloc] initWithCapacity:0];
    self.sections = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self loadViewUI];
    [self loadDataFromFile];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (animated) {
        [self.tableView flashScrollIndicators];
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchBar.frame animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - init View Info
- (void)loadViewUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    // The search bar is hidden when the view becomes visible the first time
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    self.filterSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.filterSearchDisplayController.searchResultsDataSource = self;
    self.filterSearchDisplayController.searchResultsDelegate = self;
    self.filterSearchDisplayController.delegate = self;

}

- (void)loadDataFromFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countryPhones" ofType:@"json"];
    
    NSString *jsonInfo = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *jsonArr = [jsonInfo JSONValue];
    
    NSMutableArray *areaArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in jsonArr) {
        AGLSAreaCodeModel *model = [[AGLSAreaCodeModel alloc] init];
        model.country = [dic objectForKey:@"country"];
        model.countryCode = [dic objectForKey:@"country_code"];
        model.phoneCode = [dic objectForKey:@"phone_code"];
        [areaArr addObject:model];
    }
    
    self.areaCodes = areaArr;
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *sortSection = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles]count]];
    
    for (NSInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [sortSection addObject:[NSMutableArray array]];
    }
    
    for (AGLSAreaCodeModel *model in self.areaCodes) {
        NSInteger index = [collation sectionForObject:model.country collationStringSelector:@selector(description)];
        [[sortSection objectAtIndex:index] addObject:model];
    }
    
    self.sections = sortSection;
}

#pragma mark - TableView Delegate and DataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }else{
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if ([self.sections objectAtIndex:section] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.tableView) {      //the local tableView to show and UISearchDisplayViewController is other
        return [self.sections count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [[self.sections objectAtIndex:section] count];
    }else{
        return [self.filterAreaCode count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    if (tableView == self.tableView) {
        AGLSAreaCodeModel *model = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = model.country;
        cell.detailTextLabel.text = model.phoneCode;
        
    } else {
        AGLSAreaCodeModel *model = [self.filterAreaCode objectAtIndex:indexPath.row];
        cell.textLabel.text = model.country;
        cell.detailTextLabel.text = model.phoneCode;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AGLSAreaCodeModel *model = nil;
    
    if (tableView == self.tableView) {
        model  = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        model = [self.filterAreaCode objectAtIndex:indexPath.row];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWithAreaCode:)]) {
        [self.delegate selectWithAreaCode:model];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.filterAreaCode = self.areaCodes;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.filterAreaCode = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.filterAreaCode = [self.filterAreaCode filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.country contains[cd] %@", searchString]];
    
    return YES;
}

@end
