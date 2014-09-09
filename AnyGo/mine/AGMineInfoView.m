//
//  AGMineInfoView.m
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGMineInfoView.h"

#import "UIImageView+WebCache.h"

@interface AGMineInfoView ()

@property (strong, nonatomic) UIImageView *faceImgView;
@property (strong, nonatomic) UILabel *nickName;
@property (strong, nonatomic) UIImageView *sexImg;
@property (strong, nonatomic) UIButton *postMessage;
@property (strong, nonatomic) UIButton *addFriend;
@property (strong, nonatomic) UIButton *personInfo;

@end

@implementation AGMineInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 63, 63)];
        [AGBorderHelper cornerWithView:self.faceImgView cornerRadius:5];
        
        self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(81, 11, 120, 15)];
        self.nickName.font = [UIFont systemFontOfSize:15];
        
        self.sexImg =  [[UIImageView alloc] initWithFrame:CGRectMake(210, 13, 15, 13)];
        self.sexImg.image = [UIImage imageNamed:@"mine_female"];
        
        self.postMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.postMessage setImage:[UIImage imageNamed:@"btn_postMsg"] forState:UIControlStateNormal];
        [self.postMessage setFrame:CGRectMake(250, 11, 58, 19)];
        [self.postMessage addTarget:self action:@selector(postMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addFriend setImage:[UIImage imageNamed:@"btn_addFriend"] forState:UIControlStateNormal];
        [self.addFriend setFrame:CGRectMake(250, 55, 58, 19)];
        [self.addFriend addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.personInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.personInfo setImage:[UIImage imageNamed:@"personInfo"] forState:UIControlStateNormal];
        [self.personInfo setFrame:CGRectMake(81, 55, 58, 19)];
        [self.personInfo addTarget:self action:@selector(personInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
        
        [self addSubview:self.faceImgView];
        [self addSubview:self.nickName];
        [self addSubview:self.sexImg];
        [self addSubview:self.postMessage];
        [self addSubview:self.addFriend];
        [self addSubview:self.personInfo];
        
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

- (IBAction)postMessageBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineInfoView:mineInfoType:)]) {
        [self.delegate mineInfoView:self mineInfoType:MineInfoTypePostMsg];
    }
}

- (IBAction)addFriendBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineInfoView:mineInfoType:)]) {
        [self.delegate mineInfoView:self mineInfoType:MineInfoTypeAddFriend];
    }
}

- (IBAction)personInfoBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineInfoView:mineInfoType:)]) {
        [self.delegate mineInfoView:self mineInfoType:MineInfoTypePersonInfo];
    }
}

- (void)contentInitWithJieyou:(AGJieyouModel *)jieyouModel{
    [self.faceImgView sd_setImageWithURL:[NSURL URLWithString:jieyouModel.headUrl] placeholderImage:[UIImage imageNamed:@"jeiban_prePage"]];
    
    self.nickName.text = jieyouModel.nickname;
    CGSize size = [jieyouModel.nickname sizeWithFont:self.nickName.font constrainedToSize:CGSizeMake(120, 21)];
    CGRect nickRect = self.nickName.frame;
    nickRect.size.width = size.width;
    self.nickName.frame = nickRect;
    
    CGRect rect = self.sexImg.frame;
    rect.origin.x = CGRectGetMinX(self.nickName.frame) + CGRectGetWidth(self.nickName.frame) + 9;
    self.sexImg.frame = rect;
    self.sexImg.image = [UIImage imageNamed:jieyouModel.gender == GenderFemale ? @"person_female" : @"person_male"];
}

- (void)updateFaceImage:(UIImage *)faceImg{
    self.faceImgView.image = faceImg;
}
@end
