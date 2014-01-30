//
//  SecondViewController.m
//  Accelerometer
//
//  Created by Byron Coetsee on 2013/03/04.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

double max = 0;
double min = 0;
double avg = 0;
double total = 0;
double count = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = self;
    acc.updateInterval = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    double zAxis = acceleration.z;
    count++;
    total = total + zAxis;
    avg = total/count;
    
    zAxis = zAxis * (-1);
    
    if (zAxis>max) {
        max = zAxis;
    }
    if (zAxis<min) {
        min = zAxis;
    }
    
    self.outletMax.text = [NSString stringWithFormat:@"%.1f", max];
    self.outletMin.text = [NSString stringWithFormat:@"%.1f", min];
    self.outletAvg.text = [NSString stringWithFormat:@"%.1f", avg];
    self.outletCurrent.text = [NSString stringWithFormat:@"%.1f", zAxis];
    

}

- (IBAction)btnClear:(id)sender {
    self.outletMax.text = @"";
    max = 0;
    self.outletMin.text = @"";
    min = 0;
    self.outletAvg.text = @"";
    avg = 0;
    
    CGRect frame = self.outletMax.frame;
    frame.origin.x = 500;
    frame.origin.y = 500;
    self.outletMax.frame = frame;
}
@end
