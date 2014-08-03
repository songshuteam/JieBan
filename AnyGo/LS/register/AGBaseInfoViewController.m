//
//  AGBaseInfoViewController.m
//  AnyGo
//
//  Created by tony on 14-6-30.
//  Copyright (c) 2014年 WingleWong. All rights reserved.
//

#import "AGBaseInfoViewController.h"

#import "PBFlatButton.h"
#import "VPImageCropperViewController.h"

#import "AGRequestManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f
#define FACEBGIMAGEVIEWTAG  2014070701
#define GENDERBGIMAGEVIWQTAG    2014070702
#define AGEBGIMAGEVIEWTAG   2014070703

@interface AGBaseInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate,VPImageCropperDelegate>{
    Gender gender;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *faceBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *genderBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ageBgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet PBFlatButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleSelectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *femaleAgreeFlagImg;
@property (weak, nonatomic) IBOutlet UIImageView *maleAgreeFlagImg;
@end

@implementation AGBaseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        gender = GenderFemale;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setFaceImageCornerRadius];
    [self viewChangeBySex:true];
    
    [self addGestureToBgView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishRegisterAccount:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init View Info
- (void)addGestureToBgView{
//    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
//    singleTapGesture.numberOfTapsRequired = 1;
//    singleTapGesture.numberOfTouchesRequired  = 1;
//    
//    self.faceBgImageView.userInteractionEnabled = YES;
//    [self.faceBgImageView addGestureRecognizer:singleTapGesture];
//    self.faceBgImageView.tag = FACEBGIMAGEVIEWTAG;
    
    UITapGestureRecognizer *singleTapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture2.numberOfTapsRequired = 1;
    singleTapGesture2.numberOfTouchesRequired = 1;
    
    self.genderBgImageView.userInteractionEnabled = YES;
    [self.genderBgImageView addGestureRecognizer:singleTapGesture2];
    self.genderBgImageView.tag = GENDERBGIMAGEVIWQTAG;
    
    UITapGestureRecognizer *singleTapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture3.numberOfTapsRequired = 1;
    singleTapGesture3.numberOfTouchesRequired  = 1;
    self.ageBgImageView.userInteractionEnabled = YES;
    [self.ageBgImageView addGestureRecognizer:singleTapGesture3];
    self.ageBgImageView.tag = AGEBGIMAGEVIEWTAG;
}

#pragma mark -- nib interface
- (IBAction)finishRegisterAccount:(id)sender {
    self.registerModel.gender = gender;
    
    ASIFormDataRequest *request = [AGRequestManager requestWithRegisterInfo:self.registerModel];
    request.delegate = self;
    [request startAsynchronous];
}

-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    
    NSInteger tag = [singleTap view].tag;
    if (FACEBGIMAGEVIEWTAG == tag) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [sheet showInView:self.view];
    }else if (GENDERBGIMAGEVIWQTAG == tag){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [sheet showInView:self.view];
    }else if (AGEBGIMAGEVIEWTAG == tag){
//        选择器使用

    }
}

#pragma mark - ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *valueDic = [[request responseString] JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        long long userId = [[valueDic objectForKey:@"userId"] longLongValue];
        NSString *token = [valueDic objectForKey:@"token"];
        NSString *tempToken = [valueDic objectForKey:@"tempToken"];
        self.registerModel.jieyouId = userId;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:userId] forKey:USERID];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKENINFO];
        [[NSUserDefaults  standardUserDefaults] setObject:tempToken forKey:TEMPTOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        跳转到首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{

}

#pragma mark -- VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.faceImageView.image = editedImage;
    self.registerModel.faceImg = editedImage;
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)cameraBtnClick:(id)sender {
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
}
- (IBAction)photoLibBtnClick:(id)sender {
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

- (IBAction)SexSelectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 2014072701) {    //male
        gender = GenderMale;
        [self viewChangeBySex:NO];
    }else if (btn.tag == 2014072702){   //female
        gender = GenderFemale;
        [self viewChangeBySex:YES];
    }
}

- (void)viewChangeBySex:(BOOL)isFemale{
    self.femaleAgreeFlagImg.hidden = isFemale;
    self.maleAgreeFlagImg.hidden = !isFemale;
    
    [self.femaleSelectBtn setImage:[UIImage imageNamed:isFemale ? @"female_select" : @"female_unselect"] forState:UIControlStateNormal];
    [self.maleSelectBtn setImage:[UIImage imageNamed:!isFemale ? @"male_select" : @"male_unselect"] forState:UIControlStateNormal];
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

#pragma mark faceImageView getter
- (UIImageView *)faceImageView{
    if (!_faceImageView) {
        [self setFaceImageCornerRadius];
    }
    
    return _faceImageView;
}

- (void)setFaceImageCornerRadius{
    [_faceImageView.layer setCornerRadius:(_faceImageView.frame.size.height/2)];
    [_faceImageView.layer setMasksToBounds:YES];
    [_faceImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_faceImageView setClipsToBounds:YES];
    _faceImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _faceImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _faceImageView.layer.shadowOpacity = 0.5;
    _faceImageView.layer.shadowRadius = 2.0;
    _faceImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _faceImageView.layer.borderWidth = 2.0f;
}

@end
