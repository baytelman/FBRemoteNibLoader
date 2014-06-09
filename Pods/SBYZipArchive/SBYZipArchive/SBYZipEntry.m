//
//  SBYZipEntry.m
//  SBYZipArchive
//
//  Created by shoby on 2013/12/30.
//  Copyright (c) 2013 shoby. All rights reserved.
//

#import "SBYZipEntry.h"
#import "SBYZipArchive.h"

@interface SBYZipEntry ()
@property (weak, nonatomic, readwrite)   SBYZipArchive *archive;
@property (copy, nonatomic, readwrite)   NSString *fileName;
@property (assign, nonatomic, readwrite) NSUInteger size;
@property (assign, nonatomic, readwrite) NSUInteger offset;
@end

@implementation SBYZipEntry

- (id)initWithArchive:(SBYZipArchive *)archive fileName:(NSString *)fileName size:(NSUInteger)size offset:(NSUInteger)offset
{
    self = [super init];
    if (self) {
        self.archive  = archive;
        self.fileName = fileName;
        self.size     = size;
        self.offset   = offset;
    }
    return self;
}

- (NSData *)data
{
    return [self.archive dataForEntry:self];
}

@end
