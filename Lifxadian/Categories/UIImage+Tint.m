//
//  UIImage+Tint.m
//
//  Created by Matt Gemmell on 04/07/2010.
//  Copyright 2010 Instinctive Code.
//

#import "UIImage+Tint.h"
#import "UIColor+Extensions.h"

static NSCache *s_imageCache;

@implementation UIImage (MGTint)
+ (UIImage *)tintedImageNamed:(NSString *)imageName color:(UIColor *)tintColor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_imageCache = [[NSCache alloc] init];
    });
    
    if (tintColor == nil)
    {
        tintColor = [UIColor clearColor];
    }
    
    NSMutableDictionary *tints = [s_imageCache objectForKey:imageName];
    
    if (!tints)
    {
        UIImage *tintable = [UIImage imageNamed:imageName];
        if (!tintable)
            return nil;
        
        tints = [[NSMutableDictionary alloc] init];
        [tints setObject:tintable forKey:[[UIColor clearColor] hexValue]];
        
        [s_imageCache setObject:tints forKey:imageName];
    }
    
    UIImage *tinted = [tints objectForKey:[tintColor hexValue]];
    
    if (!tinted)
    {
        tinted = [[tints objectForKey:[[UIColor clearColor] hexValue]] imageTintedWithColor:tintColor];
        if (tinted)
            [tints setObject:tinted forKey:[tintColor hexValue]];
    }
    
    return tinted;
}

- (UIImage *)imageTintedWithColor:(UIColor *)color
{
	// This method is designed for use with template images, i.e. solid-coloured mask-like images.
	return [self imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}


- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
	if (color) {
		// Construct new image the same size as this one.
		UIImage *image;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
		if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
			UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
		} else {
			UIGraphicsBeginImageContext([self size]);
		}
#else
		UIGraphicsBeginImageContext([self size]);
#endif
		CGRect rect = CGRectZero;
		rect.size = [self size];
		
		// Composite tint color at its own opacity.
		[color set];
		UIRectFill(rect);
		
		// Mask tint color-swatch to this image's opaque mask.
		// We want behaviour like NSCompositeDestinationIn on Mac OS X.
		[self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
		
		// Finally, composite this image over the tinted mask at desired opacity.
		if (fraction > 0.0) {
			// We want behaviour like NSCompositeSourceOver on Mac OS X.
			[self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
		}
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return image;
	}
	
	return self;
}



@end
