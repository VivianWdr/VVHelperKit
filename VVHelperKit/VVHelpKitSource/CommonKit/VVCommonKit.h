//
//  VVCommonKit.h
//  VVHelperKit
//
//  Created by Vivi on 16/11/17.
//  Copyright © 2016年 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

// Get Weak reference object.
#define kWeakObject(object) __weak __typeof(object) weak##object = object;

// Get weak reference object.
#define kWeak(caller, object) __weak __typeof(object) caller = object;

// Get strong reference object.
#define kStrongObject(object) __strong __typeof(object) strong##object = object;

// Get dispatch_get_main_queue()
#define kMainQueue (dispatch_get_main_queue())

// Get default dispatch_get_global_queue()
#define kGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

// Radians convert to degress.
#define kRadiansToDegress(radians) ((radians) * (180.0 / M_PI))

// Degress convert to radians.
#define kDegresToRadians(angle) ((angle) / 180.0 * M_PI)

// Fast to get iOS system version
#define kiOSVersion ([UIDevice currentDevice].systemVersion.floatValue)

// More fast way to get app delegate
#define kAppDelegate ((AppDelegate *)[[UIApplication  sharedApplication] delegate])

#pragma mark - Device Frame

// The current Xcode support iOS8 and above
#if IOS_VERSION_8_OR_LATER
// Get the screen's with.
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

// Get the screen's height.
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

// Get the screen's bounds.
#define kScreenBounds ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
// Get the screen's with.
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

// Get the screen's height.
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// Get the screen's bounds.
#define kScreenBounds [UIScreen mainScreen].bounds.size
#endif

// When Debug use NSLog
#ifdef DEBUG
#define DLog(...) NSLog(@"%s line:%d\n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#pragma mark - Generate Color

/**
 format: 0xFFFFFF
 */
#define k16RGBColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

/**
 format:22,22,22
 */
#define kRGBColor(r,g,b) ([UIColor colorWithRed:(r) / 255.0 \
green:(g)/255.0\
blue:(b)/255.0\
alpha:1])

/**
 format:22,22,22,0.5
 */
#define kRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r) / 255.0  \
green:(g) / 255.0  \
blue:(b) / 255.0  \
alpha:(a)])

//More easy way to use hex color to generate color.
#define KHexRGB(rgb) k16RGBColor(rgb)

//More easy way to generate a color object.
#define kRGB(r,g,b) kRGBColor(r,g,b)
//Moer easy way to generate a color object with rgb and alpha.
#define kRGBA(r,g,b,a) kRGBAColor(r, g, b, a)

#pragma mark - Load Font
// Generate font of size
#define kFontOfSize(size) [UIFont systemFontOfSize:size]

// Generate bold font of size
#define kBoldFontOfSize(size) [UIFont boldSystemFontOfSize:size]

#pragma mark - Load Image
// More easy way to load an image.
#define kImage(name) [UIImage imageNamed:name]

// More easy to load an image from file.
#define kImageOfFile(Name) ([UIImage imageWithContentsOfFile:[NSBoudle mainBoundle] pathForResource:Name ofType:nil])

#pragma mark - System Singletons

// Get NSUserDefault objecet

// Get NSNOtificationCenter object

// Post a notification from notification center.

// Get NSFileManager object

//

@interface VVCommonKit : NSObject

@end
