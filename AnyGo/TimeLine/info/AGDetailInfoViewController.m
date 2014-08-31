//
//  AGDetailInfoViewController.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGDetailInfoViewController.h"

#import "AGJieyouModel.h"

#import "AGDetailBaseTableViewCell.h"
#import "AGPhotoAblumTableViewCell.h"
#import "AGSinglePhotoViewController.h"

#import "ChatViewController.h"

/**
 *  街友详细信息的页面item
 */
typedef NS_ENUM(NSInteger, DetailInfoType) {
    /**
     *  基础信息，包括头像，昵称，性别
     */
    DetailInfoTypeBase,
    /**
     *  年龄
     */
    DetailInfoTypeAge,
    /**
     *  个性签名
     */
    DetailInfoTypeDeclaration,
    /**
     *  相册
     */
    DetailInfoTypePhotoAlbum,
    /**
     *  发消息
     */
    DetailInfoTypeSendMessage
};

@interface AGDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) AGJieyouModel *userInfo;
@end

@implementation AGDetailInfoViewController

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
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"详细资料";
    [self detailInfoInit];
    
//    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [self.dataArr objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    
    switch (type.integerValue) {
        case DetailInfoTypeBase:
            height = [AGDetailBaseTableViewCell heightForCell];
            break;
        case DetailInfoTypePhotoAlbum:
            height = [AGPhotoAblumTableViewCell heightForCell];
            break;
        case DetailInfoTypeSendMessage:
            height = 44 + 19*2;
            break;
        case DetailInfoTypeDeclaration:
        case DetailInfoTypeAge:
        default:
            height = 44;
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [self.dataArr objectAtIndex:indexPath.row];
    
    switch (type.integerValue) {
        case DetailInfoTypeBase:
            {
               static NSString *identify = @"baseIdentify";
                AGDetailBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[AGDetailBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.separatorInset = UIEdgeInsetsZero;
                [cell contentViewByUserInfo:self.userInfo];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
            break;
        case DetailInfoTypeAge:
            {
                static NSString *identify = @"ageIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.textLabel.text = @"年龄";
                cell.textLabel.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1];
                cell.detailTextLabel.text = @"99岁";
                cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
                cell.detailTextLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:66.0/255.0 blue:72.0/255.0 alpha:1];
                
                return cell;
            }
            break;
        case DetailInfoTypeDeclaration:
            {
                static NSString *identify = @"declarationIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.textLabel.text = @"个性签名";
                cell.textLabel.textColor = [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1];
                cell.detailTextLabel.text = @"个性签名个性签名";
                cell.detailTextLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:66.0/255.0 blue:72.0/255.0 alpha:1];
                cell.detailTextLabel.numberOfLines = 2;
                
                return cell;
            }
            break;
        case DetailInfoTypePhotoAlbum:
            {
                static NSString *identify = @"photoIdentify";
                AGPhotoAblumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[AGPhotoAblumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                }
                cell.separatorInset = UIEdgeInsetsZero;
                
                [cell contentViewInit:@""];
                
                return cell;
            }
            break;

        case DetailInfoTypeSendMessage:
            {
                static NSString *identify = @"sendMessageIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sendBtn.tag = 2014072001;
                    
                    cell.backgroundColor = [UIColor clearColor];
                    [cell addSubview:sendBtn];
                }
                
                UIEdgeInsets inset = cell.separatorInset;
                inset.left = 320;
                cell.separatorInset = inset;
                
                UIButton *sendBtn = (UIButton *)[cell viewWithTag:2014072001];
                sendBtn.frame = CGRectMake(10, 19, 300, 44);
                [sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_lightBlue"] forState:UIControlStateNormal];
                [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
                [sendBtn addTarget:self action:@selector(sendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.backgroundColor = [UIColor clearColor];
                
                return cell;
            }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSNumber *type = [self.dataArr objectAtIndex:indexPath.row];
    if (type.intValue == DetailInfoTypePhotoAlbum) {
        AGSinglePhotoViewController *viewController = [[AGSinglePhotoViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (IBAction)sendMessageBtnClick:(id)sender{
    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%lld",self.userId]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - data init
- (void)detailInfoInit{
    self.dataArr = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInteger:DetailInfoTypeBase],[NSNumber numberWithInteger:DetailInfoTypeAge],[NSNumber numberWithInteger:DetailInfoTypeDeclaration],[NSNumber numberWithInteger:DetailInfoTypePhotoAlbum],[NSNumber numberWithInteger:DetailInfoTypeSendMessage]]];
}
@end
