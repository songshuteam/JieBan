//
//  AGDetailInfoViewController.m
//  shareTime
//
//  Created by tony on 7/20/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGDetailInfoViewController.h"
#import "AGDetailBaseTableViewCell.h"
#import "AGPhotoAblumTableViewCell.h"

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
    self.navigationItem.title = @"详细资料";
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
            height = 85;
            break;
        case DetailInfoTypeDeclaration:
            height = 44;
            break;
        case DetailInfoTypePhotoAlbum:
            height = 90;
            break;
        case DetailInfoTypeAge:
        case DetailInfoTypeSendMessage:
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
                }
                
                [cell contentViewByUserInfo:@"userInfo"];
                
                return cell;
            }
            break;
        case DetailInfoTypeAge:
            {
                static NSString *identify = @"ageIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                }
                cell.textLabel.text = @"年龄";
                cell.detailTextLabel.text = @"99岁";
                
                return cell;
            }
            break;
        case DetailInfoTypeDeclaration:
            {
                static NSString *identify = @"declarationIdentify";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                }
                cell.textLabel.text = @"个性签名";
                cell.detailTextLabel.text = @"个性签名个性签名个性签名个性签名个性签名个性签名个性签名个性签名个性签名";
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
                    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    sendBtn.tag = 2014072001;
                    
                    cell.backgroundColor = [UIColor clearColor];
                    [cell addSubview:sendBtn];
                }
                
                UIButton *sendBtn = (UIButton *)[cell viewWithTag:2014072001];
                sendBtn.frame = CGRectMake(10, 20, 300, 44);
                [sendBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
                [sendBtn addTarget:self action:@selector(sendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
    }
    
    return nil;
}

- (IBAction)sendMessageBtnClick:(id)sender{
    
}

#pragma mark - data init
- (void)detailInfoInit{
    self.dataArr = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInteger:DetailInfoTypeBase],[NSNumber numberWithInteger:DetailInfoTypeAge],[NSNumber numberWithInteger:DetailInfoTypeDeclaration],[NSNumber numberWithInteger:DetailInfoTypePhotoAlbum]]];
}
@end
