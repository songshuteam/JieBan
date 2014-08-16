//
//  AGJieyouBaseInfoView.m
//  AnyGo
//
//  Created by tony on 8/4/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJieyouBaseInfoView.h"

#import "AGBorderHelper.h"
#import "UIImageView+WebCache.h"

@interface AGJieyouBaseInfoView ()

@property (strong, nonatomic) UIImageView *faceImgView;
@property (strong, nonatomic) UILabel *nickName;
@property (strong, nonatomic) UIImageView *sexImg;
@property (strong, nonatomic) UIButton *addFocusBtn;
@property (strong, nonatomic) UILabel *signatureLable;

@end

@implementation AGJieyouBaseInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 62, 62)];
        [AGBorderHelper cornerWithView:self.faceImgView cornerRadius:5];
        
        self.nickName = [[UILabel alloc] initWithFrame:CGRectMake(81, 11, 120, 15)];
        self.nickName.font = [UIFont systemFontOfSize:15];
        
        self.sexImg =  [[UIImageView alloc] initWithFrame:CGRectMake(210, 13, 15, 13)];
        self.sexImg.image = [UIImage imageNamed:@"person_male"];
        
        self.addFocusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addFocusBtn setImage:[UIImage imageNamed:@"person_addFocus"] forState:UIControlStateNormal];
        [self.addFocusBtn setFrame:CGRectMake(250, 11, 59, 20)];
        [self.addFocusBtn addTarget:self action:@selector(addFocusBtnCick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.signatureLable = [[UILabel alloc] initWithFrame:CGRectMake(81, 30, 200, 50)];
        self.signatureLable.numberOfLines = 0;
        self.signatureLable.font = [UIFont systemFontOfSize:12];
        self.signatureLable.textColor = [UIColor colorWithRed:146.0f/255.0f green:146.0f/255.0f blue:146.0f/255.0f alpha:1];
        
        self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
        [self addSubview:self.faceImgView];
        [self addSubview:self.nickName];
        [self addSubview:self.sexImg];
        [self addSubview:self.addFocusBtn];
        [self addSubview:self.signatureLable];
        
    }
    return self;
}

- (IBAction)addFocusBtnCick:(id)sender{
    
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
    self.signatureLable.text = jieyouModel.signature;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
