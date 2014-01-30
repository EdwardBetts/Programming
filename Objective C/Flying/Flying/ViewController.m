//
//  ViewController.m
//  Flying
//
//  Created by Byron Coetsee on 2013/02/22.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import "ViewController.h"
#import "EditDetails.h"

@interface ViewController ()

@end

@implementation ViewController

int captin = 0;
double picHours = 0;
double duelHours = 0;
NSString *dateToday = @"";
NSString *oldDate = @"";


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.outletOldDate.text = @"test";
    self.outletOldDate.textColor = [UIColor redColor];
    
    
    //SET DATE
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YY"];
    dateToday = [formatter stringFromDate:[NSDate date]];
    self.outletDate.text = dateToday;
    
    oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldDate"];
    
    
    if ([dateToday isEqual:oldDate]) {
        
        self.outletFuel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"fuel"];
        self.outletFuel.textColor = [UIColor greenColor];
        self.outletTacho.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"tacho"];
        self.outletTacho.textColor = [UIColor greenColor];
        self.outletHobbs.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"hobbs"];
        self.outletHobbs.textColor = [UIColor greenColor];
    }
    else
    {
        self.outletFuel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"fuel"];
        self.outletFuel.textColor = [UIColor redColor];
        self.outletTacho.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"tacho"];
        self.outletTacho.textColor = [UIColor redColor];
        self.outletHobbs.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"hobbs"];
        self.outletHobbs.textColor = [UIColor redColor];
    }
    [defaults setObject:dateToday forKey:@"oldDate"];
    self.outletOldDate.text = oldDate;
    
    // LOADS DATA
    
    self.outletPIC.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pic"];
    self.outletDuel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"duel"];
    self.outletTotal.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"finalHours"];
}

- (IBAction)btnUpdate:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![self.txtFuel.text isEqualToString:@""]) {
        self.outletFuel.text = self.txtFuel.text;
        self.outletFuel.textColor = [UIColor greenColor];
        
        [defaults setObject:self.txtFuel.text forKey:@"fuel"];
        [defaults synchronize];
    }
    
    if (![self.txtTacho.text isEqualToString:@""]) {
        
        self.outletTacho.text = self.txtTacho.text;
        self.outletTacho.textColor = [UIColor greenColor];
        
        [defaults setObject:self.txtTacho.text forKey:@"tacho"];
        [defaults synchronize];
    }
    
    
    if (![self.txtHobbs.text isEqualToString:@""]) {
        
        self.outletHobbs.text = self.txtHobbs.text;
        self.outletHobbs.textColor = [UIColor greenColor];
        
        [defaults setObject:self.txtHobbs.text forKey:@"hobbs"];
        [defaults synchronize];
    } 
}



- (IBAction)btnSave:(id)sender {
    
    //SAVE TEMP DATA
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //fuel
    if (![self.outletFuel.text isEqualToString:@""]) {
        [defaults setObject:self.txtFuel.text forKey:@"fuel"];
        [defaults synchronize];
    }
    
    //tacho
    if (![self.outletTacho.text isEqualToString:@""]) {
        [defaults setObject:self.txtTacho.text forKey:@"tacho"];
        [defaults synchronize];
    }
    
    //hobbs
    if (![self.outletHobbs.text isEqualToString:@""]) {
        [defaults setObject:self.txtHobbs forKey:@"hobbs"];
        [defaults synchronize];
    }
    
    NSString *PICHours = self.outletPIC.text;
    NSString *duelHours = self.outletDuel.text;
    NSString *hours = [self.txtHours.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    double PICHoursDouble = PICHours.doubleValue;
    double duelHoursDouble = duelHours.doubleValue;
    double hoursDouble = hours.doubleValue;
    double totalHours = 0.0;
    
    
    //SAVE PIC
    if (captin == 0) {
        totalHours = PICHoursDouble + hoursDouble;
        NSUserDefaults *saveString = [NSString stringWithFormat:@"%.1f", totalHours];
        [defaults setObject:saveString forKey:@"pic"];
        [defaults synchronize];
        self.outletPIC.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"pic"];
        
    }
    
    //SAVE DUEL
    if (captin == 1) {
        totalHours = duelHoursDouble + hoursDouble;
        NSUserDefaults *saveString = [NSString stringWithFormat:@"%.1f", totalHours];
        [defaults setObject:saveString forKey:@"duel"];
        [defaults synchronize];
        self.outletDuel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"duel"];
    }
    
    //CALCULATE AND SAVE TOTAL HOURS
    
    PICHours = self.outletPIC.text;
    duelHours = self.outletDuel.text;
    
    PICHoursDouble = PICHours.doubleValue;
    duelHoursDouble = duelHours.doubleValue;
    
    double finalHours = PICHoursDouble + duelHoursDouble;
    NSUserDefaults *saveString = [NSString stringWithFormat:@"%.1f", finalHours];
    [defaults setObject:saveString forKey:@"finalHours"];
    [defaults synchronize];
    
    self.outletTotal.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"finalHours"];
    
}
- (IBAction)btnCaptin:(id)sender {
    if (self.outletCaptin.selectedSegmentIndex == 0) {
        //PIC
        captin = 0;
    }
    if (self.outletCaptin.selectedSegmentIndex == 1) {
        //DUEL
        captin = 1;
    }
}

- (IBAction)btnBackground:(id)sender {
    [self.txtFuel resignFirstResponder];
    [self.txtTacho resignFirstResponder];
    [self.txtHobbs resignFirstResponder];
    [self.txtHours resignFirstResponder];
}

- (IBAction)btnDetails:(id)sender {
    UIAlertView *pass = [[UIAlertView alloc] initWithTitle:nil message:@"Enter Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    pass.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [pass show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *password = [alertView textFieldAtIndex:0];
    NSString *passcode = [NSString stringWithFormat:@"%@", password.text];
    
    if (buttonIndex == 1) {
        if ([passcode isEqual: @"boeing"]) {
            
            EditDetails *editDetails = [[EditDetails alloc] init];
            
            [self presentViewController:editDetails animated:YES completion:nil];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
