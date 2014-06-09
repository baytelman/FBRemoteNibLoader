//
//  FMViewController.m
//  FMRemoteNibLoader
//
//  Created by Felipe Baytelman on 6/5/14.
//  Copyright (c) 2014 Felipe Baytelman. All rights reserved.
//

#import "FBRemoteNibDemoViewController.h"

#import "FBRemoteNibLoader.h"
#import "FBRemoteNibDemoTestViewController.h"

@interface FBRemoteNibDemoViewController ()

@end

@implementation FBRemoteNibDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FBRemoteNibLoader sharedController] clearCache];
}
- (IBAction)loadRemoteNibs:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"http://localhost/nibs.zip"];
    // OR A LOCAL ONE
    url =  [[NSBundle mainBundle] URLForResource:@"nibs" withExtension:@"zip"];
    [[FBRemoteNibLoader sharedController] loadRemoteNibsFrom:url
                                                  completion:^(BOOL success) {
                                                      NSLog(@"Success? %@", @(success));
                                                  }];
}

- (IBAction)pushView:(id)sender
{
    FBRemoteNibDemoTestViewController * vc = (FBRemoteNibDemoTestViewController*)[[FBRemoteNibLoader sharedController] viewControllerWithNibName:@"FBRemoteNibDemoTestViewController"];
    [self presentViewController:vc
                       animated:YES
                     completion:^{
                         NSLog(@"Presented view controller");
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
