//
//  AGSearchFriendListViewController.m
//  AnyGo
//
//  Created by tony on 9/21/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGSearchFriendListViewController.h"
#import "AGJieyouModel.h"
#import "AGDetailInfoViewController.h"
#import "AGFriendTableViewCell.h"

@interface AGSearchFriendListViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation AGSearchFriendListViewController

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self requestDataInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestDataInit{
    long long userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    NSInteger index = [self.dataArr count]/20 + 1;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[AGUrlManager urlSearchUserInfo:[NSString stringWithFormat:@"%lld",userId] keyWord:self.keyWord pageSize:20 pageIndex:index]];
    request.delegate = self;
    [request startAsynchronous];
}

#pragma mark -- request delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic = [request.responseString JSONValue];
    if ([[dic objectForKey:@"status"] intValue] == 200) {
        NSArray *listArr = [dic objectForKey:@"list"];
        NSMutableArray *valueArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *valueDic in listArr) {
            AGJieyouModel *jieyou = [AGJieyouModel parseJsonInfo:valueDic];
            [valueArr addObject:jieyou];
        }
        if ([self.dataArr count] > 0) {
            [self.dataArr addObjectsFromArray:valueArr];
        }else{
            self.dataArr = valueArr;
        }
    }
    
    if ([self.dataArr count] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 150, 50)];
        label.text = @"    未搜索到相关人员，请返回重新搜索";
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        self.tableView.tableHeaderView = label;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [self.view makeToast:@"网络有问题，请重新请求！"];
}

#pragma mark -- UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [self.dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    AGFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AGFriendTableViewCell" owner:self options:nil];
        for (NSObject *obj in nib) {
            if ([obj isKindOfClass:[UITableViewCell class]]) {
                cell = (AGFriendTableViewCell *) obj;
            }
        }
    }
    AGJieyouModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell contentWithJieyou:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AGJieyouModel *model = [self.dataArr objectAtIndex:indexPath.row];

    AGDetailInfoViewController *viewController = [[AGDetailInfoViewController alloc] init];
    viewController.relation = model.relation;
    viewController.userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    viewController.friendId = model.jieyouId;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
