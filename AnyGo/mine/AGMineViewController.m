//
//  AGMineViewController.m
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGMineViewController.h"
#import "AGMineInfoView.h"

#import "AGPlanModel.h"
#import "AGShareItem.h"

#import "AGCompanyDemandCell.h"
#import "AGPhotoLineTableViewCell.h"

#import "AGAddTimeShareViewController.h"
#import "AGPersonInfoViewController.h"
#import "AGSettingViewController.h"
#import "AGFriendListViewController.h"
#import "AGRequestManager.h"

@interface AGMineViewController ()<AGMineInfoDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) AGMineInfoView *mineInfoView;
@property (nonatomic, strong) AGJieyouModel *jieyouModel;


@end

@implementation AGMineViewController

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

    self.mineInfoView = [[AGMineInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 84)];
    self.mineInfoView.delegate = self;
    self.tableview.tableHeaderView = self.mineInfoView;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.allowsSelection = NO;
    self.title = @"我的";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(mineSetting:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AGJieyouModel *jieyou = [[AGJieyouModel alloc] init];
    jieyou.nickname = @"拧成4附近妇科";
    jieyou.gender = GenderMale;
    jieyou.signature = @"fakf阿迪就卡机打卡机戴尔偶偶企鹅dhjahdauoqrqr";
    
    self.jieyouModel = jieyou;
    [self.mineInfoView contentInitWithJieyou:self.jieyouModel];
    
    [self requestDataInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Btn Click
- (IBAction)mineSetting:(id)sender{
    AGSettingViewController *viewController = [[AGSettingViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)mineInfoView:(AGMineInfoView *)infoView mineInfoType:(MineInfoType)type{
    switch (type) {
        case MineInfoTypeAddFriend:
            {
                AGFriendListViewController *viewController = [[AGFriendListViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case MineInfoTypePersonInfo:
            {
                AGPersonInfoViewController *viewController = [[AGPersonInfoViewController alloc] init];
                viewController.userId = self.jieyouModel.jieyouId;
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case MineInfoTypePostMsg:
            {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
                [sheet showFromTabBar:self.tabBarController.tabBar];
            }
            break;
        default:
            break;
    }
}

#pragma mark -- UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 || buttonIndex == 1) {
        AGAddTimeShareViewController *viewController = [[AGAddTimeShareViewController alloc] init];
        viewController.isFromOther = YES;
        viewController.selectType = buttonIndex;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    NSObject *object = [self.dataArr objectAtIndex:section];
    if ([object isKindOfClass:[AGJiebanPlanModel class]]) {
        count = 1;
    }else{
        NSArray *arr = (NSArray *)object;
        count = [arr count];
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    NSObject *object = [self.dataArr objectAtIndex:indexPath.section];
    if ([object isKindOfClass:[AGJiebanPlanModel class]]) {
        height = [AGCompanyDemandCell heightForCell:(AGJiebanPlanModel *)object];
    }else{
        NSArray *itemArr = (NSArray *)object;
        AGShareItem *shareItm = [itemArr objectAtIndex:indexPath.row];
        height = [AGPhotoLineTableViewCell heightForCell:shareItm];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *object = [self.dataArr objectAtIndex:indexPath.section];
    if ([object isKindOfClass:[AGJiebanPlanModel class]]) {
        static NSString *identify = @"needIdentify";
        
        AGCompanyDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AGCompanyDemandCell" owner:self options:nil];
            for (NSObject *obj in nib) {
                if ([obj isKindOfClass:[UITableViewCell class]]) {
                    cell = (AGCompanyDemandCell *) obj;
                }
            }
        }
        
        [cell contentInfoWithModel:(AGJiebanPlanModel *)object];
        
        return cell;
        
    }else{
        NSArray *itemArr = (NSArray *)object;
        AGShareItem *shareItem = [itemArr objectAtIndex:indexPath.row];
        
        static NSString *shareIdentify = @"shareIdentify";
        AGPhotoLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shareIdentify];
        
        if (cell == nil) {
            cell = [[AGPhotoLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareIdentify];
        }
        [cell contentInfoWithModel:shareItem];
        
        return cell;
    }
    
    return nil;
}

#pragma mark -- 
- (void)requestDataInit{
    long long userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    ASIHTTPRequest *request = [AGRequestManager requestFeedWithUserId:[NSString stringWithFormat:@"%lld",userId] pageSize:20 lastId:@"0"];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [request.responseString JSONValue];
    if ([[valueDic objectForKey:@"status"] integerValue] == 200) {
        NSArray *list = [valueDic objectForKey:@"list"];
        NSMutableArray *shareArr = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in list) {
            AGShareItem *item = [AGShareItem parseJsonInfo:dic];
            [shareArr addObject:item];
        }
        [self.dataArr addObject:shareArr];
    }
    
    [self.tableview reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [self.view makeToast:@"网络有问题，请检查网络"];
}

- (void)contenDataInit{
    
    AGJiebanPlanModel *model = [[AGJiebanPlanModel alloc] init];
    model.startTime = @"2014-09-29";
    model.days = @"20";
    model.isDriver = YES;
    model.isCanDiscuss = NO;
    model.isGoHome = NO;
    model.femaleNum = 23;
    model.maleNum = 10;
    AGPlanModel *plan = [[AGPlanModel alloc] init];
    plan.location = @"北京";
    plan.desc = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目";
    
    AGPlanModel *plan1 = [[AGPlanModel alloc] init];
    plan1.location = @"昆明";
    plan1.desc = @"目的地阿哥的骄傲和大家阿三目的地阿发酵后发生金额和非金属哥的骄傲和大家阿目";
    AGPlanModel *plan2 = [[AGPlanModel alloc] init];
    plan2.location = @"大理";
    plan2.desc = @"目的地阿哥的骄傲和肺结核和大家阿目";
    AGPlanModel *plan3 = [[AGPlanModel alloc] init];
    plan3.location = @"梅林雪上";
    plan3.desc = @"目的地开始交电费阿目";
    
    model.plansArr = @[plan,plan1,plan2,plan3];
    
    
    AGShareItem *shareItem1 = [[AGShareItem alloc] init];
    shareItem1.shareContent = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大";
    shareItem1.timeStamp = [NSDate date];
    shareItem1.sharePhotos = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg"];
    
    AGShareItem *shareItem2 = [[AGShareItem alloc] init];
    shareItem2.shareContent = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿";
    shareItem2.timeStamp = [NSDate date];
    shareItem2.sharePhotos = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg"];
    
    AGShareItem *shareItem3 = [[AGShareItem alloc] init];
    shareItem3.shareContent = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲";
    shareItem3.timeStamp = [NSDate date];
    shareItem3.sharePhotos = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg"];
    
    AGShareItem *shareItem4 = [[AGShareItem alloc] init];
    shareItem4.shareContent = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿";
    shareItem4.timeStamp = [NSDate date];
    shareItem4.sharePhotos = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg"];
    
    [self.dataArr addObject:model];
    [self.dataArr addObject:@[shareItem1,shareItem2,shareItem3,shareItem4]];
    [self.tableview reloadData];
    
}

@end
