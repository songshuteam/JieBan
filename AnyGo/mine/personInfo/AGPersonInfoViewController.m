//
//  AGPersonInfoViewController.m
//  AnyGo
//
//  Created by tony on 9/6/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGPersonInfoViewController.h"
#import <UIImageView+WebCache.h>

#import "VPImageCropperViewController.h"
#import "AGJieyouModel.h"
#import "AGUserInfoModifyViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface AGPersonInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) UIImage *faceImage;

@end

@implementation AGPersonInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"个人信息";
    [self backBarButtonWithTitle:@"取消"];
    
    [self detailInfoInit];
    
    //    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.dataArr objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.f;
    }else{
        return 8.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    switch (type.integerValue) {
        case PersonInfoTypeFace:
            height = 82;
            break;
        case PersonInfoTypeEmail:
        case PersonInfoTypeNickName:
        case PersonInfoTypeSex:
        case PersonInfoTypeJiebanPWD:
        case PersonInfoTypeSignature:
        case PersonInfoTypearea:
        default:
            height = 44;
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString *identify = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (type.integerValue) {
        case PersonInfoTypeFace:
        {
            cell.textLabel.text = @"头像";
            UIView *view = [cell viewWithTag:2014090601];
            if (view) {
                [view removeFromSuperview];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(94, 9, 63, 63)];
            imageView.tag = 2014090601;
            if (self.faceImage) {
                [imageView setImage:self.faceImage];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.thumbnailAvatar] placeholderImage:[UIImage imageNamed:@"view_bg_loginIndex"]];
            }
            [AGBorderHelper cornerWithView:imageView cornerRadius:5];
            
            [cell addSubview:imageView];
        }
        case PersonInfoTypeNickName:
            {
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = self.userInfo.nickname ? self.userInfo.nickname : @"";
            }
            break;
        case PersonInfoTypeSex:
            {
                cell.textLabel.text = @"性别";
                NSString *sex = @"保密";
                if (self.userInfo.gender == GenderMale) {
                    sex = @"男";
                }else if(self.userInfo.gender == GenderFemale){
                    sex = @"女";
                }
                
                cell.detailTextLabel.text = sex;
            }
            break;
        case PersonInfoTypearea:
            {
                cell.textLabel.text = @"地区";
                cell.detailTextLabel.text = self.userInfo.area ? self.userInfo.area : @"";
            }
            break;
        case PersonInfoTypeEmail:
            {
                cell.textLabel.text = @"电子邮箱";
                cell.detailTextLabel.text = self.userInfo.email ? self.userInfo.email : @"";
            }
            break;
        case PersonInfoTypeJiebanPWD:
            {
                cell.textLabel.text = @"结伴密码";
                cell.detailTextLabel.text = @"XXXXXXXXXX";
                cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
        case PersonInfoTypeSignature:
            {
                cell.textLabel.text = @"个性签名";
                cell.detailTextLabel.text = self.userInfo.signature ? self.userInfo.signature : @"";
            }
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSNumber *type = [[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (type.intValue == PersonInfoTypeFace) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet showInView:self.view];
    }else{
        AGUserInfoModifyViewController *viewController = [[AGUserInfoModifyViewController alloc] init];
        viewController.type = type.intValue;
        viewController.personInfoViewController = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark -- VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.faceImage = editedImage;
    [self.tableView reloadData];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO  图片更改网络请求
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame) - CGRectGetWidth(self.view.frame))/2 , CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - data init
- (void)detailInfoInit{
    NSArray *baserArr = @[[NSNumber numberWithInteger:PersonInfoTypeFace],[NSNumber numberWithInteger:PersonInfoTypeNickName],[NSNumber numberWithInteger:PersonInfoTypeSex],[NSNumber numberWithInteger:PersonInfoTypearea]];
    
    self.dataArr = [NSMutableArray arrayWithObjects:baserArr, @[[NSNumber numberWithInteger:PersonInfoTypeEmail]],@[[NSNumber numberWithInteger:PersonInfoTypeJiebanPWD]],@[[NSNumber numberWithInteger:PersonInfoTypeSignature]],nil];
}
@end
