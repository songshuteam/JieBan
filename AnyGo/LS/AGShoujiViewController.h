//
//  AGShoujiViewController.h
//  AnyGo
//
//  Created by Wingle Wong on 6/16/14.
//  Copyright (c) 2014 WingleWong. All rights reserved.
//

#import "AGViewController.h"

@interface AGShoujiViewController : AGViewController
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
- (IBAction)areaButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;

@end
