//
//  FMRemoteNibLoader.m
//  FMRemoteNibLoader
//
//  Created by Felipe Baytelman on 6/8/14.
//  Copyright (c) 2014 fitmob inc. All rights reserved.
//

#import "FBRemoteNibLoader.h"
#import <objc/runtime.h>

#import <SBYZipArchive.h>

@interface FBRemoteNibLoader ()
@property (nonatomic, strong) NSURL * cachedFilesUrlDirectory;
@end

@implementation FBRemoteNibLoader
SINGLETON_BODY(FBRemoteNibLoader)

- (NSURL*)cachedFilesUrlDirectory
{
    if (!_cachedFilesUrlDirectory) {
        NSString * className = NSStringFromClass([self class]);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory
                                            inDomains:NSUserDomainMask];
        NSURL *documentsDirectory = [URLs objectAtIndex:0];
        
        _cachedFilesUrlDirectory = [documentsDirectory URLByAppendingPathComponent:className];
    }
    return _cachedFilesUrlDirectory;
}

- (UIViewController *)viewControllerWithNibName:(NSString*)nibName
{
    Class class = NSClassFromString(nibName);
    if (!class) {
        return nil;
    }
    UIViewController * viewController = [class alloc];
    viewController = [viewController initWithNibName:nil bundle:nil];
    
    @try {
        nibName = [nibName stringByAppendingString:@".xib.bin"];
        NSURL * url = [self.cachedFilesUrlDirectory URLByAppendingPathComponent:nibName];
        
        NSData *data = [NSData dataWithContentsOfFile:url.path];
        UINib *nib = [UINib nibWithData:data bundle:nil];
        [nib instantiateWithOwner:viewController options:nil];
    }
    @catch (NSException *exception) {
    }
    return viewController;
}
@end

@implementation FBRemoteNibLoader (Cache)

- (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator* en = [fileManager enumeratorAtPath:self.cachedFilesUrlDirectory.path];
    NSError* err = nil;
    BOOL res;
    
    NSString* file;
    while (file = [en nextObject]) {
        res = [fileManager removeItemAtPath:[self.cachedFilesUrlDirectory.path stringByAppendingPathComponent:file] error:&err];
        if (!res && err) {
            NSLog(@"oops: %@", err);
        }
    }
    [fileManager removeItemAtPath:self.cachedFilesUrlDirectory.path error:&err];
}

- (void)loadRemoteNibsFrom:(NSURL *)fromURL completion:(void (^)(BOOL success))completion
{
	NSURLRequest *request = [NSURLRequest requestWithURL:fromURL];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDownloadTask *downloadTask = [session
                                              downloadTaskWithRequest:request
                                              completionHandler:^(NSURL *downloadURL, NSURLResponse *response, NSError *error) {
                                                  NSLog(@"didFinishDownloadToURL: Copying image file");
                                                  
                                                  NSFileManager *fileManager = [NSFileManager defaultManager];
                                                  
                                                  @try {
                                                      [fileManager createDirectoryAtURL:self.cachedFilesUrlDirectory
                                                            withIntermediateDirectories:YES
                                                                             attributes:nil
                                                                                  error:&error];
                                                  }
                                                  @catch (NSException *exception) {
                                                  }
                                                  
                                                  NSURL *destinationURL = [self.cachedFilesUrlDirectory URLByAppendingPathComponent:[fromURL
                                                                                                                                     lastPathComponent]];
                                                  
                                                  // Remove file at the destination if it already exists.
                                                  [fileManager removeItemAtURL:destinationURL error:NULL];
                                                  
                                                  BOOL success = [fileManager copyItemAtURL:downloadURL
                                                                                      toURL:destinationURL error:&error];
                                                  
                                                  if (success) {
                                                      SBYZipArchive *archive = [[SBYZipArchive alloc] initWithContentsOfFile:destinationURL.path
                                                                                                                       error:nil];
                                                      
                                                      [archive loadEntries:nil];
                                                      
                                                      for (SBYZipEntry * entry in archive.entries) {
                                                          NSData *data = entry.data;
                                                          NSString * name = entry.fileName;
                                                          NSURL * url = [self.cachedFilesUrlDirectory URLByAppendingPathComponent:name];
                                                          if ([data writeToFile:url.path
                                                                     atomically:YES]) {
                                                              NSLog(@"File decompressed: %@", url.path);
                                                          } else {
                                                              NSLog(@"File FAILED to be decompressed: %@", url.path);
                                                              completion(NO);
                                                              return;
                                                          }
                                                      }
                                                      completion(YES);
                                                      return;
                                                      
                                                  } else {
                                                      NSLog(@"File copy failed: %@", [error localizedDescription]);
                                                      completion(NO);
                                                      return;
                                                  }
                                              }];
    
	[downloadTask resume];
}

@end