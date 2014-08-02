//
//  AGSelectPhotoTableViewCell.m
//  PhotoBrowserDemo
//
//  Created by tony on 14-7-14.
//
//

#import "AGSelectPhotoTableViewCell.h"

#define IMAGENORMALWIDTH 65
#define IMAGESPACE 10
#define SPACEFORVIEW    15

@implementation AGSelectPhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

- (void)initCellView:(NSArray *)imageArr{
    
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i < [imageArr count]; i++) {
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.tag = i;
        imageButton.frame = CGRectMake(i%4*(IMAGENORMALWIDTH + IMAGESPACE) + SPACEFORVIEW, i/4*(IMAGENORMALWIDTH + IMAGESPACE) + IMAGESPACE, IMAGENORMALWIDTH, IMAGENORMALWIDTH);
        [imageButton setImage:[imageArr objectAtIndex:i] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setImageCornerRadius:imageButton];
        
        [self addSubview:imageButton];
    }
    
    if ([imageArr count] < 9) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"addressBookIcon"] forState:UIControlStateNormal];
        int sum = [imageArr count];
        addBtn.frame = CGRectMake(sum%4 * (IMAGENORMALWIDTH + IMAGESPACE) + SPACEFORVIEW, sum/4 * (IMAGENORMALWIDTH + IMAGESPACE) + IMAGESPACE, IMAGENORMALWIDTH, IMAGENORMALWIDTH);
        [addBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setImageCornerRadius:addBtn];
        
        [self addSubview:addBtn];
    }
}

- (IBAction)imageButtonClick:(id)sender{
    NSInteger index = ((UIButton *)sender).tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:ImageIndex:)]) {
        [self.delegate tableViewCell:self ImageIndex:index];
    }
}

- (IBAction)addImageBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotoToShareClick:)]) {
        [self.delegate addPhotoToShareClick:self];
    }
}

- (void)setImageCornerRadius:(UIButton *)btn
{
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0f;
    btn.layer.borderWidth = 0.5f;
    btn.layer.borderColor = [UIColor clearColor].CGColor;
}

+ (CGFloat)heightForCell:(NSArray *)imageArr{
    int sum = [imageArr count];
    
    if (sum < 9) {
        sum += 1;
    }
    
    CGFloat height = ((sum-1)/4 + 1)*(IMAGENORMALWIDTH + IMAGESPACE);
    
    return height;
}

@end
