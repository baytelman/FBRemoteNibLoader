//
//  FMRemoteNibLoader.h
//  FMRemoteNibLoader
//
//  Created by Felipe Baytelman on 6/8/14.
//  Copyright (c) 2014 fitmob inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBDefines.h"

@interface FBRemoteNibLoader : NSObject
SINGLETON_HEADER(FBRemoteNibLoader)

- (UIViewController *)viewControllerWithNibName:(NSString*)nibName;
@end

@interface FBRemoteNibLoader (Cache)
- (void)loadRemoteNibsFrom:(NSURL *)fromURL completion:(void (^)(BOOL success))completion;
- (void)clearCache;
@end