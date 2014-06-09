//
//  SBYZipEntry.h
//  SBYZipArchive
//
//  Created by shoby on 2013/12/30.
//  Copyright (c) 2013 shoby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBYZipArchive;

@interface SBYZipEntry : NSObject
@property (weak, nonatomic, readonly)   SBYZipArchive *archive;
@property (copy, nonatomic, readonly)   NSString *fileName;
@property (assign, nonatomic, readonly) NSUInteger size;
@property (assign, nonatomic, readonly) NSUInteger offset;
@property (readonly) NSData *data;

- (id)initWithArchive:(SBYZipArchive *)archive
             fileName:(NSString *)fileName
                 size:(NSUInteger)size
               offset:(NSUInteger)offset;
@end
