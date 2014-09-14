//
//  AGJieBanViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJieBanViewController.h"

#import "AGPointAnnotation.h"
#import "AGJiebanAnnotationView.h"
#import "AGCallOutView.h"
#import "AGRequestManager.h"
#import "MMLocationManager.h"

#import "AGDetailInfoViewController.h"
#import "AGFilterJiebanViewController.h"

#import "AGBorderHelper.h"

@interface AGJieBanViewController ()<MKMapViewDelegate,ASIHTTPRequestDelegate,AGCallOutViewDelegate,FilterJiebanDelegate>{
    AGCallOutView *_calloutView;
    NSInteger currutPage;
}

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NSMutableDictionary *jiebanPageDic;

@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate2D;

@property (nonatomic, strong) AGFilterModel *filterModel;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation AGJieBanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.jiebanPageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.filterModel = [[AGFilterModel alloc] init];
        currutPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"结伴";
    [self backBarButtonWithTitle:@"返回"];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 44.f)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView showsUserLocation];
    
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(searchByKey:)];
//    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    self.annotations = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0, sum = 5; i < sum; i++) {
            AGPointAnnotation *point = [[AGPointAnnotation alloc] init];
                                        
           CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(26.0524 + i*0.2, 119.2568 + i*0.3*i);
            point.coordinate = coordinate;
            point.gender = i/2;
            point.endAddress = i/2 ?  @"乐山" : @"望京";
            
            [self.annotations addObject:point];
        }
    
	[self.mapView addAnnotations:self.annotations];
    CLLocationCoordinate2D coordinate = ((AGPointAnnotation *)self.annotations.firstObject).coordinate;
    [self.mapView setCenterCoordinate:coordinate];
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.0001, 0.0001))];
}

- (IBAction)searchByKey:(id)sender{
    AGFilterJiebanViewController *viewController = [[AGFilterJiebanViewController alloc] init];
    viewController.delegate = self;
    viewController.filterModel = self.filterModel;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)preJiebanBtnClick:(id)sender {
    if (currutPage <= 0 || self.filterModel == nil) {
        return;
    }else{
        currutPage--;
        self.annotations = [self.jiebanPageDic objectForKey:[NSNumber numberWithInteger:currutPage]];
        [self updateMapViewInfo];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *allkey = [self.jiebanPageDic allKeys];
            
            for (NSNumber *key in allkey) {
                if (key.integerValue > currutPage) {
                    [self.jiebanPageDic removeObjectForKey:key];
                }
            }
        });
    }
}

- (IBAction)nextJiebanBtnClick:(id)sender {
    if (self.filterModel == nil) {
        return;
    }
    
    if ([self.annotations count] >= self.filterModel.pageSize) {
        self.filterModel.startIndex = self.filterModel.pageSize * currutPage + 1;
        [self filterRequestWithJieban:self.filterModel];
    }
}

#pragma mark -
- (void)filterViewController:(AGFilterJiebanViewController *)viewController filterCondition:(AGFilterModel *)model{
    if (viewController) {
        self.mapView.showsUserLocation = NO;
    }
    
    self.filterModel = model;
    self.jiebanPageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString *fileName = @"allCity.plist";
    NSDictionary *citiesDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
    NSString *key = [self.filterModel.countryCity isEqualToString:@""] ? self.filterModel.outboundCity : self.filterModel.countryCity;
    NSDictionary *dic = [citiesDic objectForKey:key];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue], [[dic objectForKey:@"lon"] floatValue]);
    self.currentCoordinate2D = coordinate;
    
    [self filterRequestWithJieban:self.filterModel];
}

- (void)filterRequestWithJieban:(AGFilterModel *)model{
    NSURL *url = [AGUrlManager urlSearchPlanWithUserId:[NSString stringWithFormat:@"%lld",[AGBorderHelper userId]] filterInfo:self.filterModel];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}

#pragma mark - 
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if (self.annotations) {
        [self.jiebanPageDic setObject:self.annotations forKey:[NSNumber numberWithInteger:currutPage]];
    }
    
    self.annotations = [[NSMutableArray alloc] initWithCapacity:0];
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSArray *list = [valueDic objectForKey:@"list"];
        
        for (int i = 0, sum = [list count]; i < sum; i++) {
            NSDictionary *dic = [list objectAtIndex:i];
            AGPointAnnotation *point = [[AGPointAnnotation alloc] init];
            
            srand(time(0));
            float rand1 = random()%10;
            float rand2 = random()%10;
            int int1 = rand1 < 5 ? -1 : 1;
            int int2 = rand2 < 5 ? -1 : 1;
            
            float lat = self.currentCoordinate2D.latitude + int1 * (rand1/1000);
            float lon = self.currentCoordinate2D.longitude +  int2 * (rand2/1000);
            point.coordinate = CLLocationCoordinate2DMake(lat, lon);
            
            point.planId = [[dic objectForKey:@"pId"] longLongValue];
            point.fId = [[dic objectForKey:@"fId"] longLongValue];
            point.userId = [[dic objectForKey:@"userId"] longLongValue];
            point.gender = [[dic objectForKey:@"gender"] intValue];
            point.desc = [dic objectForKey:@"des"];
            
            [self.annotations addObject:point];
        }
    }
    
    [self updateMapViewInfo];
}

- (void)requestPlanInfoFinished:(ASIHTTPRequest *)request{
    NSLog(@"requestPlanInfoFinished : %@",request.responseString);
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSDictionary *planDic = [valueDic objectForKey:@"obj"];
        AGJiebanPlanModel *jiebanModel = [AGJiebanPlanModel jiebanInfoFromJsonValue:planDic];
        if (_calloutView) {
            [_calloutView removeFromSuperview];
            _calloutView = nil;
        }
        
        _calloutView = [[AGCallOutView alloc] initWithFrame:CGRectMake(0, 0, 192, 252)];
        _calloutView.center =  self.view.center;
        _calloutView.delegate = self;
        [_calloutView contentViewInitWithPlanInfo:jiebanModel];
        
        [self.view addSubview:_calloutView];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
}

- (void)updateMapViewInfo{
    if ([self.annotations count] <=0) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = ((AGPointAnnotation *)[self.annotations objectAtIndex:0]).coordinate;
    [self.mapView setCenterCoordinate:coordinate];
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.0001, 0.0001))];
	[self.mapView addAnnotations:self.annotations];
}

#pragma mark- MKMapViewDelegate
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            NSString *city = placeMark.locality;
            NSString *stats = placeMark.administrativeArea;
            NSString *country = (city == nil ? stats : city);
            
            AGFilterModel *model = [[AGFilterModel alloc] init];
            model.countryCity = country;
            [self filterViewController:nil filterCondition:model];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[AGPointAnnotation class]]) {
        
        CGPoint originPoint = [mapView convertCoordinate:view.annotation.coordinate toPointToView:self.view];
        CGPoint centerPoint = CGPointMake(originPoint.x + 100, originPoint.y + 65);
        CLLocationCoordinate2D coordinate = [mapView convertPoint:centerPoint toCoordinateFromView:self.view];
        
        [mapView setCenterCoordinate:coordinate animated:YES];
        
        AGPointAnnotation *point = (AGPointAnnotation *)view.annotation;
        ASIHTTPRequest *request = [AGRequestManager requestGetPlanWithUserId:[NSString stringWithFormat:@"%lld",[AGBorderHelper userId]] planId:[NSString stringWithFormat:@"%lld",point.planId]]; //@"151583566037070"];//
        request.delegate = self;
        request.didFinishSelector = @selector(requestPlanInfoFinished:);
        [request startAsynchronous];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    if (_calloutView) {
        [_calloutView removeFromSuperview];
        _calloutView = nil;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if([annotation isKindOfClass:[AGPointAnnotation class]]){
        static NSString *identifier = @"identifier";
        
        AGJiebanAnnotationView *annotationView = (AGJiebanAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView) {
            annotationView = [[AGJiebanAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        AGPointAnnotation *point = (AGPointAnnotation *)annotation;
        [annotationView setAnnotation:point];
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - AGCallOutView delegate
- (void)callOutView:(AGCallOutView *)callView showUserInfoWithUserId:(long long)userId{
    if (_calloutView) {
        [_calloutView removeFromSuperview];
        _calloutView = nil;
    }
    
    AGDetailInfoViewController *viewController = [[AGDetailInfoViewController alloc] init];
    viewController.userId = viewController.userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    viewController.friendId = userId;
    viewController.userId = [[[NSUserDefaults standardUserDefaults] objectForKey:USERID] longLongValue];
    viewController.relation = RelationNotFriend;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
