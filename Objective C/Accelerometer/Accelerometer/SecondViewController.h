//
//  SecondViewController.h
//  Accelerometer
//
//  Created by Byron Coetsee on 2013/03/04.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIAccelerometerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *outletCurrent;
@property (strong, nonatomic) IBOutlet UITextField *outletMax;
@property (strong, nonatomic) IBOutlet UITextField *outletMin;
@property (strong, nonatomic) IBOutlet UITextField *outletAvg;
- (IBAction)btnClear:(id)sender;

@end
