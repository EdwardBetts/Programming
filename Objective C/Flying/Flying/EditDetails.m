//
//  EditDetails.m
//  Flying
//
//  Created by Byron Coetsee on 2013/02/22.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import "EditDetails.h"
#import "ViewController.h"

@interface EditDetails ()

@end

@implementation EditDetails

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
    /*
    
    self.changePIC.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pic"];
    self.changeDuel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"duel"];
    self.outletStatus.text = @"";
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnBack:(id)sender {
    /*
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
     */
}
- (IBAction)btnSaveChanges:(id)sender {
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.changePIC.text forKey:@"pic"];
    [defaults setObject:self.changeDuel forKey:@"duel"];
    self.outletStatus.text = @"Saved!";
     */
}
@end
