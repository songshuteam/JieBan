//
//  AGSinglePhotoViewController.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGSinglePhotoViewController.h"

#import "AGCompanyNeedModel.h"
#import "AGShareItem.h"

#import "AGCompanyDemandCell.h"
#import "AGPhotoLineTableViewCell.h"

@interface AGSinglePhotoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation AGSinglePhotoViewController

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
    
    [self contenDataInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    NSObject *object = [self.dataArr objectAtIndex:section];
    if ([object isKindOfClass:[AGCompanyNeedModel class]]) {
        count = 1;
    }else{
        NSArray *arr = (NSArray *)object;
        count = [arr count];
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    NSObject *object = [self.dataArr objectAtIndex:indexPath.section];
    if ([object isKindOfClass:[AGCompanyNeedModel class]]) {
        height = [AGCompanyDemandCell heightForCell:(AGCompanyNeedModel *)object];
    }else{
        NSArray *itemArr = (NSArray *)object;
        AGShareItem *shareItm = [itemArr objectAtIndex:indexPath.row];
        height = [AGPhotoLineTableViewCell heightForCell:shareItm];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *object = [self.dataArr objectAtIndex:indexPath.section];
    if ([object isKindOfClass:[AGCompanyNeedModel class]]) {
        static NSString *identify = @"neddIdentify";
        
        AGCompanyDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[AGCompanyDemandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell contentInfoWithModel:(AGCompanyNeedModel *)object];
        
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

- (void)contenDataInit{
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
    shareItem4.shareContent = @"目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲目的地阿哥的骄傲和大家阿三目的地阿哥的骄傲";
    shareItem4.timeStamp = [NSDate date];
    shareItem4.sharePhotos = @[@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg",@"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg"];
    
    [self.dataArr addObject:@[shareItem1,shareItem2,shareItem3,shareItem4]];
    [self.tableView reloadData];
    
}
@end
