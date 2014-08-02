//
//  AGSelectPhotoTableViewCell.h
//  PhotoBrowserDemo
//
//  Created by tony on 14-7-14.
//
//

#import <UIKit/UIKit.h>

@class AGSelectPhotoTableViewCell;

@protocol AGSelectPhotoTableViewCellDelegate <NSObject>

@optional
- (void)addPhotoToShareClick:(AGSelectPhotoTableViewCell *)cell;
- (void)tableViewCell:(AGSelectPhotoTableViewCell *)cell ImageIndex:(NSInteger)index;

@end

@interface AGSelectPhotoTableViewCell : UITableViewCell{
    
}

@property (weak, nonatomic) id<AGSelectPhotoTableViewCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *imageArr;

- (void)initCellView:(NSArray *)imageArr;

+ (CGFloat)heightForCell:(NSArray *)imageArr;
@end
