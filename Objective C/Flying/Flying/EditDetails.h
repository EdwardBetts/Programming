//
//  EditDetails.h
//  Flying
//
//  Created by Byron Coetsee on 2013/02/22.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDetails : UIViewController
- (IBAction)btnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *changePIC;
@property (strong, nonatomic) IBOutlet UITextField *changeDuel;
- (IBAction)btnSaveChanges:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *outletStatus;

@end
