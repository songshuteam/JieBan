//
//  AGCallOutView.m
//  AnyGo
//
//  Created by tony on 8/11/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGCallOutView.h"

typedef NS_ENUM(NSInteger, JiebanType) {
    JiebanTypeStartTime = 0,
    JiebanTypeStartAddress,
    JiebanTypeEndAddress,
    JiebanTypeDays,
    JiebanTypeISDrive,
    JiebanTypeIsDiscuss,
    JiebanTypePersonNum,
    JiebanTypeMoreInfo
};

@implementation AGCallOutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bgImg = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImg.image =  [[UIImage imageNamed:@"annotation_bg_view"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        [self addSubview:self.bgImg];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(7, 2, CGRectGetWidth(self.bounds) - 10, CGRectGetHeight(self.bounds) - 4)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        [self loadData];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)contentViewInitWithPlanInfo:(AGJiebanPlanModel *)planModel{
    self.jiebanModel = planModel;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSNumber *item = [self.dataArr objectAtIndex:indexPath.row];
    switch (item.integerValue) {
        case JiebanTypeStartTime:
        {
            cell.textLabel.text = @"出发时间:";
            cell.detailTextLabel.text = self.jiebanModel.startTime; //@"2014-06-21";
        }
            break;
        case JiebanTypeStartAddress:
        {
            cell.textLabel.text = @"出发城市:";
            cell.detailTextLabel.text = @"北京";
        }
            break;
        case JiebanTypeEndAddress:
        {
            cell.textLabel.text = @"目的地:";
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.text = [self.jiebanModel plansLocationInfo]; //@"昆明-大理-丽江-梅林雪山";
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case JiebanTypeDays:
        {
            cell.textLabel.text = @"总计:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@天", self.jiebanModel.days];
        }
            break;
        case JiebanTypeISDrive:
        {
            cell.textLabel.text = @"是否自驾:";
            cell.detailTextLabel.text = self.jiebanModel.isDriver ? @"是" : @"否";
        }
            break;
        case JiebanTypeIsDiscuss:
        {
            cell.textLabel.text = @"行程是否可商议:";
            cell.detailTextLabel.text = self.jiebanModel.isCanDiscuss ? @"是" : @"否";
        }
            break;
        case JiebanTypePersonNum:
        {
            cell.textLabel.text = @"当前人数:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"女 %d 人 男 %d 人", self.jiebanModel.femaleNum, self.jiebanModel.maleNum]; //@"女99人 男77人";
        }
            break;
        case JiebanTypeMoreInfo:
        {
            cell.textLabel.text = @"点击了解详情";
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.frame = cell.bounds;
            cell.textLabel.center = cell.center;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:63.0f/255.0f green:66.0f/255.0f blue:72.0f/255.0f alpha:1];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSNumber *number = [self.dataArr objectAtIndex:indexPath.row];
    if (number.integerValue == JiebanTypeMoreInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(callOutView:showUserInfoWithUserId:)]) {
            [self.delegate callOutView:self showUserInfoWithUserId:122334354];
        }
    }
}

- (void)loadData{
    
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self.dataArr addObjectsFromArray:@[[NSNumber numberWithInteger:JiebanTypeStartTime],
                                        [NSNumber numberWithInteger:JiebanTypeStartAddress],
                                        [NSNumber numberWithInteger:JiebanTypeEndAddress],
                                        [NSNumber numberWithInteger:JiebanTypeDays],
                                        [NSNumber numberWithInteger:JiebanTypeISDrive],
                                        [NSNumber numberWithInteger:JiebanTypeIsDiscuss],
                                        [NSNumber numberWithInteger:JiebanTypePersonNum],
                                        [NSNumber numberWithInteger:JiebanTypeMoreInfo]]];
    [self.tableView reloadData];
}


@end
