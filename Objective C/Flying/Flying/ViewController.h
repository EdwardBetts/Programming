//
//  ViewController.h
//  Flying
//
//  Created by Byron Coetsee on 2013/02/22.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *outletDate;
@property (strong, nonatomic) IBOutlet UILabel *outletFuel;
@property (strong, nonatomic) IBOutlet UILabel *outletTacho;
@property (strong, nonatomic) IBOutlet UILabel *outletHobbs;
- (IBAction)btnSave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *outletPIC;
@property (strong, nonatomic) IBOutlet UITextField *outletDuel;
@property (strong, nonatomic) IBOutlet UITextField *outletTotal;
- (IBAction)btnCaptin:(id)sender;
- (IBAction)btnUpdate:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *outletCaptin;
@property (strong, nonatomic) IBOutlet UITextField *txtFuel;
@property (strong, nonatomic) IBOutlet UITextField *txtTacho;
@property (strong, nonatomic) IBOutlet UITextField *txtHobbs;
@property (strong, nonatomic) IBOutlet UITextField *txtHours;
- (IBAction)btnBackground:(id)sender;
- (IBAction)btnDetails:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *outletOldDate;

@end
