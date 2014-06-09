FBRemoteNibLoader
=================

iOS library that allows to fetch remote .xib compiled and compresed files, and to load UIViewControllers from fetched .xibs

* USAGE

// Load a view controller using FBRemoteNibLoader, instead of initWithNibName.
// If such nib has not been cached yet, it will user the original .xib file

UIViewController * vc = [[FBRemoteNibLoader sharedController] viewControllerWithNibName:@"ViewControllerClassName"];
[self presentViewController:vc
                   animated:YES
                 completion:^{
                     NSLog(@"Presented view controller");
                 }];


// In order to load a remote .zip file

NSURL * url = [NSURL URLWithString:@"http://localhost/nibs.zip"];
[[FBRemoteNibLoader sharedController] loadRemoteNibsFrom:url
                                              completion:^(BOOL success) {
                                                  NSLog(@"Success? %@", @(success));
                                              }];

// You can clear the cache, to use the original .xib files included in the file.

[[FBRemoteNibLoader sharedController] clearCache];

* REMOTE COMPRESSED FILE STRUCTURE

- file.zip
\ ViewController1ClassName.xib.bin
\ ViewController2ClassName.xib.bin
\ ViewController3ClassName.xib.bin

To create the .xib.bin files, user
ibtool original.xib --compile original.xib.bin