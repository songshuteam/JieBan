//
//  AGJieBanViewController.m
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGJieBanViewController.h"

@interface AGJieBanViewController ()

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
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 44.f)];
    [self.view addSubview:self.mapView];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
