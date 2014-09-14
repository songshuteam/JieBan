//
//  AGShareViewController.m
//  timeLine
//
//  Created by tony on 14-7-9.
//  Copyright (c) 2014年 zjx. All rights reserved.
//

#import "AGShareViewController.h"

#import "AGShareItem.h"
#import "AGShareCommentItem.h"
#import "AGShareTableViewCell.h"
#import "AGAddTimeShareViewController.h"

#import "DEYChatInputTextView.h"
#import "AGShowCommentView.h"

#import "AGDetailInfoViewController.h"

@interface AGShareViewController ()<UITableViewDelegate, UITableViewDataSource,HPGrowingTextViewDelegate,AGShareTableViewCellDelegate>{
    BOOL isMainComment;
    int replayIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic)  AGShareItem *currentItem;

@property (strong, nonatomic) AGShowCommentView *commentView;
@property (strong, nonatomic) DEYChatInputTextView *commentInputTextView;

//- (void)addCommentTextView;
- (void)removeCommentTextView;
@end

@implementation AGShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isMainComment = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dataFromDemo];
    
    self.tableView.allowsSelection = FALSE;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addShareTimeInfo:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)loadShareData{
    
}

- (IBAction)addShareTimeInfo:(id)sender {
    AGAddTimeShareViewController *viewController = [[AGAddTimeShareViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AGShareItem *item = [self.dataArray objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"identifier";
    AGShareTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[AGShareTableViewCell alloc] init];
        cell.delegate = self;
    }
    
    cell.shareItem = item;
    [cell setCellContent:item];
    [cell.commentBtn addTarget:self action:@selector(viewForCommentSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGShareItem * data=[self.dataArray objectAtIndex:indexPath.row];
    return [AGShareTableViewCell getHeightByShareItem:data];
}

#pragma mark - AGShareTableViewCellDelegate
- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell commentInfo:(AGShareCommentItem *)commentItem{

}

- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell commentShareInfoId:(long long)uid{

}

- (void)shareTableViewCell:(AGShareTableViewCell *)tableViewCell timelineByUserId:(long long)userId{
    AGDetailInfoViewController *viewController = [[AGDetailInfoViewController alloc] init];
    viewController.userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    viewController.friendId = userId;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - shareline comment
- (IBAction)viewForCommentSelect:(id)sender{
//    m_isRemoveCommentView = NO;
    UIButton *replyBtn = (UIButton *)sender;
    AGShareTableViewCell *cell = (AGShareTableViewCell *)replyBtn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //判断已经存在的view是否为现在的view
    if ([self.commentView.indexPath isEqual:indexPath]) {
        [self removeCommentTextView];
        return ;
    }else{
        [self removeCommentTextView];
    }
    
    CGRect rect = CGRectMake(replyBtn.frame.origin.x, replyBtn.frame.origin.y-5, 195, 47);
    AGShowCommentView *commentView = [[AGShowCommentView alloc] initWithFrame:rect];
    self.commentView = commentView;
    
    self.commentView.indexPath = indexPath;
//    self.commentView.item = (AGShareItem *)replyBtn.m_buttonContent;
    [self.commentView.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentView.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell addSubview:self.commentView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:1.5];
    rect.origin.x -= 195;
    [self.commentView setFrame:rect];
    [UIView commitAnimations];
    [self.tableView setScrollEnabled:NO];
    
}

- (IBAction)praiseBtnClick:(id)sender{
//    GobiOribitData * gobiData = [m_arrDataSrouce objectAtIndex:self.gobiCommentView.indexPath.row];
//    if (gobiData.isPraised) {
//        return;
//    }
//    
//    m_isRemoveCommentView = NO;
//    [self insertCommentToGobiMessage:@"赞！"];
//    [self sendCommentRequest:@"赞！" isPraise:YES];
//    [self.gobiCommentView setHidden:YES];
//    gobiData.isPraised = YES;
    
}

- (IBAction)commentBtnClick:(id)sender{
//    m_isRemoveCommentView = NO;
    if ([self commentInputTextView])  return;

    [self.commentView setHidden:YES];
    [self initCommentTextView];
    
    [self.view addSubview:self.commentInputTextView];
    [self.view bringSubviewToFront:self.commentInputTextView];
    [self.commentInputTextView becomeFirstResponder];
    [self.commentInputTextView.growingTextView.internalTextView becomeFirstResponder];
}

- (void)removeCommentTextView{
    if (self.commentView) {
        [self.commentView removeFromSuperview];
        self.commentView = nil;
        [self.tableView setScrollEnabled:YES];
    }
}

#pragma mark - comment input
- (void)initCommentTextView{
    DEYChatInputTextView *inputTextView = [[DEYChatInputTextView alloc] initWithFrame:CGRectMake(0, 320, 320, 40) withInputType:ChatinputTypeText];
    
    inputTextView.growingTextView.delegate = self;
    self.commentInputTextView = inputTextView;
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:[self.commentInputTextView.growingTextView bounds]];
    if (isMainComment) {
        [placeLabel setText:[NSString stringWithFormat:@"    回复%@",self.currentItem.userName]];
    }else{
        AGShareCommentItem *comment = [self.currentItem.shareComments objectAtIndex:replayIndex];
        [placeLabel setText:[NSString stringWithFormat:@"    回复%@",comment.commentName]];
    }
    
    [placeLabel setFont:[UIFont systemFontOfSize:12]];
    [placeLabel setTextColor:[UIColor lightGrayColor]];
    [placeLabel setBackgroundColor:[UIColor clearColor]];
    [placeLabel setTag:2013031804];
    [self.commentInputTextView.growingTextView addSubview:placeLabel];
    
}

- (void)removeCommentInputView{
    if (self.commentInputTextView) {
        [self.commentInputTextView removeFromSuperview];
        self.commentInputTextView = nil;
        
        [self.tableView setScrollEnabled:YES];
        
//        if (selectIndexPath.row == ([self.dataArray count] - 1)) {
//            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectIndexPath];
//            float height = (cell.frame.origin.y + cell.frame.size.height);
//            [self.tableView setContentOffset:CGPointMake(0, height + 196) animated:NO];
//            
//            [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        }
    }
}

#pragma mark - HPGrowingTextView delegate
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        NSMutableString *content = [NSMutableString stringWithString:growingTextView.text];
        content = [NSMutableString stringWithString:[content stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        content = [NSMutableString stringWithString:[content stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        //发送评论
        if ([content length] == 0) {
            //           [self showAlertViewWithMessage:@"输入不能为空"];
            return NO;
        }
        
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:hud];
//        hud.labelText = @"发送中...";
//        [hud showWhileExecuting:@selector(sendCommentToServer:) onTarget:self withObject:content animated:YES];
        //        [self sendCommentToServer:content];
        
        return NO;
    }
    
    UILabel *placeLabel = (UILabel *)[self.commentInputTextView viewWithTag:2013031804];
    [placeLabel setHidden:([growingTextView.text length] > 0 || text.length > 0)];
    
    if ([growingTextView.text length] >140 && ![text isEqualToString:@""]) {
        
        return NO;
    }
    
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float changeHeight = growingTextView.frame.size.height - height;
    
    //设置输入框的背景
    CGRect rect = self.commentInputTextView.frame;
    rect.origin.y += changeHeight;
    rect.size.height -= changeHeight;
    [self.commentInputTextView setFrame:rect];
    
    int ScrollHeight = self.tableView.contentOffset.y - changeHeight;
    [self.tableView setContentOffset:CGPointMake(0, ScrollHeight) animated:YES];
    
    CGRect commentBackRect = self.commentInputTextView.viewBackGround.frame;
    commentBackRect.size.height -= changeHeight;
    self.commentInputTextView.viewBackGround.frame = commentBackRect;
    self.commentInputTextView.viewBackGround.image = [self.commentInputTextView.viewBackGround.image stretchableImageWithLeftCapWidth:110 topCapHeight:10];
    
    CGRect growingBackImageRect = self.commentInputTextView.growingTextViewBackimageView.frame;
    growingBackImageRect.size.height -= changeHeight;
    self.commentInputTextView.growingTextViewBackimageView.frame = growingBackImageRect;
    self.commentInputTextView.growingTextViewBackimageView.image = [self.commentInputTextView.growingTextViewBackimageView.image stretchableImageWithLeftCapWidth:110 topCapHeight:10];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
    
    if (self.commentInputTextView) {
        [self removeCommentInputView];
//        [self.view sendSubviewToBack:self.touchView];
    }
}

#pragma mark - demo data
- (void)dataFromDemo{
    NSMutableArray *demoArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    AGShareItem *item = [[AGShareItem alloc] init];
//    item.shareMsgId = @"11111";
    item.shareContent = @"ASIHTTPRequest对CFNetwork API进行了封装，并且使用起来非常简单，用Objective-C编写，可以很好的应用在Mac OS X系统和iOS平台的应用程序中。ASIHTTPRequest适用于基本的HTTP请求，和基于REST的服务之间的交互";
    item.userName = @"tony_cap";
//    item.userId = @"ajdahsjda76d8ad7a9sdasdas";
    item.profileImgUrl = @"http://image.tianjimedia.com/uploadImages/2013/228/B42FNUVDT7CS.jpg";
    
    AGShareItem *item1 = [[AGShareItem alloc] init];
//    item1.shareMsgId = @"11111";
    item1.shareContent = @"http://www.weqia.com  15267971211[难过][冷汗][大哭]预计4日夜间开始，较强冷空气将从新疆启程，一路东移南下，给中东部地区带来明显降温及大范围的雨雪天气，北京、河北、山西、陕西等地将终结持续两个月左右的干燥无雨天气，北京有望迎来今冬初雪。";
    item1.userName = @"汤姆安德森";
//    item1.userId = @"ajdahsjda76ddaeqdsa23eewd";
    item1.profileImgUrl = @"http://image.tianjimedia.com/uploadImages/2013/228/KT0X2XI3X9Z9.jpg";
    
    AGShareItem *item2 = [[AGShareItem alloc] init];
//    item2.shareMsgId = @"11133";
    item2.shareContent = @"预计4日夜间到5日，较强冷空气将对西北地区发威，气温普遍下降6～8℃，部分地区降温可达10～12℃；新疆北部、内蒙古西部等地有4～6级风，其中山口地区风力可达8～9级；新疆北部有小到中雪，伊犁河谷的部分地区有大雪。6日至8日，西北地区东部、华北、东北地区东部等地将陆续出现小到中雪或雨夹雪，局地大雪。1月6日，北京地区或迎来今冬初雪；上述地区并伴有6～10℃的降温，局地降温幅度可达12～14℃。";
    item2.userName = @"汤姆安德森";
//    item2.userId = @"ajdahsjda76ddaeqdsassdsds";
    item2.profileImgUrl = @"http://image.tianjimedia.com/uploadImages/2013/228/KT0X2XI3X9Z9.jpg";
    
    AGShareItem *item3 = [[AGShareItem alloc] init];
//    item3.shareMsgId = @"sddssds";
    item3.shareContent = @"预计4日夜间到5日，较强冷空气将对西北地区发威，气温普遍下降6～8℃，部分地区降温可达10～12℃；新疆北部、内蒙古西部等地有4～6级风，其中山口地区风。";
    item3.userName = @"汤是滴是滴森";
//    item3.userId = @"ajdahsjda76ddaeqdsassdsds";
    item3.profileImgUrl = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    
    AGShareItem *item4 = [[AGShareItem alloc] init];
//    item4.shareMsgId = @"sddssds";
    item4.shareContent = @"预计4日夜间到5日，较强冷空气将对西北地区发威，气温普遍下降6～8℃，部分地区降温可达10～12℃；新疆北部、内蒙古西部等地有4～6级风，其中山口地区风。ic.jj20.com/up/allimg/411/042511033A2/110425033A2-9.jpgNSString *imagUrl3 = @http://www.mjjq.com/blog/photos/Image/mjjq-photos-903.jpgNSString *imagUrl4 = http://www.feizl.com/upload";
    item4.userName = @"sfsdfs森";
//    item4.userId = @"fsfsfs";
    item4.profileImgUrl = @"http://image.tianjimedia.com/uploadImages/2013/228/0JM239P58O4O.jpg";
    
    NSString *imagUrl1 = @"http://www.hua.com/flower_picture/meiguihua/images/r17.jpg";
    NSString *imagUrl2 = @"http://pic.jj20.com/up/allimg/411/042511033A2/110425033A2-9.jpg";
    NSString *imagUrl3 = @"http://www.mjjq.com/blog/photos/Image/mjjq-photos-903.jpg";
    NSString *imagUrl4 = @"http://www.feizl.com/upload2007/2013_02/130227014423722.jpg";
    NSString *imagUrl5 = @"http://www.feizl.com/upload2007/2013_02/130227014423725.jpg";
    NSString *imagUrl6 = @"http://image.tianjimedia.com/uploadImages/2013/228/6J24DA72I68Q.jpg";
    NSString *imagUrl7 = @"http://image.tianjimedia.com/uploadImages/2013/228/0JM239P58O4O.jpg";
    
    AGShareCommentItem *comment1 = [[AGShareCommentItem alloc] init];
    comment1.commentName = @"羊羊羊";
    comment1.commentUserId = @"adasda";
    comment1.commentToUserId = @"djahdjahs";
    comment1.commentToUserName = @"牛牛";
    comment1.commentContent = @"电视连续剧《甄嬛传》从2011年11月首播到现在，两年多时间过去，重播复重播，收视率依然高企。随着它“闯美入韩又登日”，新一轮关注也风生水起。这种现象很值得";
    
    AGShareCommentItem *comment2 = [[AGShareCommentItem alloc] init];
    comment2.commentName = @"羊羊羊";
    comment2.commentUserId = @"adasda";
    comment2.commentContent = @"电视连续剧《甄嬛传》从2011年11月首";
    
    AGShareCommentItem *comment3 = [[AGShareCommentItem alloc] init];
    comment3.commentName = @"羊羊羊";
    comment3.commentUserId = @"adasdsa";
    comment3.commentContent = @"重播复重播，收视率依然高企。随着它“闯美入韩又登日”，新一轮关注也风生水起。这种现象很值得";
    
    AGShareCommentItem *comment4 = [[AGShareCommentItem alloc] init];
    comment4.commentName = @"开始的健康";
    comment4.commentUserId = @"adasdsdda";
    comment4.commentToUserId = @"djahdjahs";
    comment4.commentToUserName = @"额问问";
    comment4.commentContent = @"连续剧《甄嬛传》从2011年11月首播到现在，两";
    
    AGShareCommentItem *comment5 = [[AGShareCommentItem alloc] init];
    comment5.commentName = @"阿迪哈就是";
    comment5.commentUserId = @"adassada";
    comment5.commentToUserId = @"djahddjahs";
    comment5.commentToUserName = @"大多数都是";
    comment5.commentContent = @"电视连续剧《甄嬛传》从2011年11月首播到现在，两年多时间过去，重播复重播，收视率依然高企。随着它“闯美入韩又登日”，新一轮关注也风生水起。这种现象很值得";
    
    item.sharePhotos = @[imagUrl1,imagUrl3];
    item.shareComments = @[comment1,comment3];
    [demoArr addObject:item];
    
    item3.sharePhotos = @[imagUrl5];
    item3.shareComments = @[comment4,comment5,comment2];
    [demoArr addObject:item3];
    
    item1.sharePhotos = @[imagUrl3,imagUrl4,imagUrl5,imagUrl7];
    item1.shareComments = @[comment5,comment2,comment1];
    [demoArr addObject:item1];
    
    item2.shareComments = @[comment1,comment2,comment3];
    item2.sharePhotos = @[imagUrl7,imagUrl6,imagUrl5,imagUrl4,imagUrl3,imagUrl4,imagUrl1,imagUrl7,imagUrl6];
    [demoArr addObject:item2];
    
    item4.sharePhotos = @[imagUrl1,imagUrl2,imagUrl4];
    [demoArr addObject:item4];
    
    self.dataArray = demoArr;
}
@end
