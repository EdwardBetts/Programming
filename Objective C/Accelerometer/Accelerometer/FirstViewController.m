//
//  FirstViewController.m
//  Accelerometer
//
//  Created by Byron Coetsee on 2013/03/04.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    double xAxis = acceleration.x;
    double yAxis = acceleration.y;
    
    
    if (zAxis<0) {
        zAxis = zAxis - zAxis - zAxis;
    }
    if (yAxis<0) {
        yAxis = yAxis - yAxis - yAxis;
    }
    if (xAxis<0) {
        xAxis = xAxis - xAxis - xAxis;
    }
    
    double total = zAxis + yAxis + xAxis;
    
    self.outletX.text = [NSString stringWithFormat:@"%.1f", xAxis];
    self.outletY.text = [NSString stringWithFormat:@"%.1f", yAxis];
    self.outletZ.text = [NSString stringWithFormat:@"%.1f", zAxis];
    self.outletTotal.text = [NSString stringWithFormat:@"%.1f", total];
    
    
    
    }
    


@end
