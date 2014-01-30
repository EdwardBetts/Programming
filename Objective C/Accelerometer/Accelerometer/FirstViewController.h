//
//  FirstViewController.h
//  Accelerometer
//
//  Created by Byron Coetsee on 2013/03/04.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIAccelerometerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *outletX;
@property (strong, nonatomic) IBOutlet UITextField *outletY;
@property (strong, nonatomic) IBOutlet UITextField *outletZ;
@property (strong, nonatomic) IBOutlet UITextField *outletTotal;

@end
