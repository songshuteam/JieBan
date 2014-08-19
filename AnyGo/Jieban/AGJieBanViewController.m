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

#import "AGDetailInfoViewController.h"
#import "AGFilterJiebanViewController.h"

#import "AGBorderHelper.h"

@interface AGJieBanViewController ()<MKMapViewDelegate,ASIHTTPRequestDelegate,AGCallOutViewDelegate,FilterJiebanDelegate>{
    AGCallOutView *_calloutView;
}

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) AGFilterModel *filterModel;
@end

@implementation AGJieBanViewController

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
    self.navigationItem.title = @"结伴";
    [self backBarButtonWithTitle:@"返回"];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 44.f)];
    self.mapView.delegate = self;
    [self.mapView showsUserLocation];
    [self.view addSubview:self.mapView];
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

#pragma mark - 

- (void)filterViewController:(AGFilterJiebanViewController *)viewController filterCondition:(AGFilterModel *)model{
    self.filterModel = model;
    
    NSURL *url = [AGUrlManager urlSearchPlanWithUserId:@"111111" filterInfo:self.filterModel];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
}

#pragma mark - 
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"%@",request.responseString);
    NSDictionary *valueDic = [request.responseString JSONValue];
    
    self.annotations = [[NSMutableArray alloc] initWithCapacity:0];
    if ([[valueDic objectForKey:@"status"] intValue] == 200) {
        NSArray *list = [valueDic objectForKey:@"list"];
        
        for (int i = 0, sum = [list count]; i < sum; i++) {
            NSDictionary *dic = [list objectAtIndex:i];
            AGPointAnnotation *point = [[AGPointAnnotation alloc] init];
            point.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] longLongValue], [[dic objectForKey:@"lon"] longLongValue]);
            point.planId = [[dic objectForKey:@"pId"] longLongValue];
            point.fId = [[dic objectForKey:@"fId"] longLongValue];
            point.userId = [[dic objectForKey:@"userId"] longLongValue];
            point.gender = [[dic objectForKey:@"gender"] intValue];
            point.desc = [dic objectForKey:@"des"];
            
            [self.annotations addObject:point];
        }
    }
    
    if ([self.annotations count] <=0) {
        return;
    }
    CLLocationCoordinate2D coordinate = ((AGPointAnnotation *)[self.annotations objectAtIndex:0]).coordinate;
    [self.mapView setCenterCoordinate:coordinate];
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.0001, 0.0001))];
	[self.mapView addAnnotations:self.annotations];
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

#pragma mark- MKMapViewDelegate
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if ([view.annotation isKindOfClass:[AGPointAnnotation class]]) {
        
        CGPoint originPoint = [mapView convertCoordinate:view.annotation.coordinate toPointToView:self.view];
        CGPoint centerPoint = CGPointMake(originPoint.x + 100, originPoint.y + 65);
        CLLocationCoordinate2D coordinate = [mapView convertPoint:centerPoint toCoordinateFromView:self.view];
        
        [mapView setCenterCoordinate:coordinate animated:YES];
        
        AGPointAnnotation *point = (AGPointAnnotation *)view.annotation;
        ASIHTTPRequest *request = [AGRequestManager requestGetPlanWithUserId:@"11111" planId:@"151583566037070"];//[NSString stringWithFormat:@"%lld",point.planId]];
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
    
    AGDetailInfoViewController *viewController = [[AGDetailInfoViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    if (_calloutView) {
        [_calloutView removeFromSuperview];
        _calloutView = nil;
    }
}
@end
