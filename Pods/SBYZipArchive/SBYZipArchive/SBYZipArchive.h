//
//  SBYZipArchive.h
//  SBYZipArchive
//
//  Created by shoby on 2013/12/30.
//  Copyright (c) 2013 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBYZipEntry.h"

@interface SBYZipArchive : NSObject
@property (readonly) NSArray *entries;

- (id)initWithContentsOfFile:(NSString *)path error:(NSError **)error;

- (BOOL)loadEntries:(NSError **)error;

- (NSData *)dataForEntry:(SBYZipEntry *)entry;
@end


extern NSString* const SBYZipArchiveErrorDomain;

typedef NS_ENUM(NSInteger, SBYZipArchiveError)
{
    SBYZipArchiveErrorCannotOpenFile = 1,
    SBYZipArchiveErrorCannotGetFileInfo = 2,
};