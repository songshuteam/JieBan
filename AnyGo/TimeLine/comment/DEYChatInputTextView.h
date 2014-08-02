//
//  DEYChatInputTextView.h
//  DEyes
//
//  Created by zhang xiang on 11/5/12.
//  Copyright (c) 2012 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

typedef  enum _ChatinputType{
    chatinputTypeNone = 0,
    ChatinputTypeText,
    ChatinputTypeTextAndPicture,
    ChatinputTypeAll
}ChatinputType;

@interface DEYChatInputTextView : UIView{
    HPGrowingTextView *growingTextView;
    UIImageView *growingTextViewBackimageView;
    UIButton *messageSelectPictureBtn;
    UIImageView *viewBackGround;
    UIButton *messageTypeSelectBtn;
    UIButton *voiceMessageBtn;
}

@property (nonatomic, retain) HPGrowingTextView *growingTextView;
@property (nonatomic, retain) UIImageView *growingTextViewBackimageView;
@property (nonatomic, retain) UIButton *messageSelectPictureBtn;
@property (nonatomic, retain) UIImageView *viewBackGround;
@property (nonatomic, retain) UIButton *messageTypeSelectBtn;
@property (nonatomic, retain) UIButton *voiceMessageBtn;

- (instancetype)initWithFrame:(CGRect)frame withInputType:(ChatinputType)type;
- (void)initGrowingTextView;

@end
