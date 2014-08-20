//
//  NSFileManager+Extensions.h
//  donna
//
//  Created by Arshad Tayyeb on 3/26/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extensions)
- (BOOL)ensureDirectoryExistsAtPath:(NSString *)path error:(NSError **)errorPtr;
- (BOOL)removeParentDirectoriesIfEmpty:(NSString *)path untilRootPath:(NSString *)rootPath error:(NSError **)error;
+ (NSString *)filePathForDocumentFileNamed:(NSString *)filename;
+ (NSString *)filePathForApplicationSupportFileNamed:(NSString *)filename;
+ (NSString *)filePathForCacheFileNamed:(NSString *)filename;
@end
