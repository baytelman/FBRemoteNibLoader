# SBYZipArchive
[![Build Status](https://travis-ci.org/shoby/SBYZipArchive.svg?branch=master)](https://travis-ci.org/shoby/SBYZipArchive)

SBYZipArchive is a simple unzip library to extract files from a large archive.

You can extract contents without expanding the whole archive.

# Usage
```objc
NSString *path = @"zip_file_path";
SBYZipArchive *archive = [[SBYZipArchive alloc] initWithContentsOfFile:path error:nil];

[archive loadEntries:nil];

SBYZipEntry *entry = archive.entries[0];
NSData *data = entry.data;
```

# License
SBYZipArchive is licensed under the MIT license.

Included minizip is licensed under the zlib license.
