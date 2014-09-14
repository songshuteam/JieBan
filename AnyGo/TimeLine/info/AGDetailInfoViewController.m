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
#import "AGDetailInfoSettingViewController.h"

#import "ChatViewController.h"
#import <MBProgressHUD.h>

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

@interface AGDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
     MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) AGUserInfoModel *userInfo;

@property (strong, nonatomic) ASIHTTPRequest *request;
@end

@implementation AGDetailInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.relation = RelationNotFriend;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详细资料";
    [self detailInfoInit];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    NSURL *url = [AGUrlManager urlGetUserInfo:[NSString stringWithFormat:@"%lld",self.friendId] ownId:[NSString stringWithFormat:@"%lld",self.userId]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    self.request.delegate = self;
    [self.request startAsynchronous];
    
    if (self.relation == RelationFriend) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStyleDone target:self action:@selector(friendInfoSetting:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.request clearDelegatesAndCancel];
}

- (IBAction)friendInfoSetting:(id)sender{
    AGDetailInfoSettingViewController *viewController = [[AGDetailInfoSettingViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
//                cell.detailTextLabel.text = self.userInfo.;
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
                cell.detailTextLabel.text = self.userInfo.signature;
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
                
                [cell contentViewInit:self.userInfo];
                
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
                if (self.relation == RelationNotFriend) {
                    [sendBtn setTitle:@"加关注" forState:UIControlStateNormal];
                }else{
                    [sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
                }
                
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
    if (self.relation == RelationFriend) {
        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%lld",self.friendId]];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
//        加关注
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
        [hud show:YES];
        
        self.request = [ASIHTTPRequest requestWithURL:[AGUrlManager urlChangeRelation:[NSString stringWithFormat:@"%lld", self.userId] friendId:[NSString stringWithFormat:@"%lld",self.friendId] relationType:2]];
        self.request.didFinishSelector = @selector(requestRelationFinished:);
        self.request.timeOutSeconds = 10;
        [self.request startAsynchronous];
    }
}

#pragma mark -- 
- (void)requestRelationFinished:(ASIHTTPRequest *)request{
    [hud hide:YES];
    NSDictionary *dic = [request.responseString JSONValue];
    if ([[dic objectForKey:@"status"] intValue] == 200) {
        int relation = [[dic objectForKey:@"relation"] intValue];
        self.relation = RelationFriend;
        [self detailInfoInit];
        [self.tableView reloadData];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic = [request.responseString JSONValue];
    if ([[dic objectForKey:@"status"] intValue] == 200) {
        NSDictionary *dicValue = [dic objectForKey:@"obj"];
        AGUserInfoModel *model = [AGUserInfoModel parseJsonInfo:dicValue];
        self.userInfo = model;
        [self.tableView reloadData];
    }
}

#pragma mark - data init
- (void)detailInfoInit{
    if (self.relation == RelationNotFriend) {
        self.dataArr = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInteger:DetailInfoTypeBase],[NSNumber numberWithInteger:DetailInfoTypeAge],[NSNumber numberWithInteger:DetailInfoTypeDeclaration],[NSNumber numberWithInteger:DetailInfoTypeSendMessage]]];
    }else if(self.relation == RelationFriend){
         self.dataArr = [NSMutableArray arrayWithArray:@[[NSNumber numberWithInteger:DetailInfoTypeBase],[NSNumber numberWithInteger:DetailInfoTypeAge],[NSNumber numberWithInteger:DetailInfoTypeDeclaration],[NSNumber numberWithInteger:DetailInfoTypePhotoAlbum],[NSNumber numberWithInteger:DetailInfoTypeSendMessage]]];
    }
}
@end
