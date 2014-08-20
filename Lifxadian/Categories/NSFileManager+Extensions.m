//
//  NSFileManager+Extensions.m
//  donna
//
//  Created by Arshad Tayyeb on 3/26/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import "NSFileManager+Extensions.h"

@implementation NSFileManager (Extensions)
- (BOOL)ensureDirectoryExistsAtPath:(NSString *)path error:(NSError **)errorPtr
{
	BOOL isDirectory = NO;
	if (![self fileExistsAtPath:path isDirectory:&isDirectory]) {
		//Make sure this isn't just the case that the volume became unmounted
		NSArray *comps = [path pathComponents];
		
		if ([comps count] < 2)
			return NO; //can't happen
		
		return [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:errorPtr];
	}
	
	return isDirectory;
}

//Can be called recursively.
// Rootpath tells it where to stop when traversing up a directory chain; if you're only interested in deleting one directory, rootpath should be:
// [path stringByDeletingLastPathComponent]
- (BOOL)removeParentDirectoriesIfEmpty:(NSString *)path untilRootPath:(NSString *)rootPath error:(NSError **)error
{
	if (rootPath == nil || ![[NSFileManager defaultManager] fileExistsAtPath:rootPath] )
	{
		NSLog(@"removeParentDirectoriesIfEmpty: will not delete without rootPath so I know where to stop");
		if (error != NULL)
			*error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:[NSDictionary dictionaryWithObject:@"No rootpath given" forKey:@"error"]];
		return NO;
	}
	
	//if we've hit the root path, stop here
	if ([path isEqualToString:rootPath] || [path length] < [rootPath length])
	{
		if (error != NULL)
			*error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:[NSDictionary dictionaryWithObject:@"No directory found" forKey:@"error"]];
		return NO;
	}
	
	//check if this is a directory
	BOOL isDirectory;
	if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory)
	{
		//Is not a directory!
		return NO;
	}
	
	//check if directory is empty
	NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:error];
	if (!contents)
	{
		return NO;
	}
	if ([contents count] > 0)
	{
		if (error != NULL)
			*error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:[NSDictionary dictionaryWithObject:@"Directory not empty" forKey:@"error"]];
		return NO;
	}
    
	// delete it!
	[[NSFileManager defaultManager] removeItemAtPath:path error:error];
    
    
	NSString *parent = [path stringByDeletingLastPathComponent];
	if ([parent length] > [rootPath length])
	{
		//recursive internal calls are non fatal, expected to fail at some point. 
		[self removeParentDirectoriesIfEmpty:parent untilRootPath:rootPath error:nil];
	}
	
	return (error == nil);
}
#pragma mark -


+ (NSString *)filePathForDocumentFileNamed:(NSString *)filename {
    static NSString *s_documentsDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        s_documentsDirectory = [paths objectAtIndex:0];
    });
    
    return [s_documentsDirectory stringByAppendingPathComponent:filename];
}

+ (NSString *)filePathForApplicationSupportFileNamed:(NSString *)filename {
    static NSString *s_appSupportDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        s_appSupportDirectory = [paths objectAtIndex:0];
    });
    
    return [s_appSupportDirectory stringByAppendingPathComponent:filename];
}

+ (NSString *)filePathForCacheFileNamed:(NSString *)filename {
    static NSString *s_cacheDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        s_cacheDirectory = [paths objectAtIndex:0];
    });
    
    return [s_cacheDirectory stringByAppendingPathComponent:filename];
}


@end
