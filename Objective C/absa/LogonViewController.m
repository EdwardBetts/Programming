//
//  LogonViewController.m
//  absa
//
//  Created by Byron Coetsee on 2013/02/19.
//  Copyright (c) 2013 Byron. All rights reserved.
//

#import "LogonViewController.h"
#import "ViewController.h"

@implementation LogonViewController



@synthesize webViewLogon;

//@interface ViewController : UIViewController {
    //IBOutlet UIWebView *webView;


- (void)viewDidLoad
{
    //[super viewDidLoad];
	//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://ib.absa.co.za/ib/mb.do"]]];
    
    [webViewLogon loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://ib.absa.co.za/ib/AuthenticateW.do;jsessionid=00008BVtL36DrGVBo6975xpFpkW:11l21e8a2?_Uid_=1&_channelIdentifier_=W&_language_=en"]]];
}

@end
