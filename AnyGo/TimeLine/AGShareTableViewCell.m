//
//  AGShareTableViewCell.m
//  timeLine
//
//  Created by tony on 14-7-9.
//  Copyright (c) 2014年 zjx. All rights reserved.
//

#import "AGShareTableViewCell.h"

#import "FTCoreTextView.h"
#import "AGShowImageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>


#define TAGFORFULLTEXT  2014070901
#define TAGFORPACKUP    20140902

#define NUMBEROFLINELIMIT   15
#define PageMargin  10
#define PageMarginContent   60
#define ContentSize     240

#define ContentFontSize     15

@implementation AGShareTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.faceImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.faceImgBtn.frame = CGRectMake(PageMargin, PageMargin, 40, 40);
        
        self.userName = [[UIButton alloc] initWithFrame:CGRectMake(PageMarginContent, 10, 120, 21)];
        self.contentInfo = [[UILabel alloc] init];
        self.contentInfo.numberOfLines = 0;
        
        self.imageContent = [[AGShowImageControl alloc] init];
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(PageMarginContent, 0, 160, 21)];
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.commentView = [[UIView alloc] init];
        self.commentBgView = [[UIImageView alloc] init];
        self.commentTableView = [[UITableView alloc] init];
        
        [self addSubview:self.faceImgBtn];
        [self addSubview:self.userName];
        [self addSubview:self.contentInfo];
        [self addSubview:self.imageContent];
        [self addSubview:self.time];
        [self addSubview:self.commentBtn];
        [self addSubview:self.commentView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
- (void)setCellContent:(AGShareItem *)item{
    CGFloat height = 10;
    
//    face image data set
    self.faceImgBtn.clipsToBounds = YES;
    self.faceImgBtn.layer.cornerRadius = 3;
    [self.faceImgBtn sd_setImageWithURL:[NSURL URLWithString:item.profileImgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeImg"]];
    [self.faceImgBtn addTarget:self action:@selector(faceImgClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    user Name set
    [self.userName setTitle:item.userName forState:UIControlStateNormal];
    [self.userName setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.userName addTarget:self action:@selector(userNameClick:) forControlEvents:UIControlEventTouchUpInside];
    
    height += 21;
    
//    share content info
    if (item.shareContent && item.shareContent.length > 0) {
        CGSize size = [item.shareContent sizeWithFont:[UIFont systemFontOfSize:ContentFontSize] constrainedToSize:CGSizeMake(ContentSize, 2000) lineBreakMode:NSLineBreakByCharWrapping];
        self.contentInfo.frame = CGRectMake(PageMarginContent, height, ContentSize, size.height);
        self.contentInfo.font = [UIFont systemFontOfSize:ContentFontSize];
        height += size.height;
        self.contentInfo.text = item.shareContent;
    }
    
    if ([item.sharePhotos count] > 0) {
        CGFloat imgHeight = [AGShowImageControl heightForImageViews:item.sharePhotos];
        self.imageContent.frame = CGRectMake(PageMarginContent, height, ContentSize, imgHeight);
        self.imageContent.imageUrls = item.sharePhotos;
        self.imageContent.backgroundColor = [UIColor clearColor];
        [self.imageContent setImageWithUrls:item.sharePhotos];
        height += imgHeight;
    }
    
    self.time.frame = CGRectMake(PageMarginContent, height + 2, 160, 21);
    self.time.text = @"2014-7-21";
    self.time.font = [UIFont systemFontOfSize:14];
    self.commentBtn.frame = CGRectMake(270, height, 30, 25);
    [self.commentBtn setImage:[UIImage imageNamed:@"btn_bg_blue"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    height += 25;       //the send time height
    
    if (item.shareComments > 0) {
        CGFloat commentHeight = [[self class] getHeightForComments:item.shareComments];
        self.commentView.frame = CGRectMake(PageMarginContent, height, ContentSize, commentHeight + 15);
        
        self.commentBgView.frame = self.commentView.bounds;
        self.commentBgView.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:50.0f topCapHeight:30.0f];
        self.commentBgView.backgroundColor = [UIColor blackColor];
        
        self.commentTableView.frame = CGRectMake(0, 10, ContentSize, commentHeight);
        self.commentTableView.backgroundColor = [UIColor clearColor];
        self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.commentTableView.dataSource = self;
        self.commentTableView.delegate = self;
        self.commentTableView.scrollEnabled = NO;
        
        [self.commentView addSubview:self.commentBgView];
        [self.commentView addSubview:self.commentTableView];
        [self.commentTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate for Comment list
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AGShareCommentItem *item = [self.shareItem.shareComments objectAtIndex:indexPath.row];
    CGFloat height = [[self class] getHeightForComment:item];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.shareItem.shareComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AGShareCommentItem *item = [self.shareItem.shareComments objectAtIndex:indexPath.row];
    
    static NSString *identify = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        FTCoreTextView *content = [[FTCoreTextView alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
        content.tag = 20140710;
        content.backgroundColor = [UIColor clearColor];
        [cell addSubview:content];
    }
    
    FTCoreTextView *contentView = (FTCoreTextView *)[cell viewWithTag:20140710];
    contentView.text = item.getShowMessage;
    [contentView addStyles:[[self class] getCoreTextStyle]];
    [contentView fitToSuggestedHeight];
    
    CGRect rect = cell.frame;
    rect.size.height = CGRectGetHeight(contentView.frame);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    回复消息
    AGShareCommentItem *item = [self.shareItem.shareComments objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTableViewCell:commentInfo:)]) {
        [self.delegate shareTableViewCell:self commentInfo:item];
    }
}

- (IBAction)faceImgClick:(id)sender{
    [self getUserTimeLine:self.shareItem.userId];
}

- (IBAction)userNameClick:(id)sender{
    [self getUserTimeLine:self.shareItem.userId];
}

- (IBAction)commentBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTableViewCell:commentShareInfoId:)]) {
        [self.delegate shareTableViewCell:self commentShareInfoId:self.shareItem.shareMsgId];
    }
}

- (void)getUserTimeLine:(long long)userId{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareTableViewCell:timelineByUserId:)]) {
        [self.delegate shareTableViewCell:self timelineByUserId:userId];
    }
}

#pragma mark - static function
+ (CGFloat)getHeightByShareItem:(AGShareItem *)shareItem{
    CGFloat height = 10;
    
    height += 21;       //用户昵称
    if (shareItem.shareContent && shareItem.shareContent.length > 0) {
        CGSize size = [shareItem.shareContent sizeWithFont:[UIFont systemFontOfSize:ContentFontSize] constrainedToSize:CGSizeMake(ContentSize, 2000) lineBreakMode:NSLineBreakByCharWrapping];
        height += size.height;
    }
    
    if ([shareItem.sharePhotos count] > 0) {
        height += [AGShowImageControl heightForImageViews:shareItem.sharePhotos];
    }
    
    height += 25;       //time label height
    
    if ([shareItem.shareComments count] > 0) {
        
        height += [self getHeightForComments:shareItem.shareComments] + 15;
    }
    
    return height;
}

+ (CGFloat)getHeightForComments:(NSArray *)comments{
    CGFloat height = 0;
    for (AGShareCommentItem *item in comments) {
        height += [[self class] getHeightForComment:item];
    }
    
    return height;
}

+ (CGFloat)getHeightForComment:(AGShareCommentItem *)commentItem{
    FTCoreTextView *contentView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
    
    contentView.text = commentItem.getShowMessage;
    [contentView addStyles:[[self class] getCoreTextStyle]];
    [contentView fitToSuggestedHeight];
    
    return CGRectGetHeight(contentView.frame);
}

+ (NSArray *)getCoreTextStyle{
    FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
    defaultStyle.name = FTCoreTextTagDefault;
    defaultStyle.textAlignment = FTCoreTextAlignementJustified;
    defaultStyle.color = [UIColor lightGrayColor];
    defaultStyle.font = [UIFont systemFontOfSize:12];
    
    FTCoreTextStyle *styleA = [FTCoreTextStyle styleWithName:FTCoreTextTagLink];
    styleA.name = @"a";
    styleA.color = [UIColor colorWithRed:14/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:1];
    styleA.font = [UIFont systemFontOfSize:12];
    
    return @[defaultStyle,styleA];
}

@end
