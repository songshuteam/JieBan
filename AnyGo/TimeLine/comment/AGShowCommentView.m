//
//  AGShowCommentView.m
//  shareTime
//
//  Created by tony on 7/14/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "AGShowCommentView.h"

#define CommentButtonWidth 90
#define CommentButtonHeight 36

@implementation AGShowCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [backImageView setImage:[UIImage imageNamed:@"commentbackImage.png"]];
        [self addSubview:backImageView];
        
        UIButton *commentPraise = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, CommentButtonWidth, CommentButtonHeight)];
        [commentPraise setBackgroundColor:[UIColor clearColor]];
        [commentPraise setImage:[UIImage imageNamed:@"commentPraise.png"] forState:UIControlStateNormal];
        self.praiseBtn = commentPraise;
        [self addSubview:commentPraise];
        
        UIButton *commentReply = [[UIButton alloc] initWithFrame:CGRectMake(10 + CommentButtonWidth, 5, CommentButtonWidth, CommentButtonHeight)];
        [commentReply setBackgroundColor:[UIColor clearColor]];
        [commentReply setImage:[UIImage imageNamed:@"commentImage.png"] forState:UIControlStateNormal];
        self.commentBtn = commentReply;
        [self addSubview:commentReply];
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

@end
