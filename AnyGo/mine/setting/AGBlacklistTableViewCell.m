//
//  AGBlacklistTableViewCell.m
//  AnyGo
//
//  Created by tony on 9/7/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGBlacklistTableViewCell.h"

#import <UIImageView+WebCache.h>

@interface AGBlacklistTableViewCell()

@property (strong, nonatomic) UIImageView *m_checkImageView;
@property (assign, nonatomic) BOOL			m_checked;

@end

@implementation AGBlacklistTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)contentInitWithJieyou:(AGJieyouModel *)model{
    self.jieyouModel = model;
    [AGBorderHelper cornerWithView:self.faceImg cornerRadius:4];
    [self.faceImg sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
    self.nickName.text = @"adhashdka";//model.nickname;
    self.signature.text = model.signature;
    
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    if (self.editing == editing) {
//        return;
//    }
//    
//    [super setEditing:editing animated:YES];
//    if (editing) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if (self.m_checkImageView == nil) {
//            self.m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unselected_btn"]];
//            [self addSubview:self.m_checkImageView];
//        }
//        [self setChecked:self.m_checked];
//        self.m_checkImageView.center = CGPointMake(-CGRectGetWidth(self.m_checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
//        self.m_checkImageView.alpha = .0f;
//        [self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds)*.5f) alpha:1.0f animated:animated];
//    }else{
//        self.m_checked = NO;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (self.m_checkImageView) {
//            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(self.m_checkImageView.frame) * 0.5, CGRectGetHeight(self.bounds) * 0.5) alpha:1.0f animated:animated];
//        }
//    }
//}

- (void) setChecked:(BOOL)checked{
    if (checked) {
        self.m_checkImageView.image = [UIImage imageNamed:@"selected_btn"];
    }else{
        self.m_checkImageView.image = [UIImage imageNamed:@"unselected_btn"];
    }
}

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		self.m_checkImageView.center = pt;
		self.m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	} else {
		self.m_checkImageView.center = pt;
		self.m_checkImageView.alpha = alpha;
	}
}
@end
