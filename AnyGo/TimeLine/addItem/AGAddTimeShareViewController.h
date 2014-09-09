//
//  AGAddTimeShareViewController.h
//  PhotoBrowserDemo
//
//  Created by tony on 14-7-14.
//
//

#import "AGViewController.h"

@interface AGAddTimeShareViewController : AGViewController
@property (nonatomic, assign) BOOL isFromOther;
@property (assign, nonatomic) NSInteger selectType; //图片发送类型，0 拍照， 1 从相册中选择
@end
