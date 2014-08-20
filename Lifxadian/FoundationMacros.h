//
//  FoundationMacros.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//


#ifndef IL_FoundationMacros_h
#define IL_FoundationMacros_h

#define SINGLETON_IMPLEMENTATION(klass) \
static klass* sharedInstance = nil; \
@implementation klass (Singleton) \
+ (klass*) sharedInstance { \
@synchronized(self) { \
if (sharedInstance == nil) { \
sharedInstance = [[klass alloc] init]; \
} \
} \
return sharedInstance; \
} \
@end

#define SINGLETON_INTERFACE(klass) \
@interface klass (Singleton) \
+ (klass*) sharedInstance; \
@end

#define ILIsEqualOrBothNil(a,b)  ((a==nil&&b==nil) || [a isEqual:b])

#define ILIsStringWithAnyText(potentialString)  (potentialString!=nil && [potentialString isKindOfClass:[NSString class]] && [potentialString length]>0)
#define ILIsArrayWithAnyObjects(potentialArray) (potentialArray!=nil && [potentialArray isKindOfClass:[NSArray class]] && [potentialArray count]>0)
#define ILIsDictionaryWithAnyObjects(potentialDict) (potentialDict!=nil && [potentialDict isKindOfClass:[NSDictionary class]] && [potentialDict count]>0)
#define ILIsNonEmptyData(potential)  (potential!=nil && [potential isKindOfClass:[NSData class]] && [potential length]>0)

#define RangeForEntireString(aString) NSRangeFromString([NSString stringWithFormat:@"(%d,%d}", 0, [aString length]])
#define ILIsValidIndexIntoArray(index, array)   (index >= 0 && index < [array count])
#endif