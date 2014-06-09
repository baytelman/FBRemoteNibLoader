FBRemoteNibLoader
=================

iOS library that allows to fetch remote .xib compiled and compresed files, and to load UIViewControllers from fetched .xibs

FBRemoteNibLoader lets you fetch updated versions of NIB files without having to update your app in the AppStore

This doesn't include any compiled source code, so it should be fine by Apple guidelines. 

## USAGE

```objective-c
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
```

## REMOTE COMPRESSED FILE STRUCTURE

file.zip
* ViewController1ClassName.xib.bin
* ViewController2ClassName.xib.bin
* ViewController3ClassName.xib.bin

To create the .xib.bin files, user

```
ibtool original.xib --compile original.xib.bin
```

## DEMO

* Open the included XCode project (remember to get some pods: pod install).

* Run it once. If you hit "Show Popover" BEFORE hitting "Load remote nibs", you'll use the original .xib files.

* When you hit "Load remote nibs", FBRemoteNibLoader will fetch the remote (in this case, local) .zip and decompress it within the app's documents directory.

* Then, "Show Popover" will load using the cached .xib file, extracted from the zip.

## PENDING & CONTRIBUTE

These are the features I would like to include in the future:

* Create a POD description.
* Confim this doesn't get rejected by Apple.
* Get an entire bundle (images included).
* Update the images fetching mechanism, so if you get updated images in a downloaded bunch, use them in both new and OLD xib files.