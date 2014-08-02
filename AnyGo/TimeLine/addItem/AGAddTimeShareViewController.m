//
//  AGAddTimeShareViewController.m
//  PhotoBrowserDemo
//
//  Created by tony on 14-7-14.
//
//

#import "AGAddTimeShareViewController.h"

#import "AGSelectPhotoTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "QBImagePickerController.h"

typedef NS_ENUM(NSInteger, ShareItemType) {
    ShareItemTypeMessage = 0,
    ShareItemTypePhoto
};

@interface AGAddTimeShareViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AGSelectPhotoTableViewCellDelegate,QBImagePickerControllerDelegate>{
    UIViewController *imageViewController;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *photoImages;
@property (strong, nonatomic) NSString *shareContent;

@end

@implementation AGAddTimeShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.photoImages = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dataSourceInit];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = FALSE;
    //    [self.photoImages addObjectsFromArray:@[@"photo1t.jpg",@"photo2t.jpg",@"photo3t.jpg",@"photo4t.jpg",]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [self.dataArray objectAtIndex:indexPath.row];
    
    if (type.integerValue == ShareItemTypeMessage) {
        return 80;
    }else if(type.integerValue == ShareItemTypePhoto){
        return [AGSelectPhotoTableViewCell heightForCell:self.photoImages];
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *type = [self.dataArray objectAtIndex:indexPath.row];
    
    if (type.integerValue == ShareItemTypeMessage) {
        static NSString *identifier = @"messageIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            CGRect rect = cell.frame;
            rect.size.height = 80;
            cell.frame = rect;
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(cell.frame) - 2*15, CGRectGetHeight(cell.frame))];
            textView.tag = 2014071401;
            textView.font = [UIFont systemFontOfSize:17];
            textView.delegate = self;
            textView.backgroundColor = [UIColor redColor];
            [cell addSubview:textView];
        }
        
        return cell;
    }else if (type.intValue == ShareItemTypePhoto){
        static NSString *identifier = @"PhotoIdentifier";
        AGSelectPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[AGSelectPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.delegate = self;
        [cell initCellView:self.photoImages];
        
        return cell;
    }else{
        static NSString *identifier = @"identifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    return nil;
}

#pragma mark - TextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.shareContent = textView.text;
}

#pragma mark - AGSelectPhotoTableViewCell Delegate
- (void)addPhotoToShareClick:(AGSelectPhotoTableViewCell *)cell{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
    
    
}

- (void)tableViewCell:(AGSelectPhotoTableViewCell *)cell ImageIndex:(NSInteger)index{
    
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self takePhotoWithCamera];
    }else if (buttonIndex == 1){
        [self selectPhotoFromLibrary];
    }
}

- (void)takePhotoWithCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self startPickerFromViewController:self.navigationController usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)selectPhotoFromLibrary{
    //    从图片中选择
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    imagePickerController.maximumNumberOfSelection = 9 - [self.photoImages count];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (void)startPickerFromViewController:(UIViewController *)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject sourceType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备无法拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - imagePicker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSData  *data = UIImageJPEGRepresentation(image, 0.5f);
    [self.photoImages addObject:[UIImage imageWithData:data]];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    NSLog(@"*** imagePickerController:didSelectAsset:");
    [self dismissImagePickerController];
    CGImageRef img = [[asset  defaultRepresentation] fullResolutionImage];
    [self.photoImages addObject:[UIImage imageWithCGImage:img]];
    
    [self.tableView reloadData];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"*** imagePickerController:didSelectAssets:");
    NSLog(@"%@", assets);
    [self dismissImagePickerController];
    for (ALAsset *asset in assets) {
        //        NSString *url = [[[asset defaultRepresentation] url]debugDescription];
        CGImageRef img = [[asset  defaultRepresentation] fullResolutionImage];
        [self.photoImages addObject:[UIImage imageWithCGImage:img]];
    }
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}

#pragma mark - init Data for TableView
- (void)dataSourceInit{
    [self.dataArray addObject:[NSNumber numberWithInteger:ShareItemTypeMessage]];
    [self.dataArray addObject:[NSNumber numberWithInteger:ShareItemTypePhoto]];
}
@end
