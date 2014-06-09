//
//  SBYZipArchive.m
//  SBYZipArchive
//
//  Created by shoby on 2013/12/30.
//  Copyright (c) 2013 shoby. All rights reserved.
//

#import "SBYZipArchive.h"
#import "unzip.h"

NSString* const SBYZipArchiveErrorDomain = @"SBYZipArchiveErrorDomain";

@interface SBYZipArchive ()
@property (assign, nonatomic) unzFile unzFile;
@property (strong, nonatomic) NSMutableArray *cachedEntries;
@property (strong, nonatomic) dispatch_semaphore_t semaphore;

- (NSString *)localizedDescriptionForUnzError:(int)unzError;
@end

@implementation SBYZipArchive

- (id)initWithContentsOfFile:(NSString *)path error:(NSError **)error
{
    self = [super init];
    if (self) {
        self.unzFile = unzOpen([path UTF8String]);
        if (!self.unzFile) {
            if (error) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Cannot open the archive file."};
                *error = [NSError errorWithDomain:SBYZipArchiveErrorDomain code:SBYZipArchiveErrorCannotOpenFile userInfo:userInfo];
            }
            return nil;
        }
        
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc
{
    unzClose(self.unzFile);
}

- (NSArray *)entries
{
    if (!self.cachedEntries) {
        [self loadEntries:nil];
    }
    return self.cachedEntries;
}

- (NSData *)dataForEntry:(SBYZipEntry *)entry
{
    // start lock
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_semaphore_wait(self.semaphore, timeout);
    
    unzSetOffset(self.unzFile, entry.offset);
    
    unzOpenCurrentFile(self.unzFile);
    
    NSMutableData *data = [[NSMutableData alloc] initWithLength:entry.size];
    unzReadCurrentFile(self.unzFile, [data mutableBytes], (unsigned int)data.length);
    
    unzCloseCurrentFile(self.unzFile);
    
    // end lock
    dispatch_semaphore_signal(self.semaphore);
    
    return data;
}

- (BOOL)loadEntries:(NSError **)error
{
    self.cachedEntries = [NSMutableArray array];
    
    unzGoToFirstFile(self.unzFile);
    while (true) {
        unz_file_info file_info;
        char file_name[256];
        
        int unz_err = unzGetCurrentFileInfo(self.unzFile, &file_info, file_name, sizeof(file_name), NULL, 0, NULL, 0);
        if (unz_err != UNZ_OK) {
            if (error) {
                NSString *localizedDescription = [self localizedDescriptionForUnzError:unz_err];
                *error = [NSError errorWithDomain:SBYZipArchiveErrorDomain code:SBYZipArchiveErrorCannotGetFileInfo userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
            }
            return NO;
        }
        
        NSUInteger offset = unzGetOffset(self.unzFile);
        
        NSString *fileName = [NSString stringWithUTF8String:file_name];
        SBYZipEntry *entry = [[SBYZipEntry alloc] initWithArchive:self fileName:fileName size:file_info.uncompressed_size offset:offset];
        
        [self.cachedEntries addObject:entry];
        
        if (unzGoToNextFile(self.unzFile) != UNZ_OK) {
            break;
        }
    }
    
    return YES;
}

- (NSString *)localizedDescriptionForUnzError:(int)unzError
{
    NSString * localizedDescription = nil;
    
    switch (unzError) {
        case UNZ_BADZIPFILE:
            localizedDescription = @"The archive file seems to be incorrect format.";
            break;
        case UNZ_ERRNO:
            localizedDescription = [NSString stringWithFormat:@"Failed to read file: %s", strerror(errno)];
            break;
        default:
            localizedDescription = @"Failed to read file";
            break;
    }
    
    return localizedDescription;
}

@end
