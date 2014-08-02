//
//  DEYChatInputTextView.m
//  DEyes
//
//  Created by zhang xiang on 11/5/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import "DEYChatInputTextView.h"

#define  inputTextFrameX 6 
#define  inputTextFrameY 4
#define  buttonWidth 44
#define  inputViewFontSize 13


@implementation DEYChatInputTextView

@synthesize growingTextView;
@synthesize growingTextViewBackimageView;
@synthesize messageSelectPictureBtn;
@synthesize viewBackGround;
@synthesize messageTypeSelectBtn;
@synthesize voiceMessageBtn;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        [self initWithFrame:frame withInputType:ChatinputTypeText];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withInputType:(ChatinputType)type{
    self = [super initWithFrame:frame];
    if (self) {
        viewBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [viewBackGround setImage:[UIImage imageNamed:@"messageViewBackImage.png"]];
        [self addSubview:viewBackGround];
        
        if (type == ChatinputTypeAll) {
             messageTypeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 8, 35, 35)];
            [messageTypeSelectBtn setImage:[UIImage imageNamed:@"messageVoice.png"] forState:UIControlStateNormal];
            [self addSubview:messageTypeSelectBtn];
            
            voiceMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(39, 5, 227, 39)];
            [voiceMessageBtn setImage:[UIImage imageNamed:@"voicemessageBackgroup.png"] forState:UIControlStateNormal];
            [self addSubview:voiceMessageBtn];
            [voiceMessageBtn setHidden:YES];
            
            CGRect rect = CGRectMake(42, 5, 220, frame.size.height - 10);
            growingTextView = [[HPGrowingTextView alloc] initWithFrame:rect];
            [self initGrowingTextView];
            [self addSubview:growingTextView];
            
            messageSelectPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 6, 46, 36)];
            [messageSelectPictureBtn setImage:[UIImage imageNamed:@"ImageMessage.png"] forState:UIControlStateNormal];
            [self addSubview:messageSelectPictureBtn];
        }
        else if(type == ChatinputTypeTextAndPicture){
            CGRect rect = CGRectMake(inputTextFrameX, inputTextFrameY, frame.size.width - inputTextFrameX - buttonWidth, frame.size.height - 2*inputTextFrameY);
            growingTextView = [[HPGrowingTextView alloc] initWithFrame:rect];
            [self initGrowingTextView];
            [self addSubview:growingTextView];
            
            messageSelectPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 6, 46, 36)];
            [messageSelectPictureBtn setBackgroundColor:[UIColor redColor]];
            [messageSelectPictureBtn setImage:[UIImage imageNamed:@"ImageMessage.png"] forState:UIControlStateNormal];
            [self addSubview:messageSelectPictureBtn];
            
        
        }else if (type == ChatinputTypeText){
            CGRect rect = CGRectMake(inputTextFrameX, inputTextFrameY, frame.size.width - 2*inputTextFrameX, frame.size.height - 2*inputTextFrameY);
            growingTextView = [[HPGrowingTextView alloc] initWithFrame:rect];
            [self initGrowingTextView];
            [self addSubview:growingTextView];
        }
    }
    
    return self;
}

- (void)dealloc{
}

#pragma mark - function
- (void)initGrowingTextView{
    if (self.growingTextView) {
        [self.growingTextView setMinNumberOfLines:1];
        [self.growingTextView setMaxNumberOfLines:3];
        [self.growingTextView setReturnKeyType:UIReturnKeySend];
        [self.growingTextView setFont:[UIFont systemFontOfSize:inputViewFontSize]];
        self.growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 10, 0);
        [self.growingTextView.internalTextView setBackgroundColor:[UIColor clearColor]];
        [self.growingTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        growingTextViewBackimageView = [[UIImageView alloc] initWithFrame:[self.growingTextView bounds]];
        growingTextViewBackimageView.image = [UIImage imageNamed:@"messageBackground.png"];
        [self.growingTextView addSubview:self.growingTextViewBackimageView];
        [self.growingTextView setBackgroundColor:[UIColor clearColor]];
        [self.growingTextView sendSubviewToBack:self.growingTextViewBackimageView];
    }
}

@end
