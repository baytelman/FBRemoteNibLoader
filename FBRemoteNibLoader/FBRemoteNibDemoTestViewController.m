//
//  FMTestViewController.m
//  FMRemoteNibLoader
//
//  Created by Felipe Baytelman on 6/5/14.
//  Copyright (c) 2014 fitmob inc. All rights reserved.
//

#import "FBRemoteNibDemoTestViewController.h"

@interface FBRemoteNibDemoTestViewController ()

@end

@implementation FBRemoteNibDemoTestViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@"Closing");
                             }];
}

- (IBAction)anotherAction:(id)sender
{
    NSLog(@"Another action called from remote nib");
}
@end
